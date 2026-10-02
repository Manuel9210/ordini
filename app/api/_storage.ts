const STORAGE_BUCKET = "ordini-files";

type PutOptions = {
  httpMetadata?: {
    contentType?: string;
    cacheControl?: string;
  };
};

type StoredObject = {
  body: ReadableStream<Uint8Array> | null;
  httpMetadata: {
    contentType?: string;
    cacheControl?: string;
  };
};

type SupabaseStorageOptions = {
  url: string;
  secret: string;
  bucket?: string;
  fetchImpl?: typeof fetch;
};

function encodedObjectKey(key: string) {
  const normalized = key.replace(/^\/+/, "");
  if (!normalized) throw new Error("Percorso file non valido");
  return normalized.split("/").map(encodeURIComponent).join("/");
}

function storageError(operation: string, status: number) {
  return new Error(`Operazione archivio non riuscita (${operation}, HTTP ${status})`);
}

export function createSupabaseStorage({
  url,
  secret,
  bucket = STORAGE_BUCKET,
  fetchImpl = fetch,
}: SupabaseStorageOptions) {
  const storageUrl = `${url.replace(/\/$/, "")}/storage/v1`;
  const authorizationHeaders = {
    apikey: secret,
    Authorization: `Bearer ${secret}`,
  };

  return {
    async put(key: string, value: BodyInit, options: PutOptions = {}) {
      const response = await fetchImpl(
        `${storageUrl}/object/${encodeURIComponent(bucket)}/${encodedObjectKey(key)}`,
        {
          method: "POST",
          headers: {
            ...authorizationHeaders,
            "Content-Type": options.httpMetadata?.contentType || "application/octet-stream",
            "Cache-Control": options.httpMetadata?.cacheControl || "private, max-age=300",
            "x-upsert": "true",
          },
          body: value,
        },
      );
      if (!response.ok) throw storageError("caricamento", response.status);
    },

    async get(key: string): Promise<StoredObject | null> {
      const response = await fetchImpl(
        `${storageUrl}/object/${encodeURIComponent(bucket)}/${encodedObjectKey(key)}`,
        { headers: authorizationHeaders },
      );
      if (response.status === 404) return null;
      if (!response.ok) throw storageError("lettura", response.status);
      return {
        body: response.body,
        httpMetadata: {
          contentType: response.headers.get("content-type") || undefined,
          cacheControl: response.headers.get("cache-control") || undefined,
        },
      };
    },

    async delete(key: string) {
      const response = await fetchImpl(
        `${storageUrl}/object/${encodeURIComponent(bucket)}`,
        {
          method: "DELETE",
          headers: {
            ...authorizationHeaders,
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ prefixes: [key.replace(/^\/+/, "")] }),
        },
      );
      if (!response.ok && response.status !== 404) {
        throw storageError("eliminazione", response.status);
      }
    },
  };
}

