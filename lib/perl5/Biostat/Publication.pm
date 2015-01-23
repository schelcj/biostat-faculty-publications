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
has 'authors'    => (is => 'rw', isa => 'Str');    # XXX - make this an array of cleaned names
has 'year'       => (is => 'rw', isa => 'Int');
has 'timescited' => (is => 'rw', isa => 'Int');
has 'pmid'       => (is => 'rw', isa => 'Maybe[Int]');
has 'scopuseid'  => (is => 'rw', isa => 'Int');

around 'authors' => sub {
  my ($orig, $self) = @_;
};

sub is_cached {
  my ($self) = @_;
  return 1;
}

sub save {
  my ($self) = @_;
  return;
}

sub update {
  my ($self) = @_;
  return;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
