package Biostat::Publications::Base;

use base 'Import::Base';

our @IMPORT_MODULES = (
  'lib'         => [qq($ENV{HOME}/src/biostat/lib/perl5)],
  'FindBin'     => [qw($Bin)],
  'Carp'        => [qw(carp croak)],
  'Text::Names' => [qw(cleanName samePerson reverseName)],
  'Modern::Perl',
  'Data::Dumper',
  'Readonly',
);

our %IMPORT_BUNDLES = (
  www => [
    qw(
      Mojo::UserAgent
      HTML::Entities
      URI
      URI::QueryParam
      XML::XPath
      )
  ],
  biostat => [
    'Biostat::Publications::Constants' => [qw(:all)],
    'Biostat::LDAP'                    => [qw(get_umod_realname)],
    'Biostat::Publication',
    'Biostat::Publications::DB',
  ],
  files => [
    'IO::All'           => ['-utf8'],
    'File::Slurp::Tiny' => [qw(read_file write_file)],
    'File::Temp',
    'File::Basename',
  ],
  testing => [
    qw(
      Test::More
      )
  ],
  moose => [
    qw(
      Moose
      Biostat::Publications::Types
      )
  ],
  cache => [
    qw(
      Cache::File
      )
  ],
  formats => [
    qw(
      JSON
      Class::CSV
      Excel::Writer::XLSX
      )
  ]
);

1;
