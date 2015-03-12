set foreign_key_checks=0;
drop table if exists urls;
create table urls (
  id         int unsigned not null auto_increment,
  faculty_id int unsigned not null,
  url        text not null,

  primary key (id),
  foreign key fk_fac(faculty_id) references faculty(id) on delete cascade on update cascade,
  key (faculty_id)
) collate utf8_general_ci;
