#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use JSON;
use Biostat::Publications::DB::Schema;
use File::Slurp qw(write_file);

my $json    = q{public/js/faculty.json};
my $faculty = [];
my $schema  = Biostat::Publications::DB::Schema->connect('dbi:SQLite:db/publications.db');

for my $member ($schema->resultset('Faculty')->all()) {
  my $publications = [];

  for my $pub ($member->publications) {
    push @{$publications}, [map {$pub->$_} $pub->columns];
  }

  push @{$faculty}, {
    name         => $member->name,
    publications => $publications,
  };
}

write_file($json, to_json($faculty, {utf8 => 1}));
