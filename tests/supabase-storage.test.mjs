import assert from "node:assert/strict";
import test from "node:test";

import { createSupabaseStorage } from "../app/api/_storage.ts";

const projectUrl = "https://example.supabase.co";
const secret = "test-secret-never-logged";

test("uploads an ArrayBuffer with its content type and a private cache policy", async () => {
  let request;
  const storage = createSupabaseStorage({
    url: projectUrl,
    secret,
    fetchImpl: async (url, init) => {
      request = { url, init };
      return new Response("{}", { status: 200 });
    },
  });

  await storage.put("order/foto prova.jpg", new TextEncoder().encode("image").buffer, {
    httpMetadata: { contentType: "image/jpeg" },
  });

  assert.equal(request.url, `${projectUrl}/storage/v1/object/ordini-files/order/foto%20prova.jpg`);
  assert.equal(request.init.method, "POST");
  assert.equal(request.init.headers["Content-Type"], "image/jpeg");
  assert.equal(request.init.headers["Cache-Control"], "private, max-age=300");
  assert.equal(request.init.headers["x-upsert"], "true");
});

test("returns an R2-compatible body and preserves response metadata", async () => {
  const storage = createSupabaseStorage({
    url: projectUrl,
    secret,
    fetchImpl: async () => new Response("pdf-data", {
      headers: { "content-type": "application/pdf", "cache-control": "private, max-age=300" },
    }),
  });

  const object = await storage.get("document/example.pdf");
  assert.ok(object);
  assert.equal(await new Response(object.body).text(), "pdf-data");
  assert.equal(object.httpMetadata.contentType, "application/pdf");
});

test("preserves audio content types used by voice notes", async () => {
  let contentType;
  const storage = createSupabaseStorage({
    url: projectUrl,
    secret,
    fetchImpl: async (_url, init) => {
      contentType = init.headers["Content-Type"];
      return new Response("{}", { status: 200 });
    },
  });

  await storage.put("order/nota-vocale.webm", new ArrayBuffer(0), {
    httpMetadata: { contentType: "audio/webm" },
  });

  assert.equal(contentType, "audio/webm");
});

test("returns null for historical files missing from Storage", async () => {
  const storage = createSupabaseStorage({
    url: projectUrl,
    secret,
    fetchImpl: async () => new Response("not found", { status: 404 }),
  });

  assert.equal(await storage.get("document/missing.pdf"), null);
});

test("deletes only the requested object key", async () => {
  let request;
  const storage = createSupabaseStorage({
    url: projectUrl,
    secret,
    fetchImpl: async (url, init) => {
      request = { url, init };
      return new Response("[]", { status: 200 });
    },
  });

  await storage.delete("avatars/3/avatar.webp");

  assert.equal(request.url, `${projectUrl}/storage/v1/object/ordini-files`);
  assert.equal(request.init.method, "DELETE");
  assert.deepEqual(JSON.parse(request.init.body), { prefixes: ["avatars/3/avatar.webp"] });
});

test("does not include the secret or remote response body in errors", async () => {
  const storage = createSupabaseStorage({
    url: projectUrl,
    secret,
    fetchImpl: async () => new Response(`remote error ${secret}`, { status: 500 }),
  });

  await assert.rejects(
    storage.put("order/test.bin", new ArrayBuffer(0)),
    error => !error.message.includes(secret) && !error.message.includes("remote error"),
  );
});
