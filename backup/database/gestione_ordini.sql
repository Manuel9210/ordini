-- Gestione Ordini Agenti - backup SQLite/D1
-- Generated from a read-only export of production data.
BEGIN TRANSACTION;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  role TEXT DEFAULT 'agent' NOT NULL,
  active INTEGER DEFAULT 1 NOT NULL,
  avatar_object_key TEXT,
  avatar_content_type TEXT,
  avatar_updated_at TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE territories (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL
);
CREATE TABLE clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL,
  contact TEXT DEFAULT '' NOT NULL,
  phone TEXT DEFAULT '' NOT NULL,
  address TEXT DEFAULT '' NOT NULL,
  territory_id INTEGER NOT NULL REFERENCES territories(id),
  agent_id INTEGER NOT NULL REFERENCES users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  client_id INTEGER NOT NULL REFERENCES clients(id),
  agent_id INTEGER NOT NULL REFERENCES users(id),
  notes TEXT DEFAULT '' NOT NULL,
  completed_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE TABLE order_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  description TEXT NOT NULL,
  quantity INTEGER DEFAULT 1 NOT NULL,
  delivered_quantity INTEGER DEFAULT 0 NOT NULL,
  delivered INTEGER DEFAULT 0 NOT NULL,
  created_at TEXT NOT NULL
);
CREATE TABLE files (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  order_id INTEGER REFERENCES orders(id),
  uploaded_by INTEGER NOT NULL REFERENCES users(id),
  category TEXT NOT NULL,
  document_group TEXT DEFAULT 'Generale' NOT NULL,
  title TEXT NOT NULL,
  filename TEXT NOT NULL,
  content_type TEXT NOT NULL,
  object_key TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL
);

