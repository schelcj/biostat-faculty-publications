DOC_ROOT=/afs/umich.edu/group/s/sph/web/htdocs/biostat
SITE_DIR=$(DOC_ROOT)/publications
DEV_SITE_DIR=$(DOC_ROOT)/dev/publications

all: setup get-faculty get-publications clean-author-names get-abstracts

setup:
	mkdir -p public/json/abstracts public/json/faculty

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
