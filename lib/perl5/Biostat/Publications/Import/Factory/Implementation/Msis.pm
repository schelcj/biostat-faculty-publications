package Biostat::Publications::Import::Factor::Implementation::Msis;

use Biostat::Publications::Base qw(biostat cache moose www);

Readonly::Scalar my $CACHE_ROOT => qq{$Bin/../var/cache/msis};
Readonly::Scalar my $URL_FMT    => q{https://www.umms.med.umich.edu/profile/publications/%s.json};

has 'faculty_id' => (is => 'ro', isa => 'Int',         required => 1);
has 'uniqname'   => (is => 'ro', isa => 'Str',         required => 1);
has 'gid'        => (is => 'ro', isa => 'Str',         required => 1);
has 'url'        => (is => 'ro', isa => 'Str',         lazy     => 1, builder => '_build_url');
has 'cache'      => (is => 'ro', isa => 'Cache::File', lazy     => 1, builder => '_build_cache');

sub _build_url {
  return sprintf $URL_FMT, shift->uniqname;
}

sub _build_cache {
  return Cache::File->new(cache_root => $CACHE_ROOT);
}

sub get_publications {
  my ($self) = @_;
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
