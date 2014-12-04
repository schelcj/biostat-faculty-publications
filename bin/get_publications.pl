#!/usr/bin/env perl

use lib qq($ENV{HOME}/src/biostat/lib/perl5);
use FindBin qw($Bin);
use Modern::Perl;
use Mojo::UserAgent;
use URI;
use URI::QueryParam;
use JSON;
use File::Slurp qw(write_file read_file);
use Biostat::LDAP qw(get_umod_realname);
use Text::Names qw(cleanName samePerson reverseName);

my $FACULTY_URL = q{http://www.sph.umich.edu/iscr/faculty/dept.cfm?deptID=1};
my $PUB_URL     = q{https://www.umms.med.umich.edu/profile/publications};
my $CSS         = q{#main-content > h2:nth-child(9) ~ p > a:nth-child(1)};
my @uniqnames   = get_faculty_uniqnames($FACULTY_URL, $CSS);

say 'Saving uniqnames';
write_file(qq{$Bin/../public/json/faculty.json}, to_json(\@uniqnames, {pretty => 1, utf8 => 1}));

for my $name (@uniqnames) {
  say "Fetching publications for $name->{uniqname}";
  get_faculty_publications($name->{uniqname});

  my $pubs = clean_author_names($name);
  my $file = get_faculty_json($name->{uniqname});
  my $json = to_json($pubs, {pretty => 1, utf8 => 1});
  write_file($file, $json);
}

sub get_faculty_json {
  my ($uniqname) = @_;
  return qq{$Bin/../public/json/faculty/$uniqname.json};
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

sub get_faculty_publications {
  my ($uniqname) = @_;

  my $url   = qq{$PUB_URL/$uniqname.json};
  my $agent = Mojo::UserAgent->new();
  my $page  = $agent->get($url);
  my $json  = get_faculty_json($uniqname);

  $page->res->content->asset->move_to($json);
}

sub clean_author_names {
  my ($name) = @_;

  my $fac_json     = get_faculty_json($name->{uniqname});
  my $publications = from_json(read_file($fac_json), {utf8 => 1});
  my $realname     = reverseName(cleanName($name->{realname}));
  my @articles     = @{$publications->{publications}->{article}};
  my $count        = ($publications->{publications}->{count} - 1);

  for my $i (0 .. $count) {
    my @authors = split(/; /, $articles[$i]->{author});
    my @cleaned_authors = map {(samePerson($realname, $_)) ? $realname : $_} map {reverseName(cleanName($_))} @authors;

    $publications->{publications}->{article}->[$i]->{clean_author} = join('; ', @cleaned_authors);
    $publications->{umod_realname} = $realname;
  }

  return $publications;
}
