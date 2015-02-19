set foreign_key_checks=0;
drop table if exists faculty;
create table faculty (
  id       int unsigned not null auto_increment,
  realname varchar(255),
  uniqname varchar(255),
  gid      varchar(20),

  primary key (id),
  unique key (realname),
  unique key (uniqname),
  unique key (gid)
);
