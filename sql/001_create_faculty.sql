set foreign_key_checks=0;
drop table if exists faculty;
create table faculty (
  id       int unsigned not null auto_increment,
  realname varchar(255),
  uniqname varchar(255),
  gid      varchar(20),
  dept_id  int unsigned not null,

  primary key (id),
  unique key (realname),
  unique key (uniqname),
  unique key (gid),
  key (dept_id),
  foreign key fk_dept(dept_id) references departments(id) on delete cascade on update cascade
);
