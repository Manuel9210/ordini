# Backup Supabase — Gestione Ordini Agenti

Esportazione logica del progetto Supabase `ulzhaqmklrplooccbxzx`, creata il 2026-09-17T18:04:38.499115+00:00.

## Contenuto

- `auth-export.json`: 5 account Auth e 5 identità, compresi gli hash delle password.
- `restore_auth.sql`: ripristino degli account in un progetto Supabase nuovo e vuoto.
- `project.json`: metadati non segreti del progetto.
- `manifest.json`: riepilogo e controlli.

Non sono inclusi sessioni, refresh token, token monouso, chiavi API segrete o password in chiaro. Gli utenti conservano la password esistente, ma dovranno effettuare nuovamente l'accesso dopo la migrazione. Supabase Storage è vuoto e non contiene file. Non risultano tabelle applicative nello schema `public`: i dati operativi dell'app si trovano nel backup Cloudflare D1/R2 già incluso negli altri ZIP.

## Ripristino

1. Crea un nuovo progetto Supabase.
2. Nel nuovo progetto apri **SQL Editor**.
3. Assicurati che non vi siano già utenti Auth.
4. Incolla ed esegui `restore_auth.sql`.
5. Verifica che il risultato finale mostri 5 utenti e 5 identità.
6. Copia dal nuovo progetto **Project URL** e **Publishable/anon key**.
7. Aggiorna queste variabili nella configurazione del sito e ripubblica.
8. Verifica l'accesso con almeno un amministratore e un agente.

## Avvertenza di sicurezza

Il file contiene hash delle password e dati personali degli account. Conservalo in luogo riservato e invialo solo alla persona autorizzata. Non pubblicarlo sul web né inserirlo in un repository Git.

## Limiti

Questa è un'esportazione logica di emergenza compatibile con il piano Free, non un backup fisico Supabase. Le impostazioni Dashboard (provider OAuth, SMTP, redirect URL, template email, CAPTCHA, chiavi e segreti) devono essere riconfigurate manualmente. Per preservare l'intero progetto senza riconfigurazione, la soluzione preferibile è trasferire il progetto Supabase all'organizzazione del destinatario.

