package Biostat::Publications::Import::Factory::Implementation::Requires;

use Moose::Role;

requires(
  qw(
    faculty_id
    uniqname
    gid
    get_publications
  )
);

1;
