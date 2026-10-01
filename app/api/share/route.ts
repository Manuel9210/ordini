import { bucket, currentUser, db, failure } from "../_lib";

export async function POST(request: Request) {
  try {
    const user = await currentUser(request);
    const form = await request.formData();
    const file = form.get("file") ?? form.get("files");
    if (!(file instanceof File) || file.size === 0) return Response.redirect(new URL("/?shareError=missing", request.url), 303);
    if (!file.type.startsWith("image/")) return Response.redirect(new URL("/?shareError=type", request.url), 303);
    if (file.size > 20 * 1024 * 1024) return Response.redirect(new URL("/?shareError=size", request.url), 303);

    const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, "_") || "foto-whatsapp.jpg";
    const key = `order/${crypto.randomUUID()}-${safeName}`;
    await bucket().put(key, await file.arrayBuffer(), { httpMetadata: { contentType: file.type || "image/jpeg" } });
    const result = await db().prepare("INSERT INTO files(order_id,uploaded_by,category,document_group,title,filename,content_type,object_key,created_at) VALUES(NULL,?,'order','Generale',?,?,?,?,?)")
      .bind(user.id, "Foto condivisa da WhatsApp", safeName, file.type || "image/jpeg", key, new Date().toISOString()).run();
    return Response.redirect(new URL(`/?sharedFile=${Number(result.meta.last_row_id)}`, request.url), 303);
  } catch (error) {
    return failure(error);
  }
}
