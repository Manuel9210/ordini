-- Backup logico Supabase Auth - Gestione Ordini Agenti
-- Esportato: 2026-09-17T18:04:38.499115+00:00
-- Origine: ulzhaqmklrplooccbxzx
-- Eseguire SOLO su un progetto Supabase nuovo/vuoto.
-- Le sessioni e i token attivi non sono inclusi: gli utenti dovranno accedere di nuovo.

begin;

with src as (
  select *
  from jsonb_to_recordset($supabase_backup_v1$[{"id":"629334fc-2f8f-4664-a920-d64900484267","aud":"authenticated","role":"authenticated","email":"pocholavezzi1926@yahoo.it","phone":null,"created_at":"2026-08-31T14:54:19.489608+00:00","deleted_at":null,"updated_at":"2026-08-31T19:23:10.389067+00:00","instance_id":"00000000-0000-0000-0000-000000000000","is_sso_user":false,"banned_until":null,"is_anonymous":false,"last_sign_in_at":"2026-08-31T14:57:48.688527+00:00","raw_app_meta_data":{"provider":"email","providers":["email"]},"email_confirmed_at":"2026-08-31T14:54:46.726176+00:00","encrypted_password":"$2a$10$s/HvWDdSSbiaw/Ew0YeJTOhengKpOPkvM70Vi6/v6KlzsBu3TWafO","phone_confirmed_at":null,"raw_user_meta_data":{"sub":"629334fc-2f8f-4664-a920-d64900484267","email":"pocholavezzi1926@yahoo.it","full_name":"Emanuele Di Maio","email_verified":true,"phone_verified":false}},{"id":"84a69f52-effb-4953-9e87-93dc112d584a","aud":"authenticated","role":"authenticated","email":"f.costa292@gmail.com","phone":null,"created_at":"2026-08-31T16:37:14.145884+00:00","deleted_at":null,"updated_at":"2026-09-16T20:10:31.438874+00:00","instance_id":"00000000-0000-0000-0000-000000000000","is_sso_user":false,"banned_until":null,"is_anonymous":false,"last_sign_in_at":"2026-09-01T19:03:20.928759+00:00","raw_app_meta_data":{"provider":"email","providers":["email"]},"email_confirmed_at":"2026-08-31T16:37:23.526108+00:00","encrypted_password":"$2a$10$WStzHSCiOJQMvWTgEaukGu87NPNBVfQnMpFPMPzxxAZJRTgCwVC9e","phone_confirmed_at":null,"raw_user_meta_data":{"sub":"84a69f52-effb-4953-9e87-93dc112d584a","email":"f.costa292@gmail.com","full_name":"Francesco Costa","email_verified":true,"phone_verified":false}},{"id":"7f6ef64b-fd21-4b90-a03b-02c4bde1f837","aud":"authenticated","role":"authenticated","email":"fornitureprestige@gmail.com","phone":null,"created_at":"2026-08-31T17:12:58.692941+00:00","deleted_at":null,"updated_at":"2026-09-17T15:01:31.601191+00:00","instance_id":"00000000-0000-0000-0000-000000000000","is_sso_user":false,"banned_until":null,"is_anonymous":false,"last_sign_in_at":"2026-09-04T08:08:20.32908+00:00","raw_app_meta_data":{"provider":"email","providers":["email"]},"email_confirmed_at":"2026-08-31T17:13:26.206829+00:00","encrypted_password":"$2a$10$3lRhEkBcKTNXEILJIabQCOfXlz15qqnepeY57R1BOqj01EJ1F9dtm","phone_confirmed_at":null,"raw_user_meta_data":{"sub":"7f6ef64b-fd21-4b90-a03b-02c4bde1f837","email":"fornitureprestige@gmail.com","full_name":"Emanuele","email_verified":true,"phone_verified":false}},{"id":"b07a7498-6aba-495a-b8a7-878cb56e030e","aud":"authenticated","role":"authenticated","email":"salpell84@gmail.com","phone":null,"created_at":"2026-09-02T07:53:42.401681+00:00","deleted_at":null,"updated_at":"2026-09-17T14:00:37.815465+00:00","instance_id":"00000000-0000-0000-0000-000000000000","is_sso_user":false,"banned_until":null,"is_anonymous":false,"last_sign_in_at":"2026-09-02T07:53:54.83629+00:00","raw_app_meta_data":{"provider":"email","providers":["email"]},"email_confirmed_at":"2026-09-02T07:53:54.813249+00:00","encrypted_password":"$2a$10$Ol0T/s.QVpKgxEsPoTaVm.4RV0oloElInXgV28SX7r5jhCC8w5Gke","phone_confirmed_at":null,"raw_user_meta_data":{"sub":"b07a7498-6aba-495a-b8a7-878cb56e030e","email":"salpell84@gmail.com","full_name":"Salvatore Pellino","email_verified":true,"phone_verified":false}},{"id":"44d9b31e-fbd2-4d2d-aca2-734823816cac","aud":"authenticated","role":"authenticated","email":"emanuele.dimaio92@gmail.com","phone":null,"created_at":"2026-09-04T08:17:05.586516+00:00","deleted_at":null,"updated_at":"2026-09-17T07:33:54.325234+00:00","instance_id":"00000000-0000-0000-0000-000000000000","is_sso_user":false,"banned_until":null,"is_anonymous":false,"last_sign_in_at":"2026-09-04T08:17:17.517138+00:00","raw_app_meta_data":{"provider":"email","providers":["email"]},"email_confirmed_at":"2026-09-04T08:17:17.511349+00:00","encrypted_password":"$2a$10$tL17DicvHWt14nbNcSQC8eAiodOqEh4oVcbWy2Zcr89oIanuJFNfG","phone_confirmed_at":null,"raw_user_meta_data":{"sub":"44d9b31e-fbd2-4d2d-aca2-734823816cac","email":"emanuele.dimaio92@gmail.com","full_name":"Emanuele Di Maio","email_verified":true,"phone_verified":false}}]$supabase_backup_v1$::jsonb) as x(
    instance_id uuid,
    id uuid,
    aud varchar,
    role varchar,
    email varchar,
    encrypted_password varchar,
    email_confirmed_at timestamptz,
    last_sign_in_at timestamptz,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    created_at timestamptz,
    updated_at timestamptz,
    phone text,
    phone_confirmed_at timestamptz,
    banned_until timestamptz,
    is_sso_user boolean,
    deleted_at timestamptz,
    is_anonymous boolean
  )
)
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, last_sign_in_at, raw_app_meta_data,
  raw_user_meta_data, created_at, updated_at, phone,
  phone_confirmed_at, banned_until, is_sso_user, deleted_at,
  is_anonymous
)
select
  instance_id, id, aud, role, email, encrypted_password,
  email_confirmed_at, last_sign_in_at, raw_app_meta_data,
  raw_user_meta_data, created_at, updated_at, phone,
  phone_confirmed_at, banned_until, coalesce(is_sso_user, false),
  deleted_at, coalesce(is_anonymous, false)
