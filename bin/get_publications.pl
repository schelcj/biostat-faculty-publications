#!/usr/bin/env perl

use FindBin qw($Bin);
use Modern::Perl;
use Mojo::UserAgent;
use File::Slurp qw(read_file);
use JSON;

my $names = from_json(read_file(qq{$Bin/../public/json/faculty.json}), {utf8 => 1});

for my $name (@{$names}) {
  say "Fetching publications for $name->{uniqname}";

  my $url   = qq(https://www.umms.med.umich.edu/profile/publications/$name->{uniqname}.json);
  my $agent = Mojo::UserAgent->new();
  my $page  = $agent->get($url);

  $page->res->content->asset->move_to(qq($Bin/../public/json/faculty/$name->{uniqname}.json));
}
