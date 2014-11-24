#!/usr/bin/env perl

use lib qq($ENV{HOME}/src/biostat/lib/perl5);
use FindBin qw($Bin);
use Modern::Perl;
use Mojo::UserAgent;
use URI;
use URI::QueryParam;
use JSON::Any;
use File::Slurp qw(write_file);
use Biostat::LDAP qw(get_umod_realname);
use Data::Dumper;

my $FACULTY_URL = q{http://www.sph.umich.edu/iscr/faculty/dept.cfm?deptID=1};
my $PUB_URL     = q{https://www.umms.med.umich.edu/profile/publications};
my $CSS         = q{#main-content > h2:nth-child(9) ~ p > a:nth-child(1)};
my @uniqnames   = get_faculty_uniqnames($FACULTY_URL, $CSS);

say 'Saving uniqnames';
write_file(qq{$Bin/../public/json/faculty.json}, JSON::Any->to_json(\@uniqnames));

for my $name (@uniqnames) {
  say "Fetching publications for $name->{uniqname}";
  get_faculty_publications($name->{uniqname});
}

sub get_faculty_uniqnames {
  my ($url, $css) = @_;

  my @names = ();
  my $agent = Mojo::UserAgent->new();

  $agent->get($url)->res->dom($css)->each(
    sub {
      my $uri      = URI->new(shift->attr('href'));
      my $uniqname = $uri->query_param('uniqname');
      my $realname = get_umod_realname($uniqname);

      push @names, {uniqname => $uniqname, realname => $realname};
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

  $page->res->content->asset->move_to(qq{$Bin/../public/json/faculty/$uniqname.json});
}
