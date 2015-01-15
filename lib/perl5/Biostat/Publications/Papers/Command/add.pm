package Biostat::Publications::Papers::Command::add;

use Biostat::Publications::Base qw(biostat);
use Biostat::Publications::Papers -command;

sub opt_spec {
  return (
    ['uniqname|u=s', 'Faculty member uniqname'],
    ['gid|g=s',      'Google Scholar GID'],
  );
}

sub validate_args {
  my ($self, $opt, $args) = @_;

  unless ($opt->{uniqname}) {
    $self->usage_error('uniqname is required');
  }

  my $realname = get_umod_realname($opt->{uniqname});
  unless ($realname) {
    $self->usage_error('unable to retrieve realname from mcommunity');
  }

  $self->{stash}->{uniqname} = $opt->{uniqname};
  $self->{stash}->{realname} = cleanName($realname);
  $self->{stash}->{gid}      = $opt->{gid} // undef;
}

sub execute {
  my ($self, $opt, $args) = @_;
  my $db = Biostat::Publications::DB->new();
  $db->resultset('Faculty')->create($self->{stash});
}

1;

__END__

=head1 NAME

Biostat::Publications::Papers::Command::add - Add a new faculty member to the publications database.

=cut
