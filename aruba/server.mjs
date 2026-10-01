import { DatabaseSync } from "node:sqlite";
import { createServer } from "node:http";
import { Readable } from "node:stream";
import {
  copyFileSync,
  cpSync,
  existsSync,
  mkdirSync,
  readFileSync,
  rmSync,
  statSync,
  writeFileSync,
} from "node:fs";
import { dirname, extname, join, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const appRoot = resolve(here, "..");
const dataRoot = resolve(process.env.DATA_DIR || "/data");
const databasePath = join(dataRoot, "gestione_ordini.sqlite");
const objectsRoot = join(dataRoot, "r2");
const seedRoot = join(here, "seed");
const assetsRoot = join(appRoot, "dist", "client");

mkdirSync(dataRoot, { recursive: true });
mkdirSync(objectsRoot, { recursive: true });
if (!existsSync(databasePath)) copyFileSync(join(seedRoot, "gestione_ordini.sqlite"), databasePath);
if (!existsSync(join(dataRoot, ".r2-imported"))) {
  if (existsSync(join(seedRoot, "r2"))) cpSync(join(seedRoot, "r2"), objectsRoot, { recursive: true, force: false });
  writeFileSync(join(dataRoot, ".r2-imported"), new Date().toISOString() + "\n");
}

const sqlite = new DatabaseSync(databasePath);
sqlite.exec("PRAGMA foreign_keys=ON; PRAGMA journal_mode=WAL; PRAGMA busy_timeout=5000;");

function normalize(value) {
  if (typeof value === "boolean") return value ? 1 : 0;
  if (value === undefined) return null;
  return value;
}

class Statement {
  constructor(sql, values = []) {
    this.sql = sql;
    this.values = values;
  }
  bind(...values) {
    return new Statement(this.sql, values.map(normalize));
  }
  first(column) {
    const row = sqlite.prepare(this.sql).get(...this.values) ?? null;
    return column && row ? row[column] ?? null : row;
  }
  all() {
    return { results: sqlite.prepare(this.sql).all(...this.values), success: true, meta: {} };
  }
  run() {
    const result = sqlite.prepare(this.sql).run(...this.values);
    return {
      success: true,
      meta: {
        changes: Number(result.changes),
        last_row_id: Number(result.lastInsertRowid),
      },
    };
  }
}

const DB = {
  prepare(sql) {
    return new Statement(sql);
  },
  batch(statements) {
    const results = [];
    sqlite.exec("BEGIN IMMEDIATE");
    try {
      for (const statement of statements) results.push(statement.run());
      sqlite.exec("COMMIT");
      return results;
    } catch (error) {
      sqlite.exec("ROLLBACK");
      throw error;
    }
  },
};

function objectPath(key) {
  const target = resolve(objectsRoot, key);
  if (!target.startsWith(objectsRoot + sep)) throw new Error("Chiave file non valida");
  return target;
}

const BUCKET = {
  get(key) {
    const target = objectPath(key);
    if (!existsSync(target) || !statSync(target).isFile()) return null;
    const bytes = readFileSync(target);
    return {
      body: bytes,
      size: bytes.length,
      arrayBuffer: async () => bytes.buffer.slice(bytes.byteOffset, bytes.byteOffset + bytes.byteLength),
    };
  },
  put(key, value) {
    const target = objectPath(key);
    mkdirSync(dirname(target), { recursive: true });
    const bytes = value instanceof ArrayBuffer
      ? Buffer.from(value)
      : ArrayBuffer.isView(value)
        ? Buffer.from(value.buffer, value.byteOffset, value.byteLength)
        : Buffer.from(value);
    writeFileSync(target, bytes);
    return { key, size: bytes.length };
  },
  delete(key) {
    rmSync(objectPath(key), { force: true });
  },
};

const mimeTypes = new Map([
  [".css", "text/css; charset=utf-8"],
  [".html", "text/html; charset=utf-8"],
  [".ico", "image/x-icon"],
  [".jpeg", "image/jpeg"],
  [".jpg", "image/jpeg"],
  [".js", "text/javascript; charset=utf-8"],
  [".json", "application/json; charset=utf-8"],
  [".mjs", "text/javascript; charset=utf-8"],
  [".png", "image/png"],
  [".svg", "image/svg+xml"],
  [".webmanifest", "application/manifest+json"],
  [".woff", "font/woff"],
  [".woff2", "font/woff2"],
]);

const ASSETS = {
  fetch(request) {
    const pathname = decodeURIComponent(new URL(request.url).pathname);
    const relative = pathname.replace(/^\/+/, "");
    const target = resolve(assetsRoot, relative);
    if (!target.startsWith(assetsRoot + sep) || !existsSync(target) || !statSync(target).isFile()) {
      return new Response("Not Found", { status: 404 });
    }
    return new Response(readFileSync(target), {
      headers: {
        "content-type": mimeTypes.get(extname(target).toLowerCase()) || "application/octet-stream",
        "cache-control": relative.startsWith("assets/") ? "public, max-age=31536000, immutable" : "public, max-age=300",
      },
    });
  },
};

globalThis.__GESTIONE_ORDINI_ENV__ = { DB, BUCKET, ASSETS };
const workerModule = await import("../dist/server/index.js");
const worker = workerModule.default;

const server = createServer(async (incoming, outgoing) => {
  try {
    const protocol = String(incoming.headers["x-forwarded-proto"] || "http").split(",")[0].trim();
    const host = incoming.headers.host || "localhost";
    const url = new URL(incoming.url || "/", protocol + "://" + host);
    const method = incoming.method || "GET";
    const init = { method, headers: incoming.headers };
    if (method !== "GET" && method !== "HEAD") {
      init.body = Readable.toWeb(incoming);
      init.duplex = "half";
    }
    const pending = [];
    const context = {
      waitUntil(promise) {
        pending.push(Promise.resolve(promise).catch(console.error));
      },
      passThroughOnException() {},
    };
    const response = await worker.fetch(new Request(url, init), globalThis.__GESTIONE_ORDINI_ENV__, context);
    outgoing.statusCode = response.status;
    for (const [name, value] of response.headers) outgoing.setHeader(name, value);
    if (typeof response.headers.getSetCookie === "function") {
      const cookies = response.headers.getSetCookie();
      if (cookies.length) outgoing.setHeader("set-cookie", cookies);
    }
    if (!response.body) outgoing.end();
    else Readable.fromWeb(response.body).pipe(outgoing);
    void Promise.allSettled(pending);
  } catch (error) {
    console.error(error);
    if (!outgoing.headersSent) {
      outgoing.statusCode = 500;
      outgoing.setHeader("content-type", "text/plain; charset=utf-8");
    }
    outgoing.end("Errore interno");
  }
});

const port = Number(process.env.PORT || 8787);
server.listen(port, "0.0.0.0", () => {
  console.log("Gestione Ordini Agenti in ascolto sulla porta " + port);
});

function shutdown() {
  server.close(() => {
    sqlite.close();
    process.exit(0);
  });
}
process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
