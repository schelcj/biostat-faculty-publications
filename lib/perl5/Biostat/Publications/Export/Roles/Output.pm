package Biostat::Publications::Export::Roles::Output;

use Moose::Role;
use Biostat::Publications::Base qw(biostat files);

has 'output' => (is => 'rw', isa => 'ValidOutputFile');

sub write_output {
  my ($self, $content) = @_;
  $content > io($self->output);
  return;
}

sub is_stdout {
  return shift->output eq $HYPHEN;
}


1;
