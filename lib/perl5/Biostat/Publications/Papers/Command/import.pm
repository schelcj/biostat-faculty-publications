package Biostat::Publications::Papers::Command::import;

use Biostat::Publications::Papers -command;
use Biostat::Publications::Base;
use Biostat::Publications::Import::Factory;

sub opt_spec {
  return (['source|s=s', 'Where to retrieve publications from (google or msis)'],);
}

sub validate_args {
  my ($self, $opt, $args) = @_;

  if ($opt->{source} !~ /google|msis/i) {
    $self->usage_error('Source must be one of (google | msis)');
  }
}

sub execute {
  my ($self, $opt, $args) = @_;

  my $db      = Biostat::Publications::DB->new();
  my @faculty = $db->resultset('Faculty')->all();

  for my $member (@faculty) {
    my $import = Biostat::Publications::Import::Factory->create(
      ucfirst(lc($opt->{source})), {
        faculty_id => $member->id,
        uniqname   => $member->uniqname,
        gid        => $member->gid,
      }
    );

    for my $publication ($import->get_publications) {
      $publication->save;
      print Dumper $publication;
    }
  }

}

1;

__END__

=head1 NAME

Biostat::Publications::Papers::Command::import - Import publications from a known source (ie; google or msis)

=cut
