import { bucket, currentUser, db, failure } from "../../_lib";
export async function GET(request: Request, context: { params: Promise<{ id: string }> }) {
  try {
    const user = await currentUser(request); const { id } = await context.params;
    const row = await db().prepare("SELECT f.*,o.agent_id FROM files f LEFT JOIN orders o ON o.id=f.order_id WHERE f.id=?").bind(Number(id)).first<any>();
    if (!row || (row.category === "order" && user.role === "agent" && row.agent_id !== user.id)) return new Response("Non trovato", { status: 404 });
    const object = await bucket().get(row.object_key); if (!object) return new Response("File non trovato", { status: 404 });
    return new Response(object.body, { headers: {
      "Content-Type": row.content_type,
      "Content-Disposition": `inline; filename="${String(row.filename).replace(/\"/g, "")}"`,
      "Cache-Control": "private, max-age=300",
      "X-Content-Type-Options": "nosniff",
    } });
  } catch (e) { return failure(e); }
}
