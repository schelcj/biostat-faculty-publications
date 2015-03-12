set foreign_key_checks=0;
drop table if exists publications;
create table publications (
  id         int unsigned not null auto_increment,
  faculty_id int unsigned not null,
  src_url    text not null,
  pubmed_url text,
  scival_url text,
  title      text,
  date       varchar(255),
  journal    text,
  volume     varchar(255),
  issue      varchar(255),
  pages      varchar(255),
  authors    text,
  year       int unsigned,
  timescited int unsigned,
  pmid       int unsigned,
  scopuseid  varchar(255),
  created_at timestamp,

  primary key (id),
  key (faculty_id),
  key (title(255)),
  key (pmid),
  key (scopuseid),
  foreign key fk_fac(faculty_id) references faculty(id) on delete cascade on update cascade
) collate utf8_general_ci;
