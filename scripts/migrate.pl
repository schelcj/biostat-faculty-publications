#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use JSON;
use File::Slurp;
use Data::Dumper;
use Biostat::Publications::DB::Schema;

my $schema = Biostat::Publications::DB::Schema->connect('dbi:SQLite:db/publications.db');
my $faculty = from_json(read_file('public/json/faculty.json'));

for my $member (@{$faculty}) {
  my $fac = $schema->resultset('Faculty')->create({
      name => $member->{name},
      gid  => $member->{gid},
  });

  my $file = qq(public/json/$member->{gid}.json); 
  my $pubs = from_json(read_file($file), {utf8 => 1});

  for my $url (@{$pubs->{urls}}) {
    $schema->resultset('Url')->create({
      faculty_id => $fac->id,
      url        => $url,
    });
  }

  for my $pub (@{$pubs->{publications}}) {
    $schema->resultset('Publication')->create({
      faculty_id => $fac->id,
      %{$pub}
    });
  }
}
