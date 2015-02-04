package Biostat::Publications::Papers::Command::abstracts;

use Biostat::Publications::Papers -command;
use Biostat::Publications::Base qw(biostat www);

sub opt_spec {
  return (['import|i', 'Import abstracts from pubmed'],);
}

sub execute {
  my ($self, $opt, $args) = @_;

  if ($opt->{import}) {
    my $db = Biostat::Publications::DB->new();

    for my $pub ($db->resultset('Publication')->all) {
      print Dumper $pub->pmid->abstract;
    }

  }

  return;
}

1;

__END__

=head1 NAME

Biostat::Publications::Papers::Command::abstracts - Import publication abstracts

=cut
