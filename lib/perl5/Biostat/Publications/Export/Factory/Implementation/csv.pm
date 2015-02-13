package Biostat::Publications::Export::Factory::Implementation::csv;

use Biostat::Publications::Base qw(biostat formats moose);

with 'Biostat::Publications::Export::Roles::Output';

Readonly::Array my @HEADERS => (
  qw(
    title
    journal
    authors
    abstract
    )
);

sub export {
  my ($self) = @_;

  my $db           = Biostat::Publications::DB->new();
  my $csv          = Class::CSV->new(fields => \@HEADERS);
  my @publications = $db->resultset('Publication')->all();

  $csv->add_line(\@HEADERS);

 for my $publication (@publications) {
   my $line          = {map {$_ => $publication->$_} grep {!/abstract/} @HEADERS};
   #  $line->{abstract} = $publication->abstracts->first;

   print Dumper $line;

   $csv->add_line($line);
 }

  $self->write_output($csv->string);

  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
