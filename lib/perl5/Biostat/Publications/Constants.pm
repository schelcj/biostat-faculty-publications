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
    %USER_AGENT_ALIASES
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
      %USER_AGENT_ALIASES
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

Readonly::Hash our %USER_AGENT_ALIASES => (
  'Windows IE 6'        => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
  'Windows Mozilla'     => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6',
  'Mac Safari'          => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/85 (KHTML, like Gecko) Safari/85',
  'Mac Mozilla'         => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401',
  'Linux Mozilla'       => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624',
  'Linux Konqueror'     => 'Mozilla/5.0 (compatible; Konqueror/3; Linux)',
  'Linux Ubuntu FF'     => q{Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0},
  'Linux Ubuntu Chrome' => q{Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36},
);
1;
