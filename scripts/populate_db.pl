#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);

use Modern::Perl;
use File::Slurp qw(read_dir read_file);
use JSON;
use Biostat::Publications::DB::Schema;
use Data::Dumper;

my $schema = Biostat::Publications::DB::Schema->connect('dbi:SQLite:db/publications.db');

for my $faculty (read_dir(q{public/json})) {
  my $faculty = from_json(read_file(qq{public/json/$faculty}));

  if (exists $faculty->{gid}) {
    my $fac = $schema->resultset('Faculty')->create({
        name => $faculty->{name},
        gid  => $faculty->{gid},
    });

    for my $url (@{$faculty->{urls}}) {
      $schema->resultset('Url')->create({
        faculty_id => $fac->id,
        url        => $url,
      });
    }
  }
}

