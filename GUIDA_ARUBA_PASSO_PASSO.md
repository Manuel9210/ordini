# Guida passo passo — pubblicazione su Aruba Cloud VPS

Backup creato il 17 settembre 2026. Questa procedura è destinata a un tecnico o a una persona con familiarità di base con SSH e DNS.

## 1. Cosa verrà trasferito

Il pacchetto contiene:

- versione 15 del sito e adattamento Node.js per Aruba;
- 5 utenti applicativi e 5 account di autenticazione;
- 5 territori;
- 68 clienti;
- 92 ordini;
- 175 righe d'ordine;
- 58 record di file;
- 61 oggetti fisici: 58 allegati/documenti e 3 avatar;
- database SQLite, esportazione SQL e JSON tabella per tabella.

Il backup rappresenta una fotografia dei dati tra le 17:06 e le 17:14 UTC del 17 settembre 2026. Gli ordini o i file creati successivamente sul vecchio sito non sono presenti in questa copia.

## 2. Attivare il server Aruba corretto

Nel pannello Aruba acquistare o attivare un **Cloud VPS/Cloud Server** con:

- Ubuntu 24.04 LTS;
- IPv4 pubblico;
- almeno 2 GB RAM;
- accesso SSH come `root` o come utente con `sudo`.

Un hosting condiviso Aruba non può eseguire direttamente questa applicazione.

Annotare:

- indirizzo IP del VPS;
- nome del dominio o sottodominio scelto, per esempio `ordini.miodominio.it`;
- credenziali SSH.

## 3. Configurare il DNS

Nel pannello DNS del dominio creare un record:

| Tipo | Nome | Valore |
| --- | --- | --- |
| A | `ordini` oppure `@` | indirizzo IPv4 del VPS |

Attendere la propagazione. Da un computer verificare:

```bash
nslookup ordini.miodominio.it
```

Il risultato deve mostrare l'IP del VPS.

## 4. Collegarsi al VPS

```bash
ssh root@IP_DEL_VPS
```

Se si usa un utente amministratore diverso da `root`, anteporre `sudo` ai comandi di sistema.

## 5. Aggiornare il server e installare Docker

```bash
apt update
apt upgrade -y
apt install -y ca-certificates curl unzip
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
```

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
```

Riferimento ufficiale: <https://docs.docker.com/engine/install/ubuntu/>.

## 6. Aprire solo le porte necessarie

```bash
apt install -y ufw
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
ufw status
```

## 7. Caricare ed estrarre il pacchetto

Dal proprio computer caricare `Gestione-Ordini-Aruba.zip` sul server:

```bash
scp Gestione-Ordini-Aruba.zip root@IP_DEL_VPS:/opt/
```

Sul VPS:

```bash
mkdir -p /opt/gestione-ordini
unzip /opt/Gestione-Ordini-Aruba.zip -d /opt/gestione-ordini
cd /opt/gestione-ordini
```

Se lo ZIP crea una cartella esterna, entrare nella cartella che contiene `docker-compose.yml`.

## 8. Impostare il dominio

```bash
cp .env.example .env
nano .env
```

Sostituire il valore di esempio:

```dotenv
DOMAIN=ordini.miodominio.it
```

Salvare con `Ctrl+O`, Invio, poi uscire con `Ctrl+X`.

## 9. Avviare il sito

```bash
docker compose up -d --build
docker compose ps
```

La prima compilazione può richiedere alcuni minuti. Caddy richiede automaticamente il certificato HTTPS per il dominio.

Per controllare i messaggi:

```bash
docker compose logs --tail=100 app
docker compose logs --tail=100 caddy
```

Aprire:

```text
https://ordini.miodominio.it
```

Alla prima partenza il contenuto di `aruba/seed/` viene copiato nella cartella persistente `data/`. I riavvii successivi non sovrascrivono i dati.

## 10. Trasferire Supabase e conservare gli accessi

L'autenticazione rimane nel progetto Supabase esistente:

```text
ulzhaqmklrplooccbxzx
```

Per mantenere le password attuali:

1. Il nuovo proprietario crea il proprio account su <https://supabase.com/dashboard>.
2. L'attuale proprietario apre le impostazioni del team dell'organizzazione Supabase.
3. Invita l'amico come **Owner**; l'invito deve essere accettato.
4. Verificare che il nuovo proprietario apra il progetto e veda la sezione Authentication.
5. Nella configurazione Auth impostare il nuovo `Site URL`, per esempio `https://ordini.miodominio.it`.
6. Aggiungere tra gli URL di redirect `https://ordini.miodominio.it/**`.
7. Solo dopo il collaudo, l'attuale proprietario può lasciare l'organizzazione o trasferire il progetto.

