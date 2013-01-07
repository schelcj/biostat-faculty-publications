all: clean collect parse install

collect:
	bin/collect.pl

parse:
	bin/parse.pl

clean:
	rm -f data/*.bib public/json/*.json

install:
	cp -r public/* /afs/umich.edu/group/s/sph/web/htdocs/biostat/publications
	chmod 755 /afs/umich.edu/group/s/sph/web/htdocs/biostat/publications/*.html
