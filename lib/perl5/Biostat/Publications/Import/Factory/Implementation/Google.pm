package Biostat::Publications::Import::Factory::Implementation::Google;

use Biostat::Publications::Base qw(biostat moose www);

Readonly::Scalar my $BASE_URL          => q{http://scholar.google.com};
Readonly::Scalar my $CITE_LIST_URL_FMT => q{/citations?hl=en&pagesize=100&user=%s};

Readonly::Hash my $CSS => {
  item      => q{td#col-title a.cit-dark-large-link},
  title     => q{div#main_sec.g-section div.cit-dl div.cit-dd div#title a},
  title_alt => q{div#main_sec.g-section div.cit-dl div.cit-dd div#title},
  authors   => q{div#main_sec.g-section div.cit-dl div.g-section div.cit-dd},
  pub_date  => q{div#main_sec.g-section div.cit-dl div#pubdate_sec.g-section div.cit-dd},
  journal   => q{div#main_sec.g-section div.cit-dl div#venue_sec.g-section div.cit-dd},
  volume    => q{div#main_sec.g-section div.cit-dl div#volume_sec.g-section div.cit-dd},
  issue     => q{div#main_sec.g-section div.cit-dl div#issue_sec.g-section div.cit-dd},
  pages     => q{div#main_sec.g-section div.cit-dl div#pages_sec.g-section div.cit-dd},
  next_lnk  => q{a.cit-dark-link},
};

has 'faculty_id' => (is => 'ro', isa => 'Int', required => 1);
has 'uniqname'   => (is => 'ro', isa => 'Str', required => 1);
has 'gid'        => (is => 'ro', isa => 'Str', required => 1);

sub get_publications {
  my ($self) = @_;
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
