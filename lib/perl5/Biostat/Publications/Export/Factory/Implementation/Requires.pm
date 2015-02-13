package Biostat::Publications::Export::Factory::Implementation::Requires;

use Moose::Role;

requires(
  qw(
    output
    export
  )
);

1;
