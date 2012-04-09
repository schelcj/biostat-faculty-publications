#!/usr/bin/env perl

use Modern::Perl;
use FindBin qw($Bin);
use IO::File;
use File::PathInfo;
use BibTeX::Parser;
use File::Slurp qw(read_dir write_file);
use Data::Dumper;
use Readonly;
use JSON;
use Text::Autoformat;

Readonly::Scalar my $DATA_DIR  => qq{$Bin/../data};
Readonly::Scalar my $JSON_FILE => qq{$DATA_DIR/publications.json};
Readonly::Scalar my $JSON_VAR  => q{aaData};
Readonly::Array  my @COLUMNS   => (qw(title author journal volume number pages year publisher));

my $json         = JSON->new();
my @exports      = read_dir($DATA_DIR);
my @publications = ();

foreach my $export (@exports) {
  my $file = File::PathInfo->new();
  $file->set(qq{$DATA_DIR/$export});

  my $fh   = IO::File->new($file->abs_path());
  my $bib  = BibTeX::Parser->new($fh);
  my $name = clean_name($file->filename_only());

  while (my $entry = $bib->next) {
    my @pub = map {$entry->field($_)} @COLUMNS;
    unshift @pub, $name;
    push @publications, \@pub;
  }
}

write_file($JSON_FILE, $json->encode({$JSON_VAR => \@publications}));

sub clean_name {
  my ($name) = @_;

  $name =~ s/\_/ /g;
  $name = autoformat $name, {case => 'title'};
  $name =~ s/[\r\n]//g;

  return $name;
}
