import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";

const configPath = resolve(process.cwd(), "dist", "server", "wrangler.json");
const config = JSON.parse(await readFile(configPath, "utf8"));

config.name = "ordini";
config.topLevelName = "ordini";
config.d1_databases = [{ binding: "DB" }];
config.r2_buckets = [];

await writeFile(configPath, `${JSON.stringify(config)}\n`);
console.log("Prepared Cloudflare config with D1 and without R2.");
