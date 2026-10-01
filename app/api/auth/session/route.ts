import { SUPABASE_PUBLISHABLE_KEY, SUPABASE_URL } from "../../../supabase-config";

function clearCookie() {
  return "sb-access-token=; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=0";
}

export async function POST(request: Request) {
  const authorization = request.headers.get("authorization") ?? "";
  const token = authorization.startsWith("Bearer ") ? authorization.slice(7) : "";
  if (!token) return new Response("Sessione mancante", { status: 401 });
  const check = await fetch(`${SUPABASE_URL}/auth/v1/user`, { headers: { apikey: SUPABASE_PUBLISHABLE_KEY, Authorization: `Bearer ${token}` } });
  if (!check.ok) return new Response("Sessione non valida", { status: 401, headers: { "Set-Cookie": clearCookie() } });
  return Response.json({ ok: true }, { headers: { "Set-Cookie": `sb-access-token=${token}; Path=/; HttpOnly; Secure; SameSite=Lax; Max-Age=3600` } });
}

export async function DELETE() {
  return Response.json({ ok: true }, { headers: { "Set-Cookie": clearCookie() } });
}
