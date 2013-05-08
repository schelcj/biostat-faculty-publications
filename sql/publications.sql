create table publications (
  id          INTEGER UNIQUE PRIMARY KEY,
  faculty_id  INTEGER NOT NULL,
  url         TEXT NOT NULL,
  title       TEXT,
  date        TEXT,
  journal     TEXT,
  volume      TEXT,
  issue       TEXT,
  pages       TEXT,

  foreign key(faculty_id) references faculty(id)
);

create index publications_faculty_id_idx on urls (faculty_id);