from src;

with src as (
  select *
  from jsonb_to_recordset($supabase_backup_v1$[{"id":"3039aed7-093d-4893-9118-9bcdf44cff36","user_id":"629334fc-2f8f-4664-a920-d64900484267","provider":"email","created_at":"2026-08-31T14:54:19.521041+00:00","updated_at":"2026-08-31T14:54:19.521041+00:00","provider_id":"629334fc-2f8f-4664-a920-d64900484267","identity_data":{"sub":"629334fc-2f8f-4664-a920-d64900484267","email":"pocholavezzi1926@yahoo.it","full_name":"Emanuele Di Maio","email_verified":true,"phone_verified":false},"last_sign_in_at":"2026-08-31T14:54:19.520924+00:00"},{"id":"d7e7a82e-4f12-4834-a499-05ee40d639ff","user_id":"84a69f52-effb-4953-9e87-93dc112d584a","provider":"email","created_at":"2026-08-31T16:37:14.179367+00:00","updated_at":"2026-08-31T16:37:14.179367+00:00","provider_id":"84a69f52-effb-4953-9e87-93dc112d584a","identity_data":{"sub":"84a69f52-effb-4953-9e87-93dc112d584a","email":"f.costa292@gmail.com","full_name":"Francesco Costa","email_verified":true,"phone_verified":false},"last_sign_in_at":"2026-08-31T16:37:14.179303+00:00"},{"id":"9cc8cda3-b4f8-49aa-bd7b-337ad521346c","user_id":"7f6ef64b-fd21-4b90-a03b-02c4bde1f837","provider":"email","created_at":"2026-08-31T17:12:58.714796+00:00","updated_at":"2026-08-31T17:12:58.714796+00:00","provider_id":"7f6ef64b-fd21-4b90-a03b-02c4bde1f837","identity_data":{"sub":"7f6ef64b-fd21-4b90-a03b-02c4bde1f837","email":"fornitureprestige@gmail.com","full_name":"Emanuele","email_verified":true,"phone_verified":false},"last_sign_in_at":"2026-08-31T17:12:58.714732+00:00"},{"id":"b38d4f8a-91f6-4b6c-9981-e5fef5a494ff","user_id":"b07a7498-6aba-495a-b8a7-878cb56e030e","provider":"email","created_at":"2026-09-02T07:53:42.450949+00:00","updated_at":"2026-09-02T07:53:42.450949+00:00","provider_id":"b07a7498-6aba-495a-b8a7-878cb56e030e","identity_data":{"sub":"b07a7498-6aba-495a-b8a7-878cb56e030e","email":"salpell84@gmail.com","full_name":"Salvatore Pellino","email_verified":true,"phone_verified":false},"last_sign_in_at":"2026-09-02T07:53:42.45083+00:00"},{"id":"7bf140b5-5602-4fd8-8ddb-5ace5a70de3e","user_id":"44d9b31e-fbd2-4d2d-aca2-734823816cac","provider":"email","created_at":"2026-09-04T08:17:05.616113+00:00","updated_at":"2026-09-04T08:17:05.616113+00:00","provider_id":"44d9b31e-fbd2-4d2d-aca2-734823816cac","identity_data":{"sub":"44d9b31e-fbd2-4d2d-aca2-734823816cac","email":"emanuele.dimaio92@gmail.com","full_name":"Emanuele Di Maio","email_verified":true,"phone_verified":false},"last_sign_in_at":"2026-09-04T08:17:05.61606+00:00"}]$supabase_backup_v1$::jsonb) as x(
    id uuid,
    provider_id text,
    user_id uuid,
    identity_data jsonb,
    provider text,
    last_sign_in_at timestamptz,
    created_at timestamptz,
    updated_at timestamptz
  )
)
insert into auth.identities (
  id, provider_id, user_id, identity_data, provider,
  last_sign_in_at, created_at, updated_at
)
select
  id, provider_id, user_id, identity_data, provider,
  last_sign_in_at, created_at, updated_at
from src;

commit;

-- Verifica attesa: 5 utenti e 5 identità.
select
  (select count(*) from auth.users) as utenti,
  (select count(*) from auth.identities) as identita;

