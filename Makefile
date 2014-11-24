PWD := $(shell pwd)
DB_FILE=$(PWD)/db/publications.db
DB_SCHEMA_DIR=$(PWD)/lib/perl5
DOC_ROOT=/afs/umich.edu/group/s/sph/web/htdocs/biostat
SITE_DIR=$(DOC_ROOT)/publications
DEV_SITE_DIR=$(DOC_ROOT)/dev/publications

all: collect build install

collect:
	bin/collect.pl -p -v -d > log/$(shell date '+%Y%m%d').log

build:
	bin/build.pl

install:
	rsync -v -a --no-owner --no-group public/ $(SITE_DIR)/
	chmod 755 $(SITE_DIR)/index.html

install-dev:
	rsync -v -a --no-owner --no-group public/ $(DEV_SITE_DIR)/
	chmod 755 $(DEV_SITE_DIR)/index.html

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

setup:
	mkdir db/ log/ public/json public/json/abstracts

install-cpan-deps:
	carton install

get-publications:
	carton exec 'bin/get_publications.pl'

get-abstracts:
	carton exec 'bin/get_abstracts.pl'
