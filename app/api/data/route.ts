import { bucket, currentUser, db, failure } from "../_lib";

type Database = ReturnType<typeof db>;

async function syncCompletion(database: Database, orderId: number, now: string) {
  const state = await database.prepare(
    "SELECT COUNT(*) total, SUM(CASE WHEN delivered_quantity < quantity THEN 1 ELSE 0 END) incomplete FROM order_items WHERE order_id=?"
  ).bind(orderId).first<{ total: number; incomplete: number }>();
  const complete = Number(state?.total) > 0 && Number(state?.incomplete) === 0;
  await database.prepare(
    complete
      ? "UPDATE orders SET completed_at=COALESCE(completed_at,?),updated_at=? WHERE id=?"
      : "UPDATE orders SET completed_at=NULL,updated_at=? WHERE id=?"
  ).bind(...(complete ? [now, now, orderId] : [now, orderId])).run();
}

async function deleteOrder(database: Database, orderId: number) {
  const stored = await database.prepare("SELECT object_key FROM files WHERE order_id=?")
    .bind(orderId).all<{ object_key: string }>();
  await Promise.all((stored.results ?? []).map(file => bucket().delete(file.object_key)));
  await database.batch([
    database.prepare("DELETE FROM files WHERE order_id=?").bind(orderId),
    database.prepare("DELETE FROM order_items WHERE order_id=?").bind(orderId),
    database.prepare("DELETE FROM orders WHERE id=?").bind(orderId),
  ]);
}

async function purgeExpiredOrders(database: Database) {
  const cutoff = new Date(Date.now() - 14 * 24 * 60 * 60 * 1000).toISOString();
  const expired = await database.prepare("SELECT id FROM orders WHERE completed_at IS NOT NULL AND completed_at<=?")
    .bind(cutoff).all<{ id: number }>();
  for (const order of expired.results ?? []) await deleteOrder(database, order.id);
}

export async function GET(request: Request) {
  try {
    const user = await currentUser(request);
    const database = db();
    const own = user.role === "agent";
    await purgeExpiredOrders(database);
    const clientWhere = own ? "WHERE c.agent_id=?" : "";
    const orderWhere = own ? "WHERE o.agent_id=?" : "";
    const [territories, agents, clients, orders, items, files] = await Promise.all([
      database.prepare("SELECT * FROM territories ORDER BY name").all(),
      database.prepare(user.role === "admin"
        ? "SELECT id,email,name,role,active,CASE WHEN avatar_object_key IS NULL THEN 0 ELSE 1 END has_avatar,avatar_updated_at FROM users ORDER BY name"
        : "SELECT id,name,role,active,CASE WHEN avatar_object_key IS NULL THEN 0 ELSE 1 END has_avatar,avatar_updated_at FROM users WHERE active=1 ORDER BY name").all(),
      database.prepare("SELECT c.*,t.name territory_name,u.name agent_name FROM clients c JOIN territories t ON t.id=c.territory_id JOIN users u ON u.id=c.agent_id " + clientWhere + " ORDER BY c.name")
        .bind(...(own ? [user.id] : [])).all(),
      database.prepare("SELECT o.*,c.name client_name,t.id territory_id,t.name territory_name,u.name agent_name FROM orders o JOIN clients c ON c.id=o.client_id JOIN territories t ON t.id=c.territory_id JOIN users u ON u.id=o.agent_id " + orderWhere + " ORDER BY o.updated_at DESC")
        .bind(...(own ? [user.id] : [])).all(),
      database.prepare("SELECT i.* FROM order_items i JOIN orders o ON o.id=i.order_id " + orderWhere + " ORDER BY i.id")
        .bind(...(own ? [user.id] : [])).all(),
      database.prepare("SELECT f.id,f.order_id,f.category,f.document_group,f.title,f.filename,f.content_type,f.created_at FROM files f LEFT JOIN orders o ON o.id=f.order_id WHERE f.category='document' OR " + (own ? "o.agent_id=?" : "1=1") + " ORDER BY CASE WHEN f.category='document' THEN lower(f.title) END ASC,f.created_at DESC")
        .bind(...(own ? [user.id] : [])).all(),
    ]);
    return Response.json({
      me: user,
      territories: territories.results,
      agents: agents.results,
      clients: clients.results,
      orders: orders.results,
      items: items.results,
      files: files.results,
    });
  } catch (e) { return failure(e); }
}

