package Biostat::Publications::Types;

use Biostat::Publications::Base qw(biostat files);
use Moose::Util::TypeConstraints;

subtype 'ValidOutputFile',
  as 'Str',
  where { (-e $_ and -w $_) or ($_ eq $HYPHEN) or (-w dirname($_))},
  message { 'Unable to write to output file ' . $_ };

no Moose::Util::TypeConstraints;

1;
