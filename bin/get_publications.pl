#!/usr/bin/env perl

use FindBin qw($Bin);
use Modern::Perl;
use Mojo::UserAgent;
use URI;
use URI::QueryParam;
use JSON::Any;
use File::Slurp qw(write_file);
use Data::Dumper;

my $FACULTY_URL = q{http://www.sph.umich.edu/iscr/faculty/dept.cfm?deptID=1};
my $PUB_URL     = q{https://www.umms.med.umich.edu/profile/publications};
my $CSS         = q{#main-content > h2:nth-child(9) ~ p > a:nth-child(1)};
my @uniqnames   = get_faculty_uniqnames($FACULTY_URL, $CSS);

say 'Saving uniqnames';
write_file(qq{$Bin/../public/json/faculty.json}, JSON::Any->to_json(\@uniqnames));

for my $name (@uniqnames) {
  say "Fetching publications for $name";
  get_faculty_publications($name);
}

sub get_faculty_uniqnames {
  my ($url, $css) = @_;

  my @names = ();
  my $agent = Mojo::UserAgent->new();

  $agent->get($url)->res->dom($css)->each(
    sub {
      my $uri = URI->new(shift->attr('href'));
      push @names, $uri->query_param('uniqname');
    }
  );

  return @names;
}

sub get_publication_url {
  my ($uniqname) = @_;
  return "$PUB_URL/$uniqname.json";
}

sub get_faculty_publications {
  my ($uniqname) = @_;

  my $url   = get_publication_url($uniqname);
  my $agent = Mojo::UserAgent->new();
  my $page  = $agent->get($url);

  $page->res->content->asset->move_to(qq{$Bin/../public/json/$uniqname.json});
}
