package Biostat::Publications::Papers::Command::import;

use Biostat::Publications::Base;
use Biostat::Publications::Papers -command;

sub opt_spec {
  return (
    ['source|s=s', 'Where to retrieve publications from (google or msis)'],
  );
}

sub validate_args {
}

sub execute {
}

1;

__END__

=head1 NAME

Biostat::Publications::Papers::Command::import - Import publications from a known source (ie; google or msis)

=cut
