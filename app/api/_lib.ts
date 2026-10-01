import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from "../supabase-config";
import { runtimeEnv as env } from "../runtime-env";

export type AppUser = { id: number; email: string; name: string; role: "admin" | "agent"; active: number; has_avatar: number; avatar_updated_at: string | null };
export function db() { if (!env.DB) throw new Error("Database non disponibile"); return env.DB; }
export function bucket() { if (!env.BUCKET) throw new Error("Archivio file non disponibile"); return env.BUCKET; }
function cookieValue(request: Request, name: string) {
  const match = request.headers.get("cookie")?.match(new RegExp(`(?:^|;\\s*)${name}=([^;]*)`));
  return match ? decodeURIComponent(match[1]) : "";
}

export async function currentUser(request: Request): Promise<AppUser> {
  const authorization = request.headers.get("authorization") ?? "";
  const token = authorization.startsWith("Bearer ") ? authorization.slice(7) : cookieValue(request, "sb-access-token");
  if (!token) throw new Response("Accesso richiesto", { status: 401 });
  const authResponse = await fetch(`${SUPABASE_URL}/auth/v1/user`, {
    headers: { apikey: SUPABASE_PUBLISHABLE_KEY, Authorization: `Bearer ${token}` },
  });
  if (!authResponse.ok) throw new Response("Sessione scaduta. Accedi nuovamente.", { status: 401 });
  const authUser = await authResponse.json() as { email?: string; user_metadata?: Record<string, unknown> };
  const email = String(authUser.email ?? "").trim().toLowerCase();
  if (!email) throw new Response("L’account non contiene un indirizzo email valido", { status: 401 });
  const metadata = authUser.user_metadata ?? {};
  const displayName = String(metadata.full_name ?? metadata.name ?? email.split("@")[0]).trim();
  const database = db();
  let user = await database.prepare("SELECT id,email,name,role,active,CASE WHEN avatar_object_key IS NULL THEN 0 ELSE 1 END has_avatar,avatar_updated_at FROM users WHERE lower(email)=lower(?)").bind(email).first<AppUser>();
  if (!user) {
    const count = await database.prepare("SELECT count(*) AS n FROM users").first<{ n: number }>();
    const now = new Date().toISOString();
    const role = (count?.n ?? 0) === 0 ? "admin" : "agent";
    try {
      await database.prepare("INSERT INTO users(email,name,role,active,created_at) VALUES(?,?,?,?,?)").bind(email, displayName, role, 1, now).run();
    } catch {
      // Un accesso simultaneo può aver già creato lo stesso utente.
    }
    if ((count?.n ?? 0) === 0) {
      await database.batch(["Napoli", "Tari", "Torre del Greco", "Sicilia", "Oromare"].map(name => database.prepare("INSERT OR IGNORE INTO territories(name,created_at) VALUES(?,?)").bind(name, now)));
    }
    user = await database.prepare("SELECT id,email,name,role,active,CASE WHEN avatar_object_key IS NULL THEN 0 ELSE 1 END has_avatar,avatar_updated_at FROM users WHERE lower(email)=lower(?)").bind(email).first<AppUser>();
  }
  if (!user || !user.active) throw new Response("Utente non abilitato. Contatta un amministratore.", { status: 403 });
  return user;
}
export function failure(error: unknown) {
  if (error instanceof Response) return error;
  const message = error instanceof Error ? error.message : "Errore imprevisto";
  return Response.json({ error: message }, { status: 500 });
}
