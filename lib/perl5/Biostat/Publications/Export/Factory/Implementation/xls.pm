package Biostat::Publications::Export::Factory::Implementation::xls;

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

  if ($self->is_stdout) {
    croak 'Can not write excel output to STDOUT';
  }

  my $db       = Biostat::Publications::DB->new();
  my $workbook = Excel::Writer::XLSX->new($self->output);
  my @faculty  = $db->resultset('Faculty')->all();

  for my $faculty (@faculty) {
    my ($row, $col) = (0, 0);
    my $worksheet = $workbook->add_worksheet($faculty->uniqname);

    $worksheet->write_row($row++, $col, \@HEADERS);

    for my $publication ($faculty->publications) {
      my $row_ref = [map {$publication->$_} grep {!/abstract/} @HEADERS];

      if ($publication->abstracts->count) {
        push @{$row_ref}, $publication->abstracts->first->text;
      }

      $worksheet->write_row($row++, $col, $row_ref);
    }
  }

  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

