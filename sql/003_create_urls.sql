drop table if exists urls;
create table urls (
  id         INTEGER UNIQUE PRIMARY KEY,
  faculty_id INTEGER NOT NULL,
  url        TEXT NOT NULL,

  foreign key(faculty_id) references faculty(id)
);

create index urls_faculty_id_idx on urls (faculty_id);
