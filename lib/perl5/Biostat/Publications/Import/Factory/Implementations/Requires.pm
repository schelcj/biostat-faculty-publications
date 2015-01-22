package Biostat::Publications::Import::Factor::Implementation::Requires;

use Biostat::Publications::Base qw(moose);

requires(
  qw(
    faculty_id
    uniqname
    gid
    get_publications
  )
);

1;
