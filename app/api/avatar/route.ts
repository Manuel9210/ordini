import { bucket, currentUser, db, failure } from "../_lib";

export async function POST(request: Request) {
  try {
    const user = await currentUser(request);
    if (user.role !== "admin") return new Response("Solo un amministratore può modificare le foto profilo", { status: 403 });
    const form = await request.formData();
    const targetId = Number(form.get("userId"));
    const file = form.get("file");
    if (!(file instanceof File) || !file.size) return new Response("Foto mancante", { status: 400 });
    if (!file.type.startsWith("image/")) return new Response("Seleziona un'immagine valida", { status: 400 });
    if (file.size > 5 * 1024 * 1024) return new Response("Foto troppo grande (massimo 5 MB)", { status: 400 });
    const target = await db().prepare("SELECT id,avatar_object_key FROM users WHERE id=?").bind(targetId).first<{ id: number; avatar_object_key: string | null }>();
    if (!target) return new Response("Utente non trovato", { status: 404 });
    const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_") || "profilo.jpg";
    const key = `avatars/${targetId}/${crypto.randomUUID()}-${safeName}`;
    await bucket().put(key, await file.arrayBuffer(), { httpMetadata: { contentType: file.type, cacheControl: "private, max-age=300" } });
    const now = new Date().toISOString();
    await db().prepare("UPDATE users SET avatar_object_key=?,avatar_content_type=?,avatar_updated_at=? WHERE id=?").bind(key, file.type, now, targetId).run();
    if (target.avatar_object_key) await bucket().delete(target.avatar_object_key);
    return Response.json({ ok: true, updatedAt: now });
  } catch (error) { return failure(error); }
}

export async function DELETE(request: Request) {
  try {
    const user = await currentUser(request);
    if (user.role !== "admin") return new Response("Solo un amministratore può modificare le foto profilo", { status: 403 });
    const targetId = Number((await request.json() as { userId?: number }).userId);
    const target = await db().prepare("SELECT avatar_object_key FROM users WHERE id=?").bind(targetId).first<{ avatar_object_key: string | null }>();
    if (!target) return new Response("Utente non trovato", { status: 404 });
    if (target.avatar_object_key) await bucket().delete(target.avatar_object_key);
    await db().prepare("UPDATE users SET avatar_object_key=NULL,avatar_content_type=NULL,avatar_updated_at=NULL WHERE id=?").bind(targetId).run();
    return Response.json({ ok: true });
  } catch (error) { return failure(error); }
}
