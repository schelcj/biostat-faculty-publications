package Biostat::Publications::Base;

use base 'Import::Base';

our @IMPORT_MODULES = (
  'lib' => [qq($ENV{HOME}/src/biostat/lib/perl5)],
  'Modern::Perl',
  'Text::Names' => [qw(cleanName samePerson reverseName)],
);

our %IMPORT_BUNDLES = (
  www => [
    qw(
      Mojo::UserAgent
      HTML::Entities
      URI
      URI::QueryParam
      XML::XPath
      JSON
      )
  ],
  biostat => [
    'Biostat::LDAP' => [qw(get_umod_realname)],
    'Biostat::Publications::DB',
  ],
  files => [
    'File::Slurp::Tiny' => [qw(read_file write_file)],
    'File::Temp',
  ],
  testing => [
    qw(
      Test::More
      )
  ]
);

1;
