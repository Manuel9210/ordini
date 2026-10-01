const VERSION = "ordini-agenti-v14";
const SHARED_PHOTO = "/__shared-photo";

self.addEventListener("install", event => {
  event.waitUntil(self.skipWaiting());
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(key => key !== VERSION).map(key => caches.delete(key))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return;
  if (event.request.method === "POST" && url.pathname === "/share-target") {
    event.respondWith((async () => {
      try {
        const form = await event.request.formData();
        const file = form.get("file") || form.get("files");
        if (!(file instanceof File) || !file.size || !file.type.startsWith("image/") || file.size > 20 * 1024 * 1024) {
          return Response.redirect(new URL("/?shareError=invalid", event.request.url), 303);
        }
        const cache = await caches.open(VERSION);
        await cache.put(SHARED_PHOTO, new Response(file, { headers: { "Content-Type": file.type || "image/jpeg", "X-File-Name": encodeURIComponent(file.name || "foto-whatsapp.jpg") } }));
        return Response.redirect(new URL("/?sharedPhoto=1", event.request.url), 303);
      } catch {
        return Response.redirect(new URL("/?shareError=invalid", event.request.url), 303);
      }
    })());
    return;
  }
  if (event.request.method !== "GET") return;
  event.respondWith(fetch(event.request));
});
