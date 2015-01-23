package Biostat::Publications::Import::Factory::Implementation::Msis;

use Biostat::Publications::Base qw(biostat cache moose www);

Readonly::Scalar my $CACHE_ROOT => qq{$Bin/../var/cache/msis};
Readonly::Scalar my $URL_FMT    => q{https://www.umms.med.umich.edu/profile/publications/%s.json};

has 'faculty_id' => (is => 'ro', isa => 'Int',               required => 1);
has 'uniqname'   => (is => 'ro', isa => 'Str',               required => 1);
has 'gid'        => (is => 'ro', isa => 'Str',               required => 1);
has 'url'        => (is => 'ro', isa => 'Str',               lazy     => 1, builder => '_build_url');
has 'cache'      => (is => 'ro', isa => 'Cache::File',       lazy     => 1, builder => '_build_cache');
has 'raw'        => (is => 'ro', isa => 'Str',               lazy     => 1, builder => '_build_raw');
has 'articles'   => (is => 'ro', isa => 'ArrayRef[HashRef]', lazy     => 1, builder => '_build_articles');

sub _build_url {
  return sprintf $URL_FMT, shift->uniqname;
}

sub _build_cache {
  return Cache::File->new(cache_root => $CACHE_ROOT);
}

sub _build_raw {
  my ($self) = @_;
  my $agent = Mojo::UserAgent->new();
  return $agent->get($self->url)->res->content->asset->slurp;
}

sub _build_articles {
  my ($self) = @_;
  my $pub_ref = from_json($self->raw);
  return $pub_ref->{publications}->{article};
}

sub get_publications {
  my ($self) = @_;

  my $publications = [];
  for my $article (@{$self->articles}) {
    push @{$publications}, Biostat::Publication->new(
      faculty_id => $self->faculty_id,
      src_url    => $self->url,
      scival_url => $article->{scivalURL},
      title      => $article->{title},
      abstract   => $EMPTY,                          # XXX - need to fetch the abstract from nih
      journal    => $article->{journalTitle},
      volume     => $article->{journalVolume},
      issue      => $article->{journalIssue},
      pages      => $article->{pages},
      authors    => $article->{author},
      year       => $article->{year},
      timescited => $article->{timescited},
      pmid       => $article->{pmid},
      scopuseid  => $article->{scopusEID},
    );
  }

  print Dumper $publications;

  return $publications;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
