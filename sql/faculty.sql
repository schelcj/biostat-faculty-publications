create table faculty (
  id         INTEGER UNIQUE PRIMARY KEY,
  name       TEXT UNIQUE NOT NULL,
  gid        TEXT UNIQUE NOT NULL,
  created_at DATE NOT NULL
);
