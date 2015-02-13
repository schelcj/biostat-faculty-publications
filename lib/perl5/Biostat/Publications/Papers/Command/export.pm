package Biostat::Publications::Papers::Command::export;

use Biostat::Publications::Base qw(biostat);
use Biostat::Publications::Papers -command;
use Biostat::Publications::Export::Factory;

sub opt_spec {
  return (
    ['format|f=s', 'Format to output publication data to [json|csv]'],
    ['output|o=s', 'Where to write output (defaults to STDOUT)'],
  );
}

sub validate_args {
  my ($self, $opt, $args) = @_;

  if ($opt->{format} !~ /json|csv/i) {
    $self->usage_error('Invalid format specified. Must be one of (json | csv)');
  }
}

sub execute {
  my ($self, $opt, $args) = @_;

  my $format = lc($opt->{format});
  my $output = $opt->{output} // $HYPHEN;
  my $export = Biostat::Publications::Export::Factory->create($format, {output => $output});

  $export->export;
}

1;

__END__

=head1 NAME

Biostat::Publications::Papers::Command::export - Export the publications database to JSON or CSV.

=cut
