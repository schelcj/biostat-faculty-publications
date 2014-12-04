#!/usr/bin/env perl

# Guidelines for pubmed API:
#
# In order not to overload the E-utility servers, NCBI recommends that
# users post no more than three URL requests per second and limit large jobs
# to either weekends or between 9:00 PM and 5:00 AM Eastern time during
# weekdays.

use FindBin qw($Bin);
use Modern::Perl;
use File::Slurp qw(read_file write_file);
use JSON;
use Mojo::UserAgent;
use HTML::Entities;
use XML::XPath;
use File::Temp;

my $EMPTY      = q{};
my $alias      = q{Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36};
my $pubmed_url = q{http://www.ncbi.nlm.nih.gov/pubmed/%d?report=xml&format=text};
my $xpath      = q{//PubmedArticle/MedlineCitation/Article/Abstract/AbstractText};
my $json_dir   = qq{$Bin/../public/json};
my $agent      = Mojo::UserAgent->new();
my $faculty    = from_json(read_file(qq{$json_dir/faculty.json}), {utf8 => 1});

$agent->transactor->name($alias);

for my $member (@{$faculty}) {
  say qq(Retrieving abstracts for $member->{uniqname});

  my $pubs = from_json(read_file(qq($json_dir/faculty/$member->{uniqname}.json)), {utf8 => 1});

  for my $article (@{$pubs->{publications}->{article}}) {
    if ($article->{pmid}) {
      my $abstract_json = qq($json_dir/abstracts/$article->{pmid}.json);

      next if -e $abstract_json;

      my $url     = sprintf $pubmed_url, $article->{pmid};
      my $content = decode_entities($agent->get($url)->res->body);
      my $temp    = File::Temp->new();

      write_file($temp->filename, $content);

      my $parser   = XML::XPath->new(filename => $temp->filename);
      my $nodes    = $parser->find($xpath);
      my $abstract = join($EMPTY, map {$_->string_value} $nodes->get_nodelist);

      say qq(\tFound abstract for $article->{pmid});

      write_file($abstract_json, to_json({abstract => $abstract}, {utf8 => 1, pretty => 1}));
    }
  }
}
