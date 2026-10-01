import { bucket, currentUser, db, failure } from "../../_lib";

export async function GET(request: Request, context: { params: Promise<{ id: string }> }) {
  try {
    await currentUser(request);
    const { id } = await context.params;
    const row = await db().prepare("SELECT avatar_object_key,avatar_content_type FROM users WHERE id=?").bind(Number(id)).first<{ avatar_object_key: string | null; avatar_content_type: string | null }>();
    if (!row?.avatar_object_key) return new Response("Foto non trovata", { status: 404 });
    const object = await bucket().get(row.avatar_object_key);
    if (!object) return new Response("Foto non trovata", { status: 404 });
    return new Response(object.body, { headers: { "Content-Type": row.avatar_content_type || "image/jpeg", "Cache-Control": "private, max-age=300", "X-Content-Type-Options": "nosniff" } });
  } catch (error) { return failure(error); }
}
