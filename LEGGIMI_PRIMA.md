# Gestione Ordini Agenti — pacchetto Aruba

Questo pacchetto contiene il sito, il database alla data del backup, tutti gli allegati e una versione adattata per essere eseguita su un **Aruba Cloud VPS/Cloud Server** tramite Docker.

## Requisito importante

Il normale “Hosting Linux”, “Hosting WordPress” o “Hosting Windows” condiviso di Aruba non è sufficiente: l'applicazione usa un server Node.js, un database SQLite e uno spazio file persistente. Serve un VPS/Cloud Server sul quale sia possibile installare Docker e aprire le porte 80 e 443.

Configurazione consigliata:

- Ubuntu 24.04 LTS;
- almeno 2 GB di RAM, 2 vCPU e 25 GB di disco;
- indirizzo IPv4 pubblico;
- dominio o sottodominio con record DNS A verso il VPS;
- backup automatico del VPS o snapshot periodici.

Aprire prima [GUIDA_ARUBA_PASSO_PASSO.md](GUIDA_ARUBA_PASSO_PASSO.md).

## Contenuto

- sorgente completo adattato per Aruba;
- immagine Docker costruibile con Node.js 24;
- database già popolato in `aruba/seed/gestione_ordini.sqlite`;
- tutti gli allegati e gli avatar in `aruba/seed/r2/`;
- copie tecniche del database in `backup/database/`;
- metadati leggibili degli account in `backup/supabase/account_metadata.json`;
- esportazione logica Supabase Auth e script di ripristino in `backup/supabase/`;
- inventario e hash dei file in `backup/r2-manifest.json`.

## Account e password

Le password non sono contenute in chiaro. Il pacchetto include gli hash necessari a ripristinare i 5 account in un nuovo progetto Supabase, ma non include sessioni, token attivi o segreti del progetto. La soluzione preferibile resta trasferire l'attuale progetto Supabase `ulzhaqmklrplooccbxzx`, così configurazione e account rimangono invariati.

Il contenuto di `backup/supabase/` è sensibile: consegnarlo solo alla persona autorizzata e non pubblicarlo in repository o cartelle condivise pubblicamente.

Non eliminare il sito ChatGPT né il progetto Supabase finché il collaudo Aruba non è terminato.