Documentazione ufficiale:

- <https://supabase.com/docs/guides/platform/access-control>
- <https://supabase.com/docs/guides/platform/project-transfer>

Le password non sono recuperabili in chiaro. Se si crea un nuovo progetto Supabase invece di trasferire quello esistente, ogni utente dovrà impostare una nuova password.

## 11. Collaudo obbligatorio

Prima di abbandonare il vecchio sito verificare:

1. accesso con almeno un amministratore e un agente;
2. presenza di 68 clienti e 92 ordini;
3. filtri ordini per territorio, stato e data;
4. creazione, modifica, completamento ed eliminazione di un ordine di prova;
5. quantità richiesta e quantità consegnata;
6. apertura di almeno tre PDF su Android;
7. ricerca, modifica, eliminazione e condivisione di un documento;
8. caricamento di una foto senza descrizione;
9. installazione della PWA Android e condivisione di una foto da WhatsApp;
10. foto profilo;
11. aggiornamento automatico ogni 15 minuti.

La condivisione da WhatsApp richiede che il sito sia aperto in HTTPS e installato sul telefono tramite “Aggiungi a schermata Home/Installa app”. Dopo il cambio dominio, rimuovere l'eventuale vecchia installazione e installare di nuovo l'app.

## 12. Backup automatico sul VPS

Eseguire almeno un backup giornaliero della cartella:

```text
/opt/gestione-ordini/data
```

Questa cartella contiene sia il database sia tutti i file caricati dopo la migrazione. Abilitare inoltre gli snapshot Aruba del VPS, se disponibili.

Esempio di copia manuale:

```bash
cd /opt/gestione-ordini
tar -czf /opt/backup-gestione-ordini-$(date +%F).tar.gz data
```

## 13. Aggiornamenti e riavvio

```bash
cd /opt/gestione-ordini
docker compose up -d --build
```

Per riavviare:

```bash
docker compose restart
```

Per controllare lo stato:

```bash
docker compose ps
```

## 14. Passaggio definitivo

Non eliminare il sito ChatGPT durante il collaudo. Usare Aruba per almeno 7–14 giorni, verificare backup e funzioni, quindi:

1. impedire nuove modifiche sul vecchio sito;
2. eseguire un ultimo backup dei dati eventualmente cambiati;
3. verificare un'ultima volta accessi, ordini e documenti su Aruba;
4. solo allora chiedere esplicitamente l'eliminazione del sito ChatGPT.

L'eliminazione del sito ChatGPT può rendere non recuperabile il vecchio indirizzo pubblico; lo ZIP permette di ricostruire l'applicazione, ma non garantisce di riottenere lo stesso URL.

## Risoluzione rapida dei problemi

### Il certificato HTTPS non viene creato

- verificare che il record DNS punti al VPS;
- verificare che le porte 80 e 443 siano aperte;
- leggere `docker compose logs caddy`.

### L'app mostra un errore database

```bash
ls -lah data
docker compose logs app
```

La cartella deve contenere `gestione_ordini.sqlite` e `r2/`.

### Gli accessi non funzionano

- non eliminare il progetto Supabase;
- verificare Site URL e redirect URL;
- verificare che le email in `backup/supabase/account_metadata.json` corrispondano a quelle in `backup/database/json/users.json`;
- usare “Password dimenticata” se un singolo utente non ricorda la password.

### Ripristino immediato

Arrestare la nuova installazione:

```bash
docker compose down
```

Il sito ChatGPT è stato lasciato attivo alla versione 15 e può continuare a essere usato finché non viene richiesta separatamente la sua eliminazione.
