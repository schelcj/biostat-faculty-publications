WWW_HOST=www.sph.umich.edu
DOC_ROOT=/var/www/html/biostat/dev/publications
DB_FILE=$(PWD)/db/publications.db
SQL_FILES=${shell find ${PWD}/sql -name '*.sql'}
DB_SCHEMA_DIR=$(PWD)/lib/perl5
DSN=dbi:mysql:dbname=$(DB);host=$(DB_HOST)

all: setup get-faculty get-publications clean-author-names get-abstracts

.PHONY: $(SQL_FILES)

$(SQL_FILES):
		@mysql -h $(DB_HOST) -u $(DB_USER) -p$(DB_PASS) $(DB) < $@

load_db: $(SQL_FILES)

rebuild_schema:
	perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:$(DB_SCHEMA_DIR) -e 'make_schema_at("Biostat::Publications::DB::Schema", {debug => 1}, [ "$(DSN)", "$(DB_USER)", "$(DB_PASS)" ])'

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
	rsync -v -a --no-owner --no-group --no-times --no-perms --delete public/ $(WWW_HOST):$(DOC_ROOT)/

install-cpan-deps:
	carton install

test:
	prove t/
