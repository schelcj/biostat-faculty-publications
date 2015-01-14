drop table if exists publications;
create table publications (
  id          INTEGER UNIQUE PRIMARY KEY,
  faculty_id  INTEGER NOT NULL,
  src_url     TEXT NOT NULL,
  pubmed_url  TEXT NULL,
  scival_url  TEXT NULL,
  title       TEXT NULL,
  abstract    TEXT NULL,
  date        TEXT NULL,
  journal     TEXT NULL,
  volume      TEXT NULL,
  issue       TEXT NULL,
  pages       TEXT NULL,
  authors     TEXT NULL,
  year        INTEGER NULL,
  timescited  INTEGER NULL,
  pmid        INTEGER NULL,
  scopuseid   INTEGER NULL,

  foreign key(faculty_id) references faculty(id)
);

create index publications_faculty_id_idx on urls (faculty_id);
