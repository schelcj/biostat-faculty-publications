drop table if exists faculty;
create table faculty (
  id       INTEGER UNIQUE PRIMARY KEY,
  realname TEXT UNIQUE NOT NULL,
  uniqname TEXT UNIQUE NOT NULL,
  gid      TEXT UNIQUE NOT NULL
);
