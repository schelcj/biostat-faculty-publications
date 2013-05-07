PWD := $(shell pwd)
DB_FILE=$(PWD)/publications.db
DB_SCHEMA_DIR=$(PWD)/lib/perl5

all: collect parse install

collect:
	bin/collect.pl

parse:
	bin/parse.pl

install:
	cp -r public/* /afs/umich.edu/group/s/sph/web/htdocs/biostat/publications

build_db:
	@rm -f $(DB_FILE)
	@sqlite3 $(DB_FILE) < $(PWD)/sql/faculty.sql
	@sqlite3 $(DB_FILE) < $(PWD)/sql/urls.sql
	@sqlite3 $(DB_FILE) < $(PWD)/sql/publications.sql

rebuild_schema:
	@perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$(DB_SCHEMA_DIR) -e 'make_schema_at("Biostat::Publications::DB::Schema", {debug => 1}, [ "dbi:SQLite:$(DB_FILE)" ])'