export async function POST(request: Request) {
  try {
    const user = await currentUser(request);
    const database = db();
    const body = await request.json() as Record<string, any>;
    const now = new Date().toISOString();

    if (body.action === "territory") {
      if (user.role !== "admin") return new Response("Vietato", { status: 403 });
      await database.prepare("INSERT INTO territories(name,created_at) VALUES(?,?)").bind(String(body.name).trim(), now).run();
    } else if (body.action === "territoryUpdate") {
      if (user.role !== "admin") return new Response("Solo un amministratore può modificare le zone", { status: 403 });
      const territoryId = Number(body.territoryId);
      const name = String(body.name ?? "").trim();
      if (!name) return new Response("Il nome della zona è obbligatorio", { status: 400 });
      const territory = await database.prepare("SELECT id FROM territories WHERE id=?").bind(territoryId).first();
      if (!territory) return new Response("Zona non trovata", { status: 404 });
      await database.prepare("UPDATE territories SET name=? WHERE id=?").bind(name, territoryId).run();
    } else if (body.action === "territoryDelete") {
      if (user.role !== "admin") return new Response("Solo un amministratore può eliminare le zone", { status: 403 });
      const territoryId = Number(body.territoryId);
      const clients = await database.prepare("SELECT count(*) AS n FROM clients WHERE territory_id=?").bind(territoryId).first<{ n: number }>();
      if ((clients?.n ?? 0) > 0) return new Response("Questa zona contiene clienti e non può essere eliminata finché non vengono spostati", { status: 409 });
      await database.prepare("DELETE FROM territories WHERE id=?").bind(territoryId).run();
    } else if (body.action === "agent") {
      if (user.role !== "admin") return new Response("Solo un amministratore può creare utenti", { status: 403 });
      const role = body.role === "admin" ? "admin" : "agent";
      await database.prepare("INSERT INTO users(email,name,role,active,created_at) VALUES(?,?,?,?,?)")
        .bind(String(body.email).trim().toLowerCase(), String(body.name).trim(), role, 1, now).run();
    } else if (body.action === "userUpdate") {
      if (user.role !== "admin") return new Response("Solo un amministratore può modificare gli utenti", { status: 403 });
      const targetId = Number(body.userId);
      const name = String(body.name ?? "").trim();
      const email = String(body.email ?? "").trim().toLowerCase();
      const role = body.role === "admin" ? "admin" : "agent";
      const target = await database.prepare("SELECT id,email,role FROM users WHERE id=?").bind(targetId)
        .first<{ id: number; email: string; role: "admin" | "agent" }>();
      if (!target) return new Response("Utente non trovato", { status: 404 });
      if (!name || !email) return new Response("Nome ed email sono obbligatori", { status: 400 });
      if (target.id === user.id && (email !== target.email.toLowerCase() || role !== "admin")) return new Response("Non puoi modificare la tua email o rimuovere il tuo ruolo di amministratore", { status: 400 });
      if (target.role === "admin" && role === "agent") {
        const admins = await database.prepare("SELECT count(*) AS n FROM users WHERE role='admin' AND active=1").first<{ n: number }>();
        if ((admins?.n ?? 0) <= 1) return new Response("Deve rimanere almeno un amministratore", { status: 400 });
      }
      await database.prepare("UPDATE users SET name=?,email=?,role=? WHERE id=?").bind(name, email, role, targetId).run();
    } else if (body.action === "userDelete") {
      if (user.role !== "admin") return new Response("Solo un amministratore può eliminare gli utenti", { status: 403 });
      const targetId = Number(body.userId);
      if (targetId === user.id) return new Response("Non puoi eliminare il tuo account mentre lo stai utilizzando", { status: 400 });
      const target = await database.prepare("SELECT id,role,avatar_object_key FROM users WHERE id=?").bind(targetId).first<{ id: number; role: "admin" | "agent"; avatar_object_key: string | null }>();
      if (!target) return new Response("Utente non trovato", { status: 404 });
      if (target.role === "admin") {
        const admins = await database.prepare("SELECT count(*) AS n FROM users WHERE role='admin' AND active=1").first<{ n: number }>();
        if ((admins?.n ?? 0) <= 1) return new Response("Deve rimanere almeno un amministratore", { status: 400 });
      }
      const [clients, orders, files] = await Promise.all([
        database.prepare("SELECT count(*) AS n FROM clients WHERE agent_id=?").bind(targetId).first<{ n: number }>(),
        database.prepare("SELECT count(*) AS n FROM orders WHERE agent_id=?").bind(targetId).first<{ n: number }>(),
        database.prepare("SELECT count(*) AS n FROM files WHERE uploaded_by=?").bind(targetId).first<{ n: number }>(),
      ]);
      if ((clients?.n ?? 0) + (orders?.n ?? 0) + (files?.n ?? 0) > 0) return new Response("Questo utente ha clienti, ordini o file collegati e non può essere eliminato senza perdere dati", { status: 409 });
      if (target.avatar_object_key) await bucket().delete(target.avatar_object_key);
      await database.prepare("DELETE FROM users WHERE id=?").bind(targetId).run();
    } else if (body.action === "client") {
      const agentId = user.role === "admin" ? Number(body.agentId) : user.id;
      const name = String(body.name ?? "").trim();
      if (!name) return new Response("Il nome del cliente è obbligatorio", { status: 400 });
      const result = await database.prepare("INSERT INTO clients(name,contact,phone,address,territory_id,agent_id,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?)")
        .bind(name, body.contact ?? "", body.phone ?? "", body.address ?? "", Number(body.territoryId), agentId, now, now).run();
      return Response.json({ ok: true, clientId: Number(result.meta.last_row_id) });
    } else if (body.action === "clientUpdate") {
      const clientId = Number(body.clientId);
      const client = await database.prepare("SELECT id,agent_id FROM clients WHERE id=?").bind(clientId).first<{ id: number; agent_id: number }>();
      if (!client || (user.role === "agent" && client.agent_id !== user.id)) return new Response("Cliente non autorizzato", { status: 403 });
      const name = String(body.name ?? "").trim();
      if (!name) return new Response("Il nome del cliente è obbligatorio", { status: 400 });
      const agentId = user.role === "admin" ? Number(body.agentId) : user.id;
      await database.prepare("UPDATE clients SET name=?,contact=?,phone=?,address=?,territory_id=?,agent_id=?,updated_at=? WHERE id=?")
        .bind(name, body.contact ?? "", body.phone ?? "", body.address ?? "", Number(body.territoryId), agentId, now, clientId).run();
    } else if (body.action === "clientDelete") {
      const clientId = Number(body.clientId);
      const client = await database.prepare("SELECT id,agent_id FROM clients WHERE id=?").bind(clientId).first<{ id: number; agent_id: number }>();
      if (!client || (user.role === "agent" && client.agent_id !== user.id)) return new Response("Cliente non autorizzato", { status: 403 });
      const orders = await database.prepare("SELECT count(*) AS n FROM orders WHERE client_id=?").bind(clientId).first<{ n: number }>();
      if ((orders?.n ?? 0) > 0) return new Response("Il cliente ha ordini collegati e non può essere eliminato senza perdere lo storico", { status: 409 });
      await database.prepare("DELETE FROM clients WHERE id=?").bind(clientId).run();
    } else if (body.action === "documentUpdate") {
      if (user.role !== "admin") return new Response("Solo un amministratore può modificare i documenti", { status: 403 });
      const documentId = Number(body.documentId);
      const title = String(body.title ?? "").trim();
      const documentGroup = String(body.documentGroup ?? "").trim() || "Generale";
      if (!title) return new Response("Il titolo del documento è obbligatorio", { status: 400 });
      const document = await database.prepare("SELECT id FROM files WHERE id=? AND category='document'").bind(documentId).first();
      if (!document) return new Response("Documento non trovato", { status: 404 });
      await database.prepare("UPDATE files SET title=?,document_group=? WHERE id=?").bind(title, documentGroup, documentId).run();
    } else if (body.action === "documentDelete") {
      if (user.role !== "admin") return new Response("Solo un amministratore può eliminare i documenti", { status: 403 });
      const documentId = Number(body.documentId);
      const document = await database.prepare("SELECT id,object_key FROM files WHERE id=? AND category='document'").bind(documentId).first<{ id: number; object_key: string }>();
      if (!document) return new Response("Documento non trovato", { status: 404 });
      await bucket().delete(document.object_key);
      await database.prepare("DELETE FROM files WHERE id=?").bind(documentId).run();
    } else if (body.action === "order") {
      const client = await database.prepare("SELECT id,agent_id FROM clients WHERE id=?").bind(Number(body.clientId))
        .first<{ id: number; agent_id: number }>();
      if (!client || (user.role === "agent" && client.agent_id !== user.id)) return new Response("Cliente non autorizzato", { status: 403 });
      const requestedAgentId = Number(body.agentId) || user.id;
      const agent = await database.prepare("SELECT id FROM users WHERE id=? AND active=1").bind(requestedAgentId).first();
      if (!agent) return new Response("Agente non valido", { status: 400 });
      const rows = (body.items as Array<{ description: string; quantity: number }> ?? []).filter(x => String(x.description ?? "").trim());
      const result = await database.prepare("INSERT INTO orders(client_id,agent_id,notes,completed_at,created_at,updated_at) VALUES(?,?,?,NULL,?,?)")
        .bind(client.id, requestedAgentId, body.notes ?? "", now, now).run();
      const orderId = Number(result.meta.last_row_id);
      if (rows.length) await database.batch(rows.map(x => database.prepare(
        "INSERT INTO order_items(order_id,description,quantity,delivered_quantity,delivered,created_at) VALUES(?,?,?,0,0,?)"
      ).bind(orderId, x.description.trim(), Math.max(1, Number(x.quantity) || 1), now)));
      const sharedFileId = Number(body.sharedFileId);
      if (sharedFileId) await database.prepare("UPDATE files SET order_id=? WHERE id=? AND uploaded_by=? AND order_id IS NULL AND category='order'")
        .bind(orderId, sharedFileId, user.id).run();
      return Response.json({ ok: true, orderId });
    } else if (body.action === "orderUpdate") {
      const orderId = Number(body.orderId);
      const order = await database.prepare("SELECT id,agent_id FROM orders WHERE id=?").bind(orderId).first<{ id: number; agent_id: number }>();
      if (!order || (user.role === "agent" && order.agent_id !== user.id)) return new Response("Ordine non autorizzato", { status: 403 });
      const client = await database.prepare("SELECT id,agent_id FROM clients WHERE id=?").bind(Number(body.clientId)).first<{ id: number; agent_id: number }>();
      if (!client || (user.role === "agent" && client.agent_id !== user.id)) return new Response("Cliente non autorizzato", { status: 403 });
      const requestedAgentId = Number(body.agentId) || order.agent_id;
      const rows = (body.items as Array<{ description: string; quantity: number; deliveredQuantity?: number; delivered?: boolean }> ?? [])
        .filter(x => String(x.description ?? "").trim());
      if (!rows.length) return new Response("Inserisci almeno un articolo", { status: 400 });
      await database.prepare("UPDATE orders SET client_id=?,agent_id=?,notes=?,updated_at=? WHERE id=?")
        .bind(client.id, requestedAgentId, body.notes ?? "", now, orderId).run();
      await database.prepare("DELETE FROM order_items WHERE order_id=?").bind(orderId).run();
      await database.batch(rows.map(x => {
        const quantity = Math.max(1, Number(x.quantity) || 1);
        const deliveredQuantity = x.delivered ? quantity : Math.min(quantity, Math.max(0, Number(x.deliveredQuantity) || 0));
        return database.prepare("INSERT INTO order_items(order_id,description,quantity,delivered_quantity,delivered,created_at) VALUES(?,?,?,?,?,?)")
          .bind(orderId, String(x.description).trim(), quantity, deliveredQuantity, deliveredQuantity === quantity ? 1 : 0, now);
      }));
      await syncCompletion(database, orderId, now);
    } else if (body.action === "orderComplete") {
      const orderId = Number(body.orderId);
      const order = await database.prepare("SELECT id,agent_id FROM orders WHERE id=?").bind(orderId).first<{ id: number; agent_id: number }>();
      if (!order || (user.role === "agent" && order.agent_id !== user.id)) return new Response("Ordine non autorizzato", { status: 403 });
      await database.batch([
        database.prepare("UPDATE order_items SET delivered_quantity=quantity,delivered=1 WHERE order_id=?").bind(orderId),
        database.prepare("UPDATE orders SET completed_at=COALESCE(completed_at,?),updated_at=? WHERE id=?").bind(now, now, orderId),
      ]);
    } else if (body.action === "orderDelete") {
      const orderId = Number(body.orderId);
      const order = await database.prepare("SELECT id,agent_id FROM orders WHERE id=?").bind(orderId).first<{ id: number; agent_id: number }>();
      if (!order || (user.role === "agent" && order.agent_id !== user.id)) return new Response("Ordine non autorizzato", { status: 403 });
      await deleteOrder(database, orderId);
    } else if (body.action === "delivery") {
      const item = await database.prepare(
        "SELECT i.id,i.order_id,i.quantity,o.agent_id FROM order_items i JOIN orders o ON o.id=i.order_id WHERE i.id=?"
      ).bind(Number(body.itemId)).first<{ id: number; order_id: number; quantity: number; agent_id: number }>();
      if (!item || (user.role === "agent" && item.agent_id !== user.id)) return new Response("Vietato", { status: 403 });
      const deliveredQuantity = body.complete
        ? item.quantity
        : Math.min(item.quantity, Math.max(0, Number(body.deliveredQuantity) || 0));
      await database.prepare("UPDATE order_items SET delivered_quantity=?,delivered=? WHERE id=?")
        .bind(deliveredQuantity, deliveredQuantity === item.quantity ? 1 : 0, item.id).run();
      await syncCompletion(database, item.order_id, now);
    } else if (body.action === "orderNotes") {
      const order = await database.prepare("SELECT agent_id FROM orders WHERE id=?").bind(Number(body.orderId)).first<{ agent_id: number }>();
      if (!order || (user.role === "agent" && order.agent_id !== user.id)) return new Response("Vietato", { status: 403 });
      await database.prepare("UPDATE orders SET notes=?,updated_at=? WHERE id=?").bind(body.notes ?? "", now, Number(body.orderId)).run();
    } else {
      return new Response("Azione non valida", { status: 400 });
    }
    return Response.json({ ok: true });
  } catch (e) { return failure(e); }
}
