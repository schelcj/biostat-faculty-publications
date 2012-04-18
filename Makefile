all: clean collect parse

collect:
	bin/collect.pl

parse:
	bin/parse.pl

clean:
	rm -f data/*.bib public/json/*.json
