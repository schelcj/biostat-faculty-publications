package Biostat::Publication;

use Biostat::Publications::Base qw(biostat moose);

has 'db'         => (is => 'ro', isa => 'Biostat::Publications::DB', required => 1);
has 'faculty_id' => (is => 'ro', isa => 'Int',                       required => 1);
has 'src_url'    => (is => 'ro', isa => 'Str',                       required => 1);
has 'title'      => (is => 'ro', isa => 'Str');
has 'authors'    => (is => 'ro', isa => 'Maybe[Str]', trigger => \&_set_authors);
has 'pubmed_url' => (is => 'ro', isa => 'Maybe[Str]');
has 'scival_url' => (is => 'ro', isa => 'Maybe[Str]');
has 'abstract'   => (is => 'ro', isa => 'Maybe[Str]');
has 'date'       => (is => 'ro', isa => 'Maybe[Str]');
has 'journal'    => (is => 'ro', isa => 'Maybe[Str]');
has 'volume'     => (is => 'ro', isa => 'Maybe[Str]');
has 'issue'      => (is => 'ro', isa => 'Maybe[Str]');
has 'pages'      => (is => 'ro', isa => 'Maybe[Str]');
has 'year'       => (is => 'ro', isa => 'Maybe[Int]');
has 'timescited' => (is => 'ro', isa => 'Maybe[Int]');
has 'pmid'       => (is => 'ro', isa => 'Maybe[Int]');
has 'scopuseid'  => (is => 'ro', isa => 'Maybe[Int]');

sub _set_authors {
  my ($self, $new, $prev) = @_;

  my $faculty  = $self->db->resultset('Faculty')->find($self->faculty_id);
  my $realname = $faculty->realname;
  my @authors  = map {(samePerson($realname, $_)) ? $realname : $_}
    map {cleanName($_)} split(/$SEMICOLON\s/, $new);

  $self->{authors} = join($SEMICOLON . $SPACE, @authors);

  return;
};

sub to_hashref {
  my ($self) = @_;
  my $attr_ref = +{map {($_->name => $_->get_value($self, $_->name))} $self->meta->get_all_attributes};
  map {delete $attr_ref->{$_}} (qw(db abstract));
  return $attr_ref;
}

sub save {
  my ($self) = @_;

  my $count = $self->db->resultset('Publication')->count(
    {
      scopuseid  => $self->scopuseid,
      faculty_id => $self->faculty_id,
      title      => $self->title,
    }
  );

  unless ($count) {
    $self->db->resultset('Publication')->create($self->to_hashref);

    if ($self->pmid) {
      $self->db->resultset('Abstract')->create(
        {
          pmid => $self->pmid,
          text => $self->abstract // $EMPTY,
        }
      );
    }
  }

  return $TRUE;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
