package Biostat::Publications::DB;

use base qw(Biostat::Publications::DB::Schema);

sub new {
  # TODO - load this info from a config file or something
  my $dsn = qq{dbi:mysql:database=$ENV{DB};host=$ENV{DB_HOST}};
  return __PACKAGE__->connect($dsn, $ENV{DB_USER}, $ENV{DB_PASS}, {mysql_enable_utf8 => 1});
}

1;
