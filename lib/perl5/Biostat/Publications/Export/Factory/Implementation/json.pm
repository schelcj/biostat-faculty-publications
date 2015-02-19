package Biostat::Publications::Export::Factory::Implementation::json;

use Biostat::Publications::Base qw(biostat formats moose);

with 'Biostat::Publications::Export::Roles::Output';

sub export {
  my ($self) = @_;

  my $db = Biostat::Publications::DB->new();
  my @faculty = $db->resultset('Faculty')->all;

  return $TRUE;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
