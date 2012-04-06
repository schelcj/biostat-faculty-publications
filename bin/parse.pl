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

Readonly::Scalar my $DATA_DIR  => qq{$Bin/../data};
Readonly::Scalar my $JSON_FILE => qq{$DATA_DIR/publications.json};
Readonly::Array  my @COLUMNS   => (qw(title author journal volume number pages year publisher));

my $json         = JSON->new();
my @exports      = read_dir($DATA_DIR);
my @publications = ();

foreach my $export (@exports) {
  my $file = File::PathInfo->new();
  $file->set(qq{$DATA_DIR/$export});

  my $fh    = IO::File->new($file->abs_path());
  my $bib   = BibTeX::Parser->new($fh);
  my @pubs  = ();

  while (my $entry = $bib->next) {
    push @pubs, {map {$_ => $entry->field($_)} @COLUMNS};
  }

  push @publications, {
    name => $file->filename_only,
    pubs => \@pubs,
  };
}

write_file($JSON_FILE, $json->pretty->encode(\@publications));
