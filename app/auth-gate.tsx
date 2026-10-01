"use client";

import { FormEvent, useEffect, useState } from "react";
import type { Session } from "@supabase/supabase-js";
import { KeyRound, LoaderCircle, LogIn, PackageCheck, UserPlus } from "lucide-react";
import Dashboard from "./dashboard";
import { supabase } from "./supabase-client";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

async function syncShareSession(session: Session | null) {
  await fetch("/api/auth/session", {
    method: session ? "POST" : "DELETE",
    headers: session ? { Authorization: `Bearer ${session.access_token}` } : undefined,
  }).catch(() => {});
}

export default function AuthGate() {
  const [session, setSession] = useState<Session | null>(null);
  const [ready, setReady] = useState(false);
  const [mode, setMode] = useState<"login" | "signup">("login");
  const [busy, setBusy] = useState(false);
  const [message, setMessage] = useState("");
  const [recovering, setRecovering] = useState(false);

  useEffect(() => {
    if (window.location.hash.includes("type=recovery") || window.location.search.includes("type=recovery")) setRecovering(true);
    supabase.auth.getSession().then(({ data }) => {
      setSession(data.session);
      setReady(true);
      syncShareSession(data.session);
    });
    const { data } = supabase.auth.onAuthStateChange((event, next) => {
      if (event === "PASSWORD_RECOVERY") setRecovering(true);
      setSession(next);
      setReady(true);
      syncShareSession(next);
    });
    return () => data.subscription.unsubscribe();
  }, []);

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true);
    setMessage("");
    const form = new FormData(event.currentTarget);
    const email = String(form.get("email") ?? "").trim().toLowerCase();
    const password = String(form.get("password") ?? "");
    const name = String(form.get("name") ?? "").trim();
    try {
      if (mode === "login") {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
      } else {
        const { data, error } = await supabase.auth.signUp({
          email,
          password,
          options: { data: { full_name: name }, emailRedirectTo: window.location.origin },
        });
        if (error) throw error;
        if (!data.session) setMessage("Registrazione completata. Controlla la posta e conferma l’email, poi accedi.");
      }
    } catch (error) {
      const text = error instanceof Error ? error.message : "Accesso non riuscito";
      setMessage(text === "Invalid login credentials" ? "Email o password non corretti." : text);
    } finally {
      setBusy(false);
    }
  }

  async function signOut() {
    await supabase.auth.signOut();
    await syncShareSession(null);
  }

  async function updatePassword(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true);
    setMessage("");
    const form = new FormData(event.currentTarget);
    const password = String(form.get("password") ?? "");
    const confirmation = String(form.get("confirmation") ?? "");
    if (password !== confirmation) { setMessage("Le due password non coincidono."); setBusy(false); return; }
    const { error } = await supabase.auth.updateUser({ password });
    if (error) setMessage(error.message);
    else { setMessage("Password aggiornata correttamente."); setRecovering(false); }
    setBusy(false);
  }

  if (!ready) return <main className="grid min-h-screen place-items-center bg-[#101d2c] text-white"><LoaderCircle className="size-8 animate-spin text-orange-400"/></main>;
  if (session && recovering) return <main className="grid min-h-screen place-items-center bg-[#101d2c] p-5"><section className="w-full max-w-md rounded-[2rem] bg-white p-7 shadow-2xl sm:p-10"><div className="mb-5 grid size-12 place-items-center rounded-xl bg-orange-50 text-orange-600"><KeyRound/></div><h1 className="text-2xl font-bold">Scegli una nuova password</h1><p className="mt-1 text-sm text-slate-500">Inseriscila due volte per confermare la modifica.</p><form onSubmit={updatePassword} className="mt-7 space-y-4"><Input name="password" type="password" required minLength={6} autoComplete="new-password" placeholder="Nuova password" className="h-11"/><Input name="confirmation" type="password" required minLength={6} autoComplete="new-password" placeholder="Ripeti la nuova password" className="h-11"/>{message&&<p className="rounded-xl bg-red-50 p-3 text-sm text-red-700">{message}</p>}<Button disabled={busy} className="h-11 w-full bg-orange-500 hover:bg-orange-600">{busy?<LoaderCircle className="animate-spin"/>:<KeyRound/>}Salva nuova password</Button></form></section></main>;
  if (session) {
    const metadata = session.user.user_metadata ?? {};
    return <Dashboard signedInEmail={session.user.email ?? ""} signedInName={metadata.full_name || metadata.name || session.user.email?.split("@")[0] || "Utente"} onSignOut={signOut}/>;
  }

  return <main className="grid min-h-screen bg-[#101d2c] p-5 sm:place-items-center">
    <div className="mx-auto grid w-full max-w-5xl overflow-hidden rounded-[2rem] bg-white shadow-2xl md:grid-cols-[1.05fr_.95fr]">
      <section className="hidden bg-gradient-to-br from-[#14263a] to-[#0b1521] p-12 text-white md:flex md:flex-col md:justify-between">
        <div className="flex items-center gap-3"><div className="grid size-12 place-items-center rounded-2xl bg-orange-500"><PackageCheck/></div><div><div className="text-xl font-bold">Ordini Agenti</div><div className="text-sm text-slate-400">Rete commerciale</div></div></div>
        <div><h1 className="max-w-md text-4xl font-bold leading-tight">Ordini, clienti e consegne. Tutto in un solo posto.</h1><p className="mt-5 max-w-md text-slate-300">Accedi da qualsiasi dispositivo senza bisogno di un account ChatGPT.</p></div>
        <p className="text-xs text-slate-500">Accesso protetto con Supabase</p>
      </section>
      <section className="flex min-h-[620px] flex-col justify-center p-7 sm:p-12">
        <div className="mb-8 flex items-center gap-3 md:hidden"><div className="grid size-11 place-items-center rounded-xl bg-orange-500 text-white"><PackageCheck/></div><div><div className="font-bold">Ordini Agenti</div><div className="text-xs text-slate-500">Rete commerciale</div></div></div>
        <div className="mb-7 flex rounded-xl bg-slate-100 p-1"><button onClick={()=>{setMode("login");setMessage("")}} className={`flex-1 rounded-lg px-3 py-2 text-sm font-semibold ${mode==="login"?"bg-white shadow-sm":"text-slate-500"}`}>Accedi</button><button onClick={()=>{setMode("signup");setMessage("")}} className={`flex-1 rounded-lg px-3 py-2 text-sm font-semibold ${mode==="signup"?"bg-white shadow-sm":"text-slate-500"}`}>Registrati</button></div>
        <div className="mb-6"><div className="mb-3 grid size-11 place-items-center rounded-xl bg-orange-50 text-orange-600">{mode==="login"?<KeyRound/>:<UserPlus/>}</div><h2 className="text-2xl font-bold">{mode==="login"?"Bentornato":"Crea il tuo account"}</h2><p className="mt-1 text-sm text-slate-500">{mode==="login"?"Inserisci email e password per continuare.":"Se l’amministratore ti ha già inserito, usa la stessa email."}</p></div>
        <form onSubmit={submit} className="space-y-4">
          {mode==="signup"&&<div><label className="mb-1.5 block text-sm font-semibold">Nome e cognome</label><Input name="name" required autoComplete="name" placeholder="Mario Rossi" className="h-11"/></div>}
          <div><label className="mb-1.5 block text-sm font-semibold">Email</label><Input name="email" type="email" required autoComplete="email" placeholder="nome@azienda.it" className="h-11"/></div>
          <div><label className="mb-1.5 block text-sm font-semibold">Password</label><Input name="password" type="password" required minLength={6} autoComplete={mode==="login"?"current-password":"new-password"} placeholder="Almeno 6 caratteri" className="h-11"/></div>
          {message&&<p className={`rounded-xl p-3 text-sm ${message.startsWith("Registrazione completata")?"bg-emerald-50 text-emerald-700":"bg-red-50 text-red-700"}`}>{message}</p>}
          <Button disabled={busy} type="submit" className="h-11 w-full bg-orange-500 hover:bg-orange-600">{busy?<LoaderCircle className="animate-spin"/>:mode==="login"?<LogIn/>:<UserPlus/>}{mode==="login"?"Accedi":"Crea account"}</Button>
        </form>
      </section>
    </div>
  </main>;
}
