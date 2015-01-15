drop table if exists faculty;
create table faculty (
  id       INTEGER UNIQUE PRIMARY KEY,
  realname TEXT UNIQUE NOT NULL,
  uniqname TEXT UNIQUE NOT NULL,
  gid      TEXT UNIQUE NOT NULL
);

BEGIN TRANSACTION;
INSERT INTO "faculty" VALUES(1,'Abecasis, Goncalo','goncalo','t53jWtYAAAAJ');
INSERT INTO "faculty" VALUES(2,'Raghunathan, Trivellore','teraghu','zuw_C0cAAAAJ');
INSERT INTO "faculty" VALUES(3,'Little, Roderick','rlittle','gj7OdjcAAAAJ');
INSERT INTO "faculty" VALUES(4,'Braun, Thomas M.','tombraun','Sg9SqwkAAAAJ');
INSERT INTO "faculty" VALUES(5,'Jiang, Hui','jianghui','LszKw2cAAAAJ');
INSERT INTO "faculty" VALUES(6,'Boehnke, Michael Lee','boehnke','nGgivIAAAAAJ');
INSERT INTO "faculty" VALUES(7,'Lepkowski, Jim','jimlep','L42PDQ8AAAAJ');
INSERT INTO "faculty" VALUES(8,'Zoellner, Sebastian','szoellne','b4SbbzYAAAAJ');
INSERT INTO "faculty" VALUES(9,'Sanchez, Brisa N.','brisa','o-onTfUAAAAJ');
INSERT INTO "faculty" VALUES(10,'Li, Yi','lliyi','-3V3mFkAAAAJ');
INSERT INTO "faculty" VALUES(11,'Scott, Laura J.','ljst','0GvpFGgAAAAJ');
INSERT INTO "faculty" VALUES(12,'Elliott, Michael','mrelliot','6T-J2gsAAAAJ');
INSERT INTO "faculty" VALUES(13,'Tsodikov, Alexander','tsodikov','SCZh9zMAAAAJ');
INSERT INTO "faculty" VALUES(14,'Wen, Xiaoquan','xwen','kaO2JQwAAAAJ');
INSERT INTO "faculty" VALUES(15,'Murray, Susan','msusan','tIJD49EAAAAJ');
INSERT INTO "faculty" VALUES(16,'Kang, Hyun','hmkang','8e0jy0IAAAAJ');
INSERT INTO "faculty" VALUES(17,'Johnson, Timothy D.','tdjtdj','YYJXugMAAAAJ');
INSERT INTO "faculty" VALUES(18,'Song, Peter Xuekun','pxsong','bR8pPwsAAAAJ');
INSERT INTO "faculty" VALUES(19,'Kidwell, Kelley','kidwell','h25AXWwAAAAJ');
INSERT INTO "faculty" VALUES(20,'Zhang, Min','minz','9TKFKYcAAAAJ');
INSERT INTO "faculty" VALUES(21,'Spino, Cathie','spino','sGT9GsQAAAAJ');
INSERT INTO "faculty" VALUES(22,'Zhao, Lili','lilizhao','72kNFngAAAAJ');
INSERT INTO "faculty" VALUES(23,'Kim, Se Hee','seheekim','osbjOoQAAAAJ');
INSERT INTO "faculty" VALUES(24,'Taylor, Jeremy','jgtaylor','8uZodNYAAAAJ');
INSERT INTO "faculty" VALUES(25,'Kalbfleisch, John D.','jdkalbfl','unwawwoAAAAJ');
INSERT INTO "faculty" VALUES(26,'Boonstra, Philip Simon','philb','GiaDuZwAAAAj');
INSERT INTO "faculty" VALUES(27,'Wang, Lu','luwang','l-AUTtcAAAAJ');
INSERT INTO "faculty" VALUES(28,'Li, Yun','yunlisph','214Tc68AAAAJ');
INSERT INTO "faculty" VALUES(29,'Mukherjee, Bhramar','bhramar','-zwWIG4AAAAJ');
COMMIT;
