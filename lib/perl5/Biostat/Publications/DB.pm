package Biostat::Publications::DB;

use base qw(Biostat::Publications::DB::Schema);

sub new {
  return __PACKAGE__->connect('dbi:SQLite:db/publications.db');
}

1;
