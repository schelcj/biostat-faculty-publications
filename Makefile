PWD := $(shell pwd)
DB_FILE=$(PWD)/db/publications.db
DB_SCHEMA_DIR=$(PWD)/lib/perl5
SITE_DIR=/afs/umich.edu/group/s/sph/web/htdocs/biostat/publications

all: collect build install

collect:
	bin/collect.pl -p -v -d > log/$(shell date '+%Y%m%d').log

build:
	bin/build.pl

install:
	cp -r public/* $(SITE_DIR)
	chmod 755 $(SITE_DIR)/index.html

add:
	@bin/addfac.pl

build_db:
	@rm -f $(DB_FILE)
	@sqlite3 $(DB_FILE) < $(PWD)/sql/faculty.sql
	@sqlite3 $(DB_FILE) < $(PWD)/sql/urls.sql
	@sqlite3 $(DB_FILE) < $(PWD)/sql/publications.sql
	@sqlite3 $(DB_FILE) < $(PWD)/sql/add_authors.sql

rebuild_schema:
	@perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$(DB_SCHEMA_DIR) -e 'make_schema_at("Biostat::Publications::DB::Schema", {debug => 1}, [ "dbi:SQLite:$(DB_FILE)" ])'
