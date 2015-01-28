package Biostat::Publication;

use Biostat::Publications::Base qw(biostat moose);

has 'faculty_id' => (is => 'rw', isa => 'Int', required => 1);
has 'src_url'    => (is => 'rw', isa => 'Str', required => 1);
has 'pudmed_url' => (is => 'rw', isa => 'Str');
has 'scival_url' => (is => 'rw', isa => 'Str');
has 'title'      => (is => 'rw', isa => 'Str');
has 'abstract'   => (is => 'rw', isa => 'Maybe[Str]');
has 'date'       => (is => 'rw', isa => 'Str');
has 'journal'    => (is => 'rw', isa => 'Str');
has 'volume'     => (is => 'rw', isa => 'Maybe[Str]');
has 'issue'      => (is => 'rw', isa => 'Maybe[Str]');
has 'pages'      => (is => 'rw', isa => 'Maybe[Str]');
has 'authors'    => (is => 'rw', isa => 'Str');
has 'year'       => (is => 'rw', isa => 'Int');
has 'timescited' => (is => 'rw', isa => 'Int');
has 'pmid'       => (is => 'rw', isa => 'Maybe[Int]');
has 'scopuseid'  => (is => 'rw', isa => 'Int');

has 'db' => (is => 'ro', isa => 'Biostat::Publications::DB', lazy => 1, builder => '_builder_db');

around 'authors' => sub {
  my ($orig, $self) = @_;
  # XXX - clean up author names and remove duplicates
};

sub _build_db {
  return Biostat::Publications::DB->new();
}

sub save {
  my ($self) = @_;
  return $TRUE;
}

sub update {
  my ($self) = @_;
  return $TRUE;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
