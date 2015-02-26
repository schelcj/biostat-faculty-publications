set foreign_key_checks=0;
drop table if exists departments;
create table departments (
  id      int unsigned not null auto_increment,
  name    varchar(255),
  abbr    varchar(10),

  primary key (id),
  unique key (name),
  unique key (abbr)
);
