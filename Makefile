DOC_ROOT=/afs/umich.edu/group/s/sph/web/htdocs/biostat
SITE_DIR=$(DOC_ROOT)/publications
DEV_SITE_DIR=$(DOC_ROOT)/dev/publications
DB_FILE=$(PWD)/db/publications.db
SQL_FILES=${shell find ${PWD}/sql -name '*.sql'}
DB_SCHEMA_DIR=$(PWD)/lib/perl5

all: setup get-faculty get-publications clean-author-names get-abstracts

.PHONY: $(SQL_FILES)

$(SQL_FILES):
		sqlite3 $(DB_FILE) < $@

load_db: $(SQL_FILES)

rebuild_schema:
	perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$(DB_SCHEMA_DIR) -e 'make_schema_at("Biostat::Publications::DB::Schema", {debug => 1}, [ "dbi:SQLite:$(DB_FILE)" ])'

setup:
	mkdir -p db/ public/json/abstracts public/json/faculty

get-faculty:
	carton exec 'bin/get_faculty.pl'

get-publications:
	carton exec 'bin/get_publications.pl'

get-abstracts:
	carton exec 'bin/get_abstracts.pl'

clean-author-names:
	carton exec 'bin/clean_authors.pl' 2>/dev/null

install:
	rsync -v -a --no-owner --no-group public/ $(SITE_DIR)/
	chmod 755 $(SITE_DIR)/index.html

install-dev:
	rsync -v -a --no-owner --no-group public/ $(DEV_SITE_DIR)/
	chmod 755 $(DEV_SITE_DIR)/index.html

install-cpan-deps:
	carton install