INSERT INTO users ("active","avatar_content_type","avatar_object_key","avatar_updated_at","created_at","email","id","name","role") VALUES (1,NULL,NULL,NULL,'2026-08-30T19:22:00.430Z','f.costa292@gmail.com',1,'Francesco Costa','admin');
INSERT INTO users ("active","avatar_content_type","avatar_object_key","avatar_updated_at","created_at","email","id","name","role") VALUES (1,'image/jpeg','avatars/2/b012bce8-6925-48b9-b2f0-d8df0792136e-103522.jpg','2026-09-04T08:17:40.497Z','2026-08-30T19:26:38.263Z','emanuele.dimaio92@gmail.com',2,'Emanuele Di Maio','admin');
INSERT INTO users ("active","avatar_content_type","avatar_object_key","avatar_updated_at","created_at","email","id","name","role") VALUES (1,'image/jpeg','avatars/3/0e82925a-8082-434c-bc5b-59424ab04083-Logo_Forniture_Prestige.jpg','2026-09-04T08:05:02.719Z','2026-08-31T08:41:55.275Z','fornitureprestige@gmail.com',3,'Forniture Prestige','admin');
INSERT INTO users ("active","avatar_content_type","avatar_object_key","avatar_updated_at","created_at","email","id","name","role") VALUES (1,NULL,NULL,NULL,'2026-08-31T09:28:23.322Z','pocholavezzi1926@yahoo.it',4,'Emanuele','agent');
INSERT INTO users ("active","avatar_content_type","avatar_object_key","avatar_updated_at","created_at","email","id","name","role") VALUES (1,'image/jpeg','avatars/5/14801e7d-11b8-4f14-80d1-86af8a3b69f3-103672.jpg','2026-09-04T08:21:06.675Z','2026-09-01T07:19:21.034Z','salpell84@gmail.com',5,'Salvatore Pellino','agent');
INSERT INTO territories ("created_at","id","name") VALUES ('2026-08-30T19:22:00.430Z',1,'Napoli');
INSERT INTO territories ("created_at","id","name") VALUES ('2026-08-30T19:22:00.430Z',2,'Tari');
INSERT INTO territories ("created_at","id","name") VALUES ('2026-08-30T19:22:00.430Z',3,'Torre del Greco');
INSERT INTO territories ("created_at","id","name") VALUES ('2026-08-30T19:22:00.430Z',4,'Sicilia');
INSERT INTO territories ("created_at","id","name") VALUES ('2026-08-30T19:22:00.430Z',5,'Oromare');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T09:28:53.437Z',1,'francesco','',1,'2026-09-01T07:21:18.296Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T09:28:55.046Z',2,'francesco','',2,'2026-09-01T07:21:23.976Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',4,'','2026-08-31T12:10:52.518Z',4,'Arcangelo','',5,'2026-08-31T12:10:52.518Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T12:47:05.075Z',5,'carmine cao','',1,'2026-09-01T07:20:40.973Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T12:51:59.924Z',6,'fabio puorto','',1,'2026-09-01T07:21:00.987Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T12:52:37.258Z',7,'paola','',1,'2026-09-01T07:21:29.174Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T14:03:10.102Z',9,'DI STEFANO','',4,'2026-09-01T07:20:06.087Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T14:04:51.426Z',10,'INCASSATORE NARDI','',2,'2026-09-01T07:20:22.090Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T14:06:15.551Z',11,'BUCCINO','',2,'2026-09-01T07:20:01.354Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T14:06:49.321Z',12,'ANTONIO','',2,'2026-09-01T07:19:42.821Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-08-31T15:02:47.575Z',13,'Murolo','',2,'2026-09-01T07:20:27.776Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-01T07:18:23.075Z',14,'cooperativa','',3,'2026-09-01T07:20:50.484Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-01T07:26:28.830Z',15,'tessitore','',2,'2026-09-01T07:26:28.830Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-01T07:36:05.569Z',16,'FORMAZIONE TARI','',2,'2026-09-01T07:36:05.569Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-01T09:09:15.222Z',17,'THE CRAFT','',3,'2026-09-01T09:09:15.222Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',4,'','2026-09-01T09:22:20.837Z',18,'TEMPI D''ORO','',5,'2026-09-01T09:22:20.837Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-02T07:56:00.130Z',19,'Nardi','',2,'2026-09-02T07:56:00.130Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Sicilia ',5,'','2026-09-02T08:39:36.755Z',20,'Buonaccorso','',4,'2026-09-02T08:39:36.755Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Napoli ',5,'','2026-09-02T08:55:17.967Z',21,'Renato','',1,'2026-09-02T08:55:17.967Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Tari',5,'','2026-09-02T09:00:21.706Z',22,'Nakaroma','',2,'2026-09-02T09:00:21.706Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Napoli ',5,'','2026-09-02T09:34:36.913Z',23,'White gold','',1,'2026-09-02T09:34:36.913Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Tari',5,'','2026-09-02T10:15:55.740Z',24,'Lello esposito','',2,'2026-09-02T10:15:55.740Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Tari',5,'','2026-09-02T10:25:06.947Z',25,'La Monica','',2,'2026-09-02T10:25:06.947Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Tari',5,'','2026-09-02T10:50:25.806Z',26,'Mar','',2,'2026-09-02T10:50:25.806Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Napoli ',5,'','2026-09-02T11:11:08.721Z',27,'Nicastro','',1,'2026-09-02T11:11:08.721Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Tari',5,'','2026-09-02T11:15:05.898Z',28,'Muzzico','',2,'2026-09-02T11:15:05.898Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Napoli ',5,'','2026-09-02T13:28:03.403Z',29,'Mimmo','',1,'2026-09-02T13:28:03.403Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-02T13:55:14.162Z',30,'Buonocore','',5,'2026-09-02T13:55:14.162Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Torre del ',5,'','2026-09-03T09:14:18.947Z',31,'Anfa','',3,'2026-09-03T09:14:18.947Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Torre del ',5,'','2026-09-03T09:48:33.628Z',32,'Oreste','',3,'2026-09-03T09:48:33.628Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-03T11:57:42.735Z',33,'Mimmo palazzo cervo','',1,'2026-09-03T11:57:42.735Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('Napoli',5,'','2026-09-03T12:54:38.421Z',34,'Vincenzo Ferrara','',1,'2026-09-03T12:54:38.421Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-03T13:13:23.302Z',35,'Cervone','',1,'2026-09-03T13:13:23.302Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-03T13:59:18.467Z',36,'stellato','',3,'2026-09-03T13:59:18.467Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-03T15:19:10.826Z',37,'bottino','',3,'2026-09-03T15:19:10.826Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-04T08:34:08.595Z',38,'Simagy','',2,'2026-09-04T08:34:08.595Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-04T10:17:01.702Z',39,'Sorio','',2,'2026-09-04T10:17:01.702Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-04T13:10:54.906Z',40,'Mira','',2,'2026-09-04T13:10:54.906Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-07T10:30:51.267Z',41,'Biagio','',2,'2026-09-07T10:30:51.267Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-07T10:43:03.071Z',42,'Estro','',2,'2026-09-07T10:43:03.071Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-07T10:49:06.622Z',43,'G. Com','',2,'2026-09-07T10:49:06.622Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-07T14:48:15.354Z',44,'Cuomo','',3,'2026-09-07T14:48:15.354Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-08T07:50:38.409Z',45,'almas','',5,'2026-09-08T07:50:38.409Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-08T07:51:01.335Z',46,'elisabetta','',5,'2026-09-08T07:51:01.335Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-08T07:51:24.439Z',47,'rocco incassatore','',5,'2026-09-08T07:51:24.439Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-08T08:02:30.170Z',48,'lucariello','',5,'2026-09-08T08:02:30.170Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',3,'','2026-09-08T08:03:44.880Z',49,'marzano','',5,'2026-09-08T08:03:44.880Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-08T08:38:02.515Z',50,'Capodimonte','',1,'2026-09-08T08:38:02.515Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-08T11:41:08.313Z',51,'Marco puorto','',1,'2026-09-08T11:41:08.313Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-08T12:08:54.634Z',52,'Francesco paolo tramontano','',1,'2026-09-08T12:08:54.634Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-08T13:44:21.281Z',53,'Alessandro','',2,'2026-09-08T13:44:21.281Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-09T07:06:43.893Z',54,'Gold bijoux','',1,'2026-09-09T07:06:43.893Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-09T09:55:04.219Z',55,'Tene','',2,'2026-09-09T09:55:04.219Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-09T12:45:48.083Z',56,'Palmieri','',1,'2026-09-09T12:45:48.083Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-10T13:16:50.799Z',57,'Guglielmo','',1,'2026-09-10T13:16:50.799Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-11T09:02:40.206Z',58,'Valentino','',2,'2026-09-11T09:02:40.206Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-11T09:18:50.620Z',59,'Cresco','',2,'2026-09-11T09:18:50.620Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-11T10:35:34.328Z',60,'Rudys','',2,'2026-09-11T10:35:34.328Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',2,'','2026-09-11T14:59:28.379Z',61,'Luise','',2,'2026-09-11T14:59:28.379Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',2,'','2026-09-11T14:59:51.576Z',62,'Alfredo orafo pietro','',1,'2026-09-11T14:59:51.576Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-11T18:42:05.067Z',63,'Raffaele','',1,'2026-09-11T18:42:05.067Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-14T08:49:36.593Z',64,'Marco mormile','',2,'2026-09-14T08:49:36.593Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-15T08:33:34.469Z',65,'Alberto','',2,'2026-09-15T08:33:34.469Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-15T10:59:20.212Z',66,'Antonio barile','',1,'2026-09-15T10:59:20.212Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-15T15:41:16.783Z',67,'Cozzolino','',3,'2026-09-15T15:41:16.783Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-16T07:34:05.927Z',68,'Galliano','',3,'2026-09-16T07:34:05.927Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-16T07:42:18.183Z',69,'Bisaccio','',1,'2026-09-16T07:42:18.183Z');
INSERT INTO clients ("address","agent_id","contact","created_at","id","name","phone","territory_id","updated_at") VALUES ('',5,'','2026-09-16T14:17:29.794Z',70,'Onorato','',2,'2026-09-16T14:17:29.794Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,9,'2026-09-04T08:24:41.219Z','2026-08-31T14:03:40.938Z',10,'','2026-09-04T08:24:41.219Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (4,11,'2026-09-09T11:08:21.672Z','2026-08-31T14:06:35.213Z',12,'','2026-09-09T11:08:21.672Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,15,NULL,'2026-09-01T07:27:02.241Z',17,'','2026-09-09T11:01:09.825Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,16,'2026-09-09T11:05:24.732Z','2026-09-01T07:36:09.104Z',18,'','2026-09-09T11:05:24.732Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,17,'2026-09-09T15:13:06.700Z','2026-09-01T09:09:27.131Z',20,'','2026-09-09T15:13:06.700Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,20,'2026-09-08T14:55:47.054Z','2026-09-02T08:40:12.245Z',24,'','2026-09-08T14:55:47.054Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,23,'2026-09-09T14:29:47.228Z','2026-09-02T09:34:48.172Z',27,'','2026-09-09T14:29:47.228Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,15,'2026-09-09T11:00:15.573Z','2026-09-02T09:43:59.666Z',30,'','2026-09-09T11:00:15.573Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,24,'2026-09-14T07:42:58.934Z','2026-09-02T10:23:30.613Z',32,'','2026-09-14T07:42:58.934Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,26,NULL,'2026-09-02T10:51:34.841Z',34,'','2026-09-02T11:53:20.571Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,24,'2026-09-09T11:04:54.417Z','2026-09-02T13:37:06.569Z',38,'','2026-09-09T11:04:54.417Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,30,NULL,'2026-09-02T13:55:27.847Z',39,'','2026-09-02T13:55:27.847Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,31,'2026-09-09T15:26:35.906Z','2026-09-03T09:14:38.271Z',40,'','2026-09-09T15:26:35.906Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,32,'2026-09-09T15:17:12.306Z','2026-09-03T09:48:46.166Z',41,'','2026-09-09T15:17:12.306Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,5,'2026-09-07T14:59:07.414Z','2026-09-03T10:00:12.044Z',42,'','2026-09-07T14:59:07.414Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,27,'2026-09-07T14:57:47.995Z','2026-09-03T10:35:24.916Z',43,'','2026-09-07T14:57:47.995Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,33,'2026-09-07T14:57:36.318Z','2026-09-03T11:57:57.326Z',44,'','2026-09-07T14:57:36.318Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,21,'2026-09-07T14:57:02.245Z','2026-09-03T12:04:30.170Z',45,'','2026-09-07T14:57:02.245Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,15,NULL,'2026-09-03T12:34:47.851Z',46,'','2026-09-03T12:34:47.851Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,34,'2026-09-09T14:29:41.653Z','2026-09-03T12:54:49.476Z',47,'','2026-09-09T14:29:41.653Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,35,'2026-09-07T14:56:05.311Z','2026-09-03T13:16:15.666Z',48,'','2026-09-07T14:56:05.311Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,35,'2026-09-14T14:25:49.597Z','2026-09-03T13:17:45.227Z',49,'','2026-09-14T14:25:49.597Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,36,NULL,'2026-09-03T13:59:24.368Z',50,'','2026-09-09T15:12:25.491Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,37,'2026-09-09T15:12:50.767Z','2026-09-03T15:19:23.995Z',51,'','2026-09-09T15:12:50.767Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,38,'2026-09-04T12:06:33.201Z','2026-09-04T08:34:19.960Z',53,'','2026-09-04T12:06:33.201Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,27,'2026-09-07T14:50:55.764Z','2026-09-04T08:41:17.424Z',54,'','2026-09-07T14:50:55.764Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,13,'2026-09-04T12:06:14.830Z','2026-09-04T09:34:27.350Z',55,'','2026-09-04T12:06:14.830Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,39,'2026-09-09T09:35:00.230Z','2026-09-04T10:17:55.949Z',56,'','2026-09-09T09:35:00.230Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,38,'2026-09-09T11:04:38.012Z','2026-09-04T12:58:43.251Z',57,'','2026-09-09T11:04:38.012Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,40,'2026-09-07T07:44:51.564Z','2026-09-04T13:11:06.606Z',58,'','2026-09-07T07:44:51.564Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,40,'2026-09-07T07:40:06.893Z','2026-09-04T13:26:27.029Z',59,'','2026-09-07T07:40:06.893Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,41,'2026-09-07T15:43:13.134Z','2026-09-07T10:31:17.280Z',60,'','2026-09-07T15:43:13.134Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,42,'2026-09-09T11:02:16.827Z','2026-09-07T10:43:15.886Z',61,'','2026-09-09T11:02:16.827Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,15,'2026-09-07T15:42:28.766Z','2026-09-07T10:45:42.723Z',63,'','2026-09-07T15:42:28.766Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,43,'2026-09-07T15:41:53.075Z','2026-09-07T10:49:10.047Z',64,'','2026-09-07T15:41:53.075Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,44,'2026-09-16T15:07:52.713Z','2026-09-07T14:48:34.858Z',65,'','2026-09-16T15:07:52.713Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,45,'2026-09-08T14:02:28.352Z','2026-09-08T07:50:49.106Z',66,'','2026-09-08T14:02:28.352Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,46,'2026-09-08T14:02:24.868Z','2026-09-08T07:51:10.694Z',67,'','2026-09-08T14:02:24.868Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,47,'2026-09-10T12:24:55.213Z','2026-09-08T07:55:59.993Z',68,'','2026-09-10T12:24:55.213Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,48,'2026-09-09T13:45:58.620Z','2026-09-08T08:02:43.739Z',69,'','2026-09-09T13:45:58.620Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,49,'2026-09-08T14:02:19.507Z','2026-09-08T08:03:58.533Z',70,'','2026-09-08T14:02:19.507Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,50,'2026-09-09T14:27:37.087Z','2026-09-08T08:38:14.629Z',71,'','2026-09-09T14:27:37.087Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,51,'2026-09-09T14:26:56.825Z','2026-09-08T11:41:42.893Z',72,'','2026-09-09T14:26:56.825Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,52,NULL,'2026-09-08T12:20:23.204Z',73,'Partita IVA 
','2026-09-16T14:45:56.859Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,23,'2026-09-15T15:11:19.910Z','2026-09-08T12:24:25.993Z',74,'','2026-09-15T15:11:19.910Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,29,'2026-09-09T13:51:36.979Z','2026-09-08T12:50:18.422Z',76,'','2026-09-09T13:51:36.979Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,53,'2026-09-09T09:35:17.987Z','2026-09-08T13:44:28.720Z',77,'','2026-09-09T09:35:17.987Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,15,'2026-09-09T09:35:11.776Z','2026-09-08T14:16:39.772Z',78,'','2026-09-09T09:35:11.776Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,52,'2026-09-09T13:51:09.498Z','2026-09-08T15:11:46.616Z',79,'','2026-09-09T13:51:09.498Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,54,'2026-09-09T13:50:40.301Z','2026-09-09T07:07:01.213Z',80,'','2026-09-09T13:50:40.301Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,55,'2026-09-09T11:07:51.157Z','2026-09-09T09:55:12.264Z',81,'','2026-09-09T11:07:51.157Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,15,'2026-09-09T10:48:34.984Z','2026-09-09T10:20:08.141Z',82,'','2026-09-09T10:48:34.984Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,5,'2026-09-09T13:49:26.604Z','2026-09-09T10:54:48.767Z',83,'','2026-09-09T13:49:26.604Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,33,NULL,'2026-09-09T11:43:06.084Z',84,'','2026-09-09T11:43:06.084Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,56,'2026-09-09T13:47:53.337Z','2026-09-09T12:46:10.991Z',85,'','2026-09-09T13:47:53.337Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,16,NULL,'2026-09-09T14:20:11.394Z',86,'','2026-09-09T14:20:11.394Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,37,'2026-09-16T15:07:21.591Z','2026-09-10T09:30:37.664Z',87,'','2026-09-16T15:07:21.591Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,52,NULL,'2026-09-10T12:09:43.003Z',88,'','2026-09-14T14:25:02.243Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,52,'2026-09-14T14:24:17.202Z','2026-09-10T12:11:15.916Z',89,'','2026-09-14T14:24:17.202Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,57,'2026-09-14T14:22:33.935Z','2026-09-10T13:16:59.205Z',90,'','2026-09-14T14:22:33.935Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,51,'2026-09-14T14:22:26.800Z','2026-09-10T13:35:19.344Z',91,'','2026-09-14T14:22:26.800Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,58,'2026-09-11T12:21:53.812Z','2026-09-11T09:02:59.011Z',92,'','2026-09-11T12:21:53.812Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,59,'2026-09-11T12:19:00.564Z','2026-09-11T09:20:20.838Z',93,'','2026-09-11T12:19:00.564Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,59,'2026-09-11T12:16:08.440Z','2026-09-11T09:21:31.456Z',94,'','2026-09-11T12:16:08.440Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,59,'2026-09-11T12:12:45.279Z','2026-09-11T09:24:34.284Z',95,'','2026-09-11T12:12:45.279Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,59,NULL,'2026-09-11T09:28:41.412Z',96,'','2026-09-11T12:09:14.956Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,59,'2026-09-11T12:05:57.288Z','2026-09-11T09:31:50.344Z',97,'','2026-09-11T12:05:57.288Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,59,'2026-09-11T12:05:36.738Z','2026-09-11T09:53:48.611Z',98,'','2026-09-11T12:05:36.738Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,60,'2026-09-11T12:05:18.744Z','2026-09-11T10:35:52.830Z',99,'','2026-09-11T12:05:18.744Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (2,61,'2026-09-14T07:40:14.035Z','2026-09-11T14:59:36.518Z',100,'','2026-09-14T07:40:14.035Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (2,62,'2026-09-14T14:21:16.759Z','2026-09-11T15:00:02.688Z',101,'','2026-09-14T14:21:16.759Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,38,'2026-09-14T07:39:28.297Z','2026-09-11T15:23:49.048Z',102,'','2026-09-14T07:39:28.297Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,63,'2026-09-14T14:20:58.713Z','2026-09-11T18:42:13.744Z',103,'','2026-09-14T14:20:58.713Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,63,'2026-09-14T14:20:24.066Z','2026-09-14T07:45:23.491Z',104,'','2026-09-14T14:20:24.066Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,64,NULL,'2026-09-14T08:55:17.077Z',105,'','2026-09-14T12:11:22.675Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,28,'2026-09-14T12:11:29.059Z','2026-09-14T10:09:52.234Z',106,'','2026-09-14T12:11:29.059Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (3,16,'2026-09-16T15:23:59.874Z','2026-09-15T07:36:51.657Z',107,'','2026-09-16T15:23:59.874Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,65,'2026-09-15T13:04:34.064Z','2026-09-15T08:33:50.034Z',108,'','2026-09-15T13:04:34.064Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,57,'2026-09-16T14:45:11.172Z','2026-09-15T09:24:53.527Z',109,'','2026-09-16T14:45:11.172Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,52,'2026-09-16T14:43:01.748Z','2026-09-15T10:52:05.679Z',110,'','2026-09-16T14:43:01.748Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,66,'2026-09-16T14:36:49.776Z','2026-09-15T10:59:34.109Z',111,'','2026-09-16T14:36:49.776Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,67,'2026-09-16T15:07:07.315Z','2026-09-15T15:41:29.745Z',112,'','2026-09-16T15:07:07.315Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,68,'2026-09-16T15:04:45.340Z','2026-09-16T07:34:38.422Z',114,'','2026-09-16T15:04:45.340Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,69,'2026-09-16T14:31:45.114Z','2026-09-16T07:42:26.966Z',115,'','2026-09-16T14:31:45.114Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,28,NULL,'2026-09-16T10:05:10.866Z',116,'','2026-09-16T10:05:10.866Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,33,'2026-09-16T14:31:13.228Z','2026-09-16T12:47:51.789Z',117,'','2026-09-16T14:31:13.228Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,70,'2026-09-17T10:25:07.367Z','2026-09-16T14:17:37.819Z',118,'','2026-09-17T10:25:07.367Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,70,NULL,'2026-09-16T15:57:20.373Z',119,'','2026-09-16T15:57:20.373Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,32,NULL,'2026-09-17T09:44:02.039Z',120,'','2026-09-17T09:44:02.039Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,23,NULL,'2026-09-17T10:40:08.344Z',121,'','2026-09-17T10:40:08.344Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,6,NULL,'2026-09-17T11:43:47.391Z',122,'','2026-09-17T11:43:47.391Z');
INSERT INTO orders ("agent_id","client_id","completed_at","created_at","id","notes","updated_at") VALUES (5,38,NULL,'2026-09-17T14:02:43.528Z',124,'','2026-09-17T14:02:43.528Z');
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-08-31T14:06:35.213Z',1,3,'Copiglie 10 e 11  tre scat per mis',22,12,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-08-31T14:06:35.213Z',1,1,'PECE',23,12,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:27:02.241Z',0,0,'calibro borletti',36,17,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:27:02.241Z',1,10,'dischetti 0.3',37,17,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:27:02.241Z',1,1,'frese a corindone rosa palline e coniche',38,17,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:37:49.766Z',1,1,'BATTITORE FARO',40,10,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:37:49.766Z',1,2,'CARBONICINI FARO VECCHI',41,10,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:37:49.766Z',1,3,'BULINI N1',42,10,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T07:37:49.766Z',1,50,'DISCHETTI 0.2',43,10,50);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-01T09:09:27.131Z',1,1,'TFP60-B',45,20,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T08:40:12.245Z',1,100,'Wd481cw',60,24,100);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T08:40:12.245Z',1,5,'Midori verdi',61,24,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T08:40:12.245Z',1,1,'Aspettare per altre cose',62,24,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T09:34:48.172Z',1,1,'Tele 150',67,27,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T09:43:59.666Z',1,1,'Acido borico',70,30,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,1,'Tela 320 bobina',72,32,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,1,'Fig 1 10',73,32,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,2,'Coniche 07',74,32,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,1,'Cilindriche 07',75,32,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,10,'Gommini grigi',76,32,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,5,'Gommini a taglio grigi',77,32,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:23:30.613Z',1,2,'Spazz bianca dura',78,32,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T10:51:34.841Z',0,0.35,'Tele 120 1kg',83,34,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T13:37:06.569Z',1,3,'Tronchese da 10',89,38,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-02T13:55:27.847Z',0,0,'punte 0.55 senza gambo',90,39,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T08:37:18.130Z',1,20,'LIME AGO TRIANGOLO TG 4',91,18,20);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T08:37:18.130Z',1,20,'tronchesi',92,18,20);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T09:14:38.271Z',1,2,'2 filtri mascherina plastica',93,40,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T09:48:46.166Z',1,1,'Sgrassatura',94,41,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T10:00:12.044Z',1,5,'Spazz metallo',95,42,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T10:00:12.044Z',1,10,'Gommini verdi',96,42,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T10:35:24.916Z',1,1,'Gesso',97,43,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T11:57:57.326Z',1,1,'Sasso marcio',98,44,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T12:04:30.170Z',1,1,'Bulino n6',99,45,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T12:34:47.851Z',0,0,'Fegato di zolfo da 15',100,46,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T12:54:49.476Z',1,2,'Tele 150',101,47,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T13:17:45.227Z',1,15,'Gommini grigi dare 15',105,49,15);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-03T15:19:23.995Z',1,3,'spazzole bloccate nere',111,51,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T08:34:19.960Z',1,1,'Hh 16 17',112,53,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T08:41:17.424Z',1,100,'Lega gialla 18kt',113,54,100);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T09:34:27.350Z',1,500,'Wh80b2',114,55,500);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T10:24:37.226Z',1,20,'gesso',122,50,20);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T10:24:37.226Z',1,1,'lega argento',123,50,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T10:24:37.226Z',1,5,'gomma bianca sottile',124,50,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T10:24:37.226Z',0,0,'gomma bianca doppia',125,50,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T10:24:37.226Z',1,10,'bronzo',126,50,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T10:24:37.226Z',1,1,'pezzi per forno',127,50,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:05:53.974Z',1,1,'Fig 1 6 7 8',128,56,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:05:53.974Z',1,5,'Granell 8',129,56,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:58:43.251Z',1,1,'Cartone acqua diatillata',130,57,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:58:43.251Z',1,20,'Pelo capra',131,57,20);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:58:43.251Z',1,10,'Spazz nucleo rosso',132,57,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:58:43.251Z',1,10,'Pennelli bianchi',133,57,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T12:58:43.251Z',1,10,'Pennelli neri',134,57,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T13:11:06.606Z',1,5,'Fogli 1200',135,58,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-04T13:26:27.029Z',1,1,'Anodo platinare 2 litri',136,59,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:31:17.280Z',1,1,'Coniche 6 10',137,60,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:31:17.280Z',1,1,'Aghi x infilaperla 0,24 0x36',138,60,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:43:15.886Z',1,2,'Mandarini 2,35',139,61,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,1,'Fig 58 05.06',147,63,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,1,'Coniche 06',148,63,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,100,'Dischetti 03',149,63,100);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,1,'Fig 23 7 8',150,63,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,1,'Calibro digitale',151,63,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,1,'Frese corendo',152,63,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:45:42.723Z',1,1,'Fegato zolfo economico',153,63,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T10:49:10.047Z',1,1,'1 agitatore grafite',154,64,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T14:48:34.858Z',1,1,'Cono borace',155,65,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T14:51:20.548Z',1,2,'Colla verde',156,48,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-07T14:51:20.548Z',1,2,'Jobber 09',157,48,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T07:50:49.106Z',1,2,'acqua naturale',158,66,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T07:51:10.694Z',1,4,'acqua naturale',159,67,4);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T07:55:59.993Z',1,1,'frese fig h71 dalla 3 alla 8 tungsteno',160,68,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T07:55:59.993Z',1,1,'frese fig 23 dalla 9 alla 16',161,68,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T08:02:43.739Z',1,3,'gesso',162,69,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T08:03:58.533Z',1,3,'gesso',163,70,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T08:03:58.533Z',1,5,'imbianchimento',164,70,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T08:38:14.629Z',1,100,'Gommini verdi',165,71,100);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T11:41:42.893Z',1,20,'Granell 5 6 7 8 9',166,72,20);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Rotolo 320',167,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',0,0,'Tele 120',168,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,2,'Archetti',169,73,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Cross n2 n1',170,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Inbianchimento rosa',171,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Mezerna bianco grande',172,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Borace gialla',173,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,10,'Fogli 320',174,73,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,10,'Fogli 220',175,73,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Punzone 925 1 2 misura curvo',176,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Punzone 1 2 misura dritto',177,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Spazzola lamellare  220 280',178,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Spazzola lamella 320',179,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,5,'Spazzo metall',180,73,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,5,'Pennelli metall',181,73,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,2,'Spazz acciaio x pukitrice',182,73,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',0,0,'Molle che mantiene trapano',183,73,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Coniche 07 10',184,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,2,'Fig 23 n10',185,73,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:20:23.204Z',1,1,'Spazz bianco da trapano',186,73,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:24:25.993Z',1,1,'Filtro lava mani',187,74,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:24:25.993Z',1,1,'Spugnetta verde sempre lava mani',188,74,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T12:50:18.422Z',1,1,'Jobber 07 09',190,76,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T13:44:28.720Z',1,1,'Bobina dado',191,77,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T14:16:39.772Z',1,1,'HD 2frese x 10 12 13 14',192,78,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T14:16:39.772Z',1,1,'Gran 100x 4 6 10',193,78,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T14:16:39.772Z',1,1,'Bulino n0',194,78,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-08T15:11:46.616Z',1,1,'Schina 00',195,79,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T07:07:01.213Z',1,1,'15g lega saldatura gialla',196,80,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T09:55:12.264Z',1,1,'Tele 150',197,81,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T10:20:08.141Z',1,20,'Spazzolini setola nera',198,82,20);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T10:54:48.767Z',1,1,'Pece gialla',199,83,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T11:43:06.084Z',0,0,'Jobber 1,10',200,84,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T12:46:10.991Z',1,1,'Fig 1 da 10 a 16',201,85,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-09T14:20:11.394Z',0,0,'Righe',202,86,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T09:30:37.664Z',1,2,'Spazz nucleo rosso',203,87,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T12:09:43.003Z',0,0,'Bollo 2 misura curvo 925',204,88,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T12:09:43.003Z',1,1,'Morsetto x tele Ottone',205,88,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T12:09:43.003Z',1,1,'Mezerna piccolo bianco',206,88,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T12:11:15.916Z',1,1,'100g aghetti 04',207,89,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T13:16:59.205Z',1,1,'Plasticast',208,90,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T13:35:19.344Z',1,2,'Alberino gommino',209,91,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-10T13:35:19.344Z',1,1,'Alberino x sopposte',210,91,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:02:59.011Z',1,1,'Scappo la piana n6',211,92,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:02:59.011Z',1,1,'Dischetto Diamantopoulou',212,92,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:20:20.838Z',1,1,'Frusta senza manipolo',213,93,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:20:20.838Z',1,2,'Hh 14 16 18',214,93,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:20:20.838Z',1,10,'Dischetti grana media come dati a Panfilia',215,93,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:21:31.456Z',1,10,'Anche dischetti più sottili',216,94,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:24:34.284Z',1,1,'Fig 23 8 10 11 12 24 28',217,95,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:24:34.284Z',1,1,'Coniche 8 10',218,95,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:31:50.344Z',1,1,'Fig 58 07',220,97,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T09:53:48.611Z',1,1,'Hh 12',221,98,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T10:35:52.830Z',1,1,'250g lega rosa 9ct meccanica',222,99,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T12:09:14.956Z',0,0,'Tela 320',223,96,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T14:59:36.518Z',1,1,'Colla verde',224,100,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T15:00:02.688Z',1,1,'Pedale strong piccolino',225,101,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T15:23:49.048Z',1,2,'Anelliere ferro',226,102,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-11T18:42:13.744Z',1,2,'Gf2n',227,103,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:55:17.077Z',1,100,'Busta gommini grigi',231,105,100);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:55:17.077Z',0,0,'Rotolo 320',232,105,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:55:17.077Z',1,1,'Coniche 06',233,105,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:55:17.077Z',1,1,'Cilindriche 08 12',234,105,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:55:17.077Z',1,1,'Fig 23 n6',235,105,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:55:17.077Z',1,5,'Dischetti 0,3',236,105,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:56:40.297Z',1,2,'2 spazz nucleo blu',237,104,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:56:40.297Z',1,5,'Passa carta 360 1200',238,104,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:56:40.297Z',1,2,'Gf2n sen',239,104,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T08:56:40.297Z',1,2,'Acqua distillata',240,104,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-14T10:09:52.234Z',1,10,'10g lega gialla',241,106,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T07:36:51.657Z',1,1,'acido borico',242,107,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T07:36:51.657Z',1,10,'seghette per cera',243,107,10);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T07:36:51.657Z',1,100,'gommini grigi',244,107,100);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T07:36:51.657Z',1,15,'minipunte marroni',245,107,15);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T08:36:41.849Z',1,1,'2c1 10 12 14',247,108,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T08:36:41.849Z',1,5,'Gommini grigi',248,108,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T09:24:53.527Z',1,4,'Fresil',249,109,4);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T10:52:05.679Z',1,2,'Spazzola da banco',250,110,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T11:00:59.773Z',1,1,'Piattina 4 6 8',252,111,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T11:00:59.773Z',1,3,'Granell da 4 a 12',253,111,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-15T15:41:29.745Z',1,1,'Optima',254,112,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T07:42:26.966Z',1,4,'Bulino n1',259,115,4);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T07:44:01.031Z',1,2,'Gesso optima',260,114,2);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T07:44:01.031Z',1,1,'Sf925ch',261,114,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T10:05:10.866Z',0,0,'Spazz nucleo blu',262,116,3);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T12:47:51.789Z',1,1,'Gf3n senz',263,117,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T14:17:37.819Z',1,1,'Gf1n',264,118,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-16T15:57:20.373Z',0,0,'10 filtri pulite ice',265,119,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T09:44:02.039Z',0,0,'Radial',266,120,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T09:44:02.039Z',0,0,'Tpro',267,120,5);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T10:40:08.344Z',0,0,'Gf2n',268,121,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T11:43:47.391Z',0,0,'Spazzola x satinare larga',269,122,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T14:02:43.528Z',0,0,'HD 9 10',274,124,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T14:02:43.528Z',0,0,'Scappolapiana grs n6',275,124,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T14:02:43.528Z',0,0,'Bulino grs n1',276,124,1);
INSERT INTO order_items ("created_at","delivered","delivered_quantity","description","id","order_id","quantity") VALUES ('2026-09-17T14:02:43.528Z',0,0,'Manico grs',277,124,1);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-01T07:34:37.922Z','Schede Tecniche Leghe','TDS_A183N_750_ITA.pdf.pdf',4,'document/370a986a-1077-4845-95c0-9e3101979280-TDS_A183N_750_ITA.pdf.pdf',NULL,'A183N-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:22:20.592Z','Schede Tecniche Leghe','TDS_AG108M_925_ITA.pdf.pdf',9,'document/a64182f7-dba7-4974-b093-022c56cc11a4-TDS_AG108M_925_ITA.pdf.pdf',NULL,'AG108M',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:22:42.542Z','Schede Tecniche Leghe','TDS_AG109M_925_ITA.pdf',10,'document/39f0f1e5-6bbe-4f62-989a-4ca735757e62-TDS_AG109M_925_ITA.pdf',NULL,'AG109M',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:23:14.347Z','Schede Tecniche Leghe','TDS_B145_375_ITA.pdf.pdf',11,'document/2e348d62-fa7c-47a9-b880-3fb93f6c99f8-TDS_B145_375_ITA.pdf.pdf',NULL,'B145-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:24:34.817Z','Schede Tecniche Leghe','TDS_B182NL_750_ITA.pdf.pdf',12,'document/da87cb79-5888-42a9-9e89-0b6f088b7969-TDS_B182NL_750_ITA.pdf.pdf',NULL,'B182NL-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:24:57.457Z','Schede Tecniche Leghe','TDS_BR3_000_ITA.pdf.pdf',13,'document/aae5793a-21f6-49cf-93e5-06a0d874f107-TDS_BR3_000_ITA.pdf.pdf',NULL,'BR3',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:25:49.374Z','Schede Tecniche Leghe','TDS_BR10_000_ITA.pdf.pdf',15,'document/cfaefc5c-c686-4e67-80d7-0f4ae9d1ed73-TDS_BR10_000_ITA.pdf.pdf',NULL,'BR10',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:26:17.068Z','Schede Tecniche Leghe','TDS_BR10S_000_ITA.pdf.pdf',16,'document/254095d0-f43d-429e-99b3-5ac0b9ae1a50-TDS_BR10S_000_ITA.pdf.pdf',NULL,'BR10S',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:26:35.510Z','Schede Tecniche Leghe','TDS_BR19_000_ITA.pdf.pdf',17,'document/3fd154b5-10d7-4ed0-8d8d-9597f0ecb955-TDS_BR19_000_ITA.pdf.pdf',NULL,'BR19',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:26:59.798Z','Schede Tecniche Leghe','TDS_BRZ-WHT-01_000_ITA.pdf',18,'document/b3b033d0-0dbd-45e9-83d7-f58208841cb5-TDS_BRZ-WHT-01_000_ITA.pdf',NULL,'BRZ-WHT',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:27:32.064Z','Schede Tecniche Leghe','TDS_C183N_750_ITA.pdf.pdf',19,'document/839604e7-39d7-4d73-aeaa-32da356aaad1-TDS_C183N_750_ITA.pdf.pdf',NULL,'C183N-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:28:44.104Z','Schede Tecniche Bagni Galvanici','TDS_GF2N_000_ITA.pdf.pdf',20,'document/4b4d3317-03cf-488c-b212-5fd782d1ae9d-TDS_GF2N_000_ITA.pdf.pdf',NULL,'GF2N',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:29:56.288Z','Schede Tecniche Bagni Galvanici','TDS_GF3N_000_ITA.pdf.pdf',21,'document/d13b197b-8f5f-4ddd-a77b-c86efecc03c7-TDS_GF3N_000_ITA.pdf.pdf',NULL,'GF3N',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:30:12.382Z','Schede Tecniche Bagni Galvanici','TDS_GFPINK_000_ITA.pdf.pdf',22,'document/a3cecf42-e9c1-49c0-a58a-1a5fc8536923-TDS_GFPINK_000_ITA.pdf.pdf',NULL,'GFPINK',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:30:32.275Z','Schede Tecniche Bagni Galvanici','TDS_GFX1_000_ITA.pdf.pdf',23,'document/75ae3610-857b-43cb-9c6b-14cdec17330d-TDS_GFX1_000_ITA.pdf.pdf',NULL,'GFX1',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:30:49.435Z','Schede Tecniche Bagni Galvanici','TDS_GT4A_000_ITA.pdf.pdf',24,'document/1ac35aaa-8224-4cc6-ba8d-d66590ba3ada-TDS_GT4A_000_ITA.pdf.pdf',NULL,'GT4A',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:31:06.585Z','Schede Tecniche Bagni Galvanici','TDS_GT4A2N_000_ITA.pdf.pdf',25,'document/7ca1910b-cd16-4616-9eeb-7f989cb63638-TDS_GT4A2N_000_ITA.pdf.pdf',NULL,'GT4A2N',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:31:28.801Z','Schede Tecniche Bagni Galvanici','TDS_KLIAR-BLU_000_ITA.pdf.pdf',26,'document/f0ccf0c2-77af-4b76-9eff-57c1eddaac8f-TDS_KLIAR-BLU_000_ITA.pdf.pdf',NULL,'KLIAR-BLU',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:31:50.571Z','Schede Tecniche Bagni Galvanici','TDS_KLIAR-CB_000_ITA.pdf',27,'document/e9140f87-7e61-4bd5-a887-831e810926da-TDS_KLIAR-CB_000_ITA.pdf',NULL,'KLIAR-CB',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:32:15.445Z','Schede Tecniche Bagni Galvanici','TDS_NEATECH525FE_000_ITA.pdf.pdf',28,'document/c803bc0c-41dd-4f4c-b8b0-6952202188f1-TDS_NEATECH525FE_000_ITA.pdf.pdf',NULL,'SGRASSATURA GALVANICA POLVERE',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:32:37.967Z','Schede Tecniche Bagni Galvanici','TDS_NEUT-SA_000_ITA.pdf.pdf',29,'document/3235a01e-7d9e-46cd-80aa-9eedf4589629-TDS_NEUT-SA_000_ITA.pdf.pdf',NULL,'NEUTRALIZZAZIONE SALI',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:33:11.258Z','Schede Tecniche Leghe','TDS_NI1811-06_750_ITA.pdf.pdf',30,'document/28a49cae-120b-474f-970f-adf05d66c43d-TDS_NI1811-06_750_ITA.pdf.pdf',NULL,'NI1811-06-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:33:32.295Z','Schede Tecniche Leghe','TDS_NPF301_375_ITA.pdf.pdf',31,'document/89a2433f-7640-4dbc-896b-59c68851690e-TDS_NPF301_375_ITA.pdf.pdf',NULL,'NPF301-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:33:58.706Z','Schede Tecniche Leghe','TDS_OB304R_750_ITA.pdf.pdf',32,'document/b6687e94-74de-475d-b7ae-16ca60d2b1f4-TDS_OB304R_750_ITA.pdf.pdf',NULL,'OB304R-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:34:18.109Z','Schede Tecniche Leghe','TDS_OG130A_375_ITA.pdf.pdf',33,'document/ca0c87c5-e970-4c4f-8ae3-109ceb319073-TDS_OG130A_375_ITA.pdf.pdf',NULL,'OG130A-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:34:38.902Z','Schede Tecniche Leghe','TDS_OG130A_585_ITA.pdf.pdf',34,'document/44676154-d2c2-44bc-919d-40ed375b45a2-TDS_OG130A_585_ITA.pdf.pdf',NULL,'OG130A-585',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:35:00.939Z','Schede Tecniche Leghe','TDS_OR134UL_750_ITA.pdf.pdf',35,'document/916ccec7-c9b0-43fa-88ae-20c9e114d36b-TDS_OR134UL_750_ITA.pdf.pdf',NULL,'OR134UL-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:35:28.195Z','Schede Tecniche Leghe','TDS_OTTGR_000_ITA.pdf.pdf',36,'document/cab18a89-e5fa-4398-a427-c915ac96a958-TDS_OTTGR_000_ITA.pdf.pdf',NULL,'OTTGR',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:35:59.545Z','Schede Tecniche Bagni Galvanici','TDS_PD3-ECO_000_ITA.pdf.pdf',37,'document/086eba36-9fe3-4deb-8fe9-3840942e5b20-TDS_PD3-ECO_000_ITA.pdf.pdf',NULL,'PD3-ECO',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:36:19.175Z','Schede Tecniche Leghe','TDS_PT950CM_950_ITA.pdf.pdf',38,'document/7b59b43e-179a-4591-92da-860d3c2ea8cf-TDS_PT950CM_950_ITA.pdf.pdf',NULL,'PT950CM',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:36:38.724Z','Schede Tecniche Bagni Galvanici','TDS_PTLUX-RTU_000_ITA.pdf',39,'document/1645fd23-4253-4737-bf51-e01db7f02b55-TDS_PTLUX-RTU_000_ITA.pdf',NULL,'PTLUX-RTU',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:36:55.795Z','Schede Tecniche Bagni Galvanici','TDS_PTPURE2_000_ITA.pdf',40,'document/bb68adc1-601f-4f1e-9ddf-0e83849e50be-TDS_PTPURE2_000_ITA.pdf',NULL,'PTPURE2',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:37:23.110Z','Schede Tecniche Bagni Galvanici','TDS_RH1FRT_000_ITA.PDF.pdf',41,'document/81402930-d93e-4ec6-a6b8-76b7c2a055f5-TDS_RH1FRT_000_ITA.PDF.pdf',NULL,'RH1FRT',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:37:50.366Z','Schede Tecniche Bagni Galvanici','TDS_RH2FM_000_ITA.pdf.pdf',42,'document/cd1f3609-1cb0-490a-857e-24b99088af95-TDS_RH2FM_000_ITA.pdf.pdf',NULL,'RH2FM',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:38:23.494Z','Schede Tecniche Bagni Galvanici','TDS_RH2PB_000_ITA.pdf.pdf',43,'document/0ec0bc38-d767-47c4-bed2-71da6f4d7447-TDS_RH2PB_000_ITA.pdf.pdf',NULL,'RH2PB',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:38:53.710Z','Schede Tecniche Bagni Galvanici','TDS_RH2XL_000_ITA.pdf.pdf',44,'document/74cecd7c-fd9d-4121-ab3e-44fa5a33c5e2-TDS_RH2XL_000_ITA.pdf.pdf',NULL,'RH2XL',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:39:10.771Z','Schede Tecniche Leghe','TDS_S925PT_925_ITA.pdf',45,'document/c6261798-9f1f-44f7-a15a-ad4235634485-TDS_S925PT_925_ITA.pdf',NULL,'S925PT',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:39:29.637Z','Schede Tecniche Leghe','TDS_S925WH_925_ITA.pdf',46,'document/a7f20034-b412-4d07-8542-a02b1c80e912-TDS_S925WH_925_ITA.pdf',NULL,'S925WH',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:39:49.201Z','Schede Tecniche Leghe','TDS_SCA1V_375_ITA.pdf.pdf',47,'document/dfa979a1-b067-416c-93dc-3809171df119-TDS_SCA1V_375_ITA.pdf.pdf',NULL,'SCA1V',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:40:11.887Z','Schede Tecniche Leghe','TDS_SF928CH_925_ITA.pdf.pdf',48,'document/bcb9115a-b986-4bfa-b03a-55232027ad7e-TDS_SF928CH_925_ITA.pdf.pdf',NULL,'SF928CH',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:40:34.467Z','Schede Tecniche Leghe','TDS_SILNOVA-01_930_ITA.pdf.pdf',49,'document/aa298b84-4364-44a1-8247-ca84af0f21ae-TDS_SILNOVA-01_930_ITA.pdf.pdf',NULL,'SILNOVA',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:40:54.030Z','Schede Tecniche Bagni Galvanici','TDS_T-PRO_000_ITA.pdf.pdf',50,'document/84847b8e-25ef-4866-b220-d17672bc5eea-TDS_T-PRO_000_ITA.pdf.pdf',NULL,'T-PRO',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:41:19.376Z','Schede Tecniche Leghe','TDS_WB140C_375_ITA.pdf.pdf',51,'document/bf4b4552-8b91-484d-b3d0-45e1723e8e07-TDS_WB140C_375_ITA.pdf.pdf',NULL,'WB140C-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:41:43.247Z','Schede Tecniche Leghe','TDS_WB140C_585_ITA.pdf.pdf',52,'document/f5435ae4-bfa7-4db4-88c2-ed2606044051-TDS_WB140C_585_ITA.pdf.pdf',NULL,'WB140C-585',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:42:11.316Z','Schede Tecniche Leghe','TDS_WD481CW_375_ITA.pdf.pdf',53,'document/d19a4a3b-0426-4bc8-b7d7-31cb37b46c30-TDS_WD481CW_375_ITA.pdf.pdf',NULL,'WB481CW-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:42:31.329Z','Schede Tecniche Leghe','TDS_WD481CW_750_ITA.pdf.pdf',54,'document/9fac4fbf-fdbb-4f7a-b3f7-7e3e159dadb4-TDS_WD481CW_750_ITA.pdf.pdf',NULL,'WD481CW-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:42:52.251Z','Schede Tecniche Leghe','TDS_WH80B2_585_ITA.pdf.pdf',55,'document/79de1e3f-4b1e-48d6-b844-73f7047e3639-TDS_WH80B2_585_ITA.pdf.pdf',NULL,'WH481B2-585',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:43:12.542Z','Schede Tecniche Leghe','TDS_WH80B2_750_ITA.pdf.pdf',56,'document/b7016b63-88bc-4086-b40d-cfc462a9bf8b-TDS_WH80B2_750_ITA.pdf.pdf',NULL,'WH80B2-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:43:31.392Z','Schede Tecniche Leghe','TDS_Y144W_375_ITA.pdf.pdf',57,'document/8c888502-72fa-4000-9d69-83aecac35d12-TDS_Y144W_375_ITA.pdf.pdf',NULL,'Y144W-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:43:50.476Z','Schede Tecniche Leghe','TDS_YD148C_375_ITA.pdf.pdf',58,'document/d2a2271b-bf75-47e5-b98a-b303e3ecb7ef-TDS_YD148C_375_ITA.pdf.pdf',NULL,'YD148C-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:44:08.026Z','Schede Tecniche Leghe','TDS_YD148L_750_ITA.pdf.pdf',59,'document/209fbba1-683d-4f6a-b94b-22fb036675da-TDS_YD148L_750_ITA.pdf.pdf',NULL,'YD148L-750',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T13:44:26.154Z','Schede Tecniche Leghe','TDS_YD148NTE_375_ITA.pdf.pdf',60,'document/6ef58307-dae6-4750-b02c-409f384f2e57-TDS_YD148NTE_375_ITA.pdf.pdf',NULL,'YD148NTE-375',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T14:07:49.418Z','Schede Tecniche Macchinari','Bulinatore Elettrico SmartPro.pdf',61,'document/18ebfba9-6c1d-48ce-8e2c-e1ba7531692e-Bulinatore_Elettrico_SmartPro.pdf',NULL,'BULINATORE SMART PRO',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T14:08:52.663Z','Schede Tecniche Gesso','SCHEDA PRESTIGE OPTIMA_compressed.pdf',62,'document/aed8a657-dc79-4403-933d-d4d2e3e7ea19-SCHEDA_PRESTIGE_OPTIMA_compressed.pdf',NULL,'PRESTIGE OPTIMA',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-02T14:10:34.462Z','Schede Tecniche Gesso','SCHEDA PRESTIGE ORO_compressed.pdf',63,'document/6fce765a-db10-426e-8b24-700e2b6622de-SCHEDA_PRESTIGE_ORO_compressed.pdf',NULL,'PRESTIGE ORO',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-03T08:52:45.004Z','Listini','Atoom Listino.pdf',64,'document/d9601ea4-397f-4fe6-9d9c-ddbd12bd604d-Atoom_Listino.pdf',NULL,'ATOOM LISTINO',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/pdf','2026-09-03T09:01:36.285Z','Listini','Chinetti Listino.pdf',65,'document/bcdee4c0-891b-4dc0-b82a-a29fbcd414c0-Chinetti_Listino.pdf',NULL,'CHINETTI LISTINO',3);
INSERT INTO files ("category","content_type","created_at","document_group","filename","id","object_key","order_id","title","uploaded_by") VALUES ('document','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','2026-09-03T09:02:31.838Z','Listini','Dal Trozzo Listino.xlsx',66,'document/c90cdebd-c038-4dbb-9c69-1a7465d5450a-Dal_Trozzo_Listino.xlsx',NULL,'DAL TROZZO LISTINO',3);
COMMIT;
PRAGMA foreign_keys=ON;
