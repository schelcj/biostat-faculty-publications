all: collect parse install

collect:
	bin/collect.pl

parse:
	bin/parse.pl

install:
	cp -r public/* /afs/umich.edu/group/s/sph/web/htdocs/biostat/publications
