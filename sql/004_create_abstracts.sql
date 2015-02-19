set foreign_key_checks=0;
drop table if exists abstracts;
create table abstracts (
  id   int unsigned not null auto_increment,
  pmid int unsigned not null,
  text text,

  primary key (id),
  key (pmid),
  foreign key (pmid) references publications(pmid) on delete cascade on update cascade
);
