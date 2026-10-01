import { bucket, currentUser, db, failure } from "../_lib";
export async function POST(request: Request) {
  try {
    const user = await currentUser(request); const form = await request.formData(); const file = form.get("file");
    if (!(file instanceof File) || file.size === 0) return new Response("File mancante", { status: 400 });
    if (file.size > 20 * 1024 * 1024) return new Response("File troppo grande (max 20 MB)", { status: 400 });
    const category = form.get("category") === "document" ? "document" : "order"; const orderId = Number(form.get("orderId")) || null;
    const documentId = category === "document" ? Number(form.get("documentId")) || null : null;
    const documentGroup = category === "document" ? String(form.get("documentGroup") || "Generale").trim() || "Generale" : "Generale";
    if (category === "document" && user.role !== "admin") return new Response("Solo l'amministratore può caricare documenti", { status: 403 });
    if (category === "order") { const order = await db().prepare("SELECT agent_id FROM orders WHERE id=?").bind(orderId).first<{agent_id:number}>(); if (!order || (user.role === "agent" && order.agent_id !== user.id)) return new Response("Vietato", { status: 403 }); }
    const key = `${category}/${crypto.randomUUID()}-${file.name.replace(/[^a-zA-Z0-9._-]/g, "_")}`; await bucket().put(key, await file.arrayBuffer(), { httpMetadata: { contentType: file.type || "application/octet-stream" } });
    if (documentId) {
      const previous = await db().prepare("SELECT object_key FROM files WHERE id=? AND category='document'").bind(documentId).first<{object_key:string}>();
      if (!previous) { await bucket().delete(key); return new Response("Documento non trovato", { status: 404 }); }
      await db().prepare("UPDATE files SET document_group=?,title=?,filename=?,content_type=?,object_key=? WHERE id=?").bind(documentGroup, String(form.get("title") || file.name), file.name, file.type || "application/octet-stream", key, documentId).run();
      await bucket().delete(previous.object_key);
      return Response.json({ ok: true });
    }
    await db().prepare("INSERT INTO files(order_id,uploaded_by,category,document_group,title,filename,content_type,object_key,created_at) VALUES(?,?,?,?,?,?,?,?,?)").bind(orderId, user.id, category, documentGroup, String(form.get("title") || file.name), file.name, file.type || "application/octet-stream", key, new Date().toISOString()).run();
    return Response.json({ ok: true });
  } catch (e) { return failure(e); }
}
