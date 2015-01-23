package Biostat::Publications::Constants;

use base qw(Exporter);
use Readonly;

our @EXPORT_OK = (
  qw(
    $EMPTY
    $PIPE
    $SPACE
    $EQUAL
    $COMMA
    $HYPHEN
    $COLON
    $SEMICOLON
    $TRUE
    $FALSE
    )
);

our %EXPORT_TAGS = (
  all => [
    qw(
      $EMPTY
      $PIPE
      $SPACE
      $EQUAL
      $COMMA
      $HYPHEN
      $COLON
      $SEMICOLON
      $TRUE
      $FALSE
      )
  ],
);

Readonly::Scalar our $EMPTY     => q{};
Readonly::Scalar our $PIPE      => q{|};
Readonly::Scalar our $SPACE     => q{ };
Readonly::Scalar our $EQUAL     => q{=};
Readonly::Scalar our $COMMA     => q{,};
Readonly::Scalar our $HYPHEN    => q{-};
Readonly::Scalar our $COLON     => q{:};
Readonly::Scalar our $SEMICOLON => q{;};
Readonly::Scalar our $TRUE      => q{1};
Readonly::Scalar our $FALSE     => q{0};

1;
