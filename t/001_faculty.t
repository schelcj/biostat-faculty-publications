#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use Text::Names qw(cleanName parseName);
use Data::Dumper;
use Encode;

use Biostat::Publications::DB::Schema;

use Test::More tests => 60;
use Test::utf8;

my $schema = Biostat::Publications::DB::Schema->connect('dbi:SQLite:db/publications.db');
for my $member ($schema->resultset('Faculty')->all()) {
  my $name = encode('utf8', cleanName(decode('utf8', $member->name)));
  diag($name);
  is_valid_string($name);
  is_valid_string(cleanName($name));
}

done_testing();
