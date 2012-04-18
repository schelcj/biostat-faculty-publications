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

Readonly::Scalar my $DATA_DIR => qq{$Bin/../data};
Readonly::Scalar my $JSON_DIR => qq{$Bin/../public/json};
Readonly::Scalar my $FAC_JSON => qq{$JSON_DIR/faculty.json};
Readonly::Scalar my $JSON_VAR => q{aaData};

Readonly::Array my @COLUMNS => (qw(title author journal volume number pages year publisher));

my $json        = JSON->new();
my @exports     = read_dir($DATA_DIR);
my $faculty_ref = {};

foreach my $export (@exports) {
  my @publications = ();
  my $file         = File::PathInfo->new();

  $file->set(qq{$DATA_DIR/$export});

  next if $file->ext ne 'bib';

  my $fh       = IO::File->new($file->abs_path());
  my $bib      = BibTeX::Parser->new($fh);
  my $filename = $file->filename_only();

  while (my $entry = $bib->next) {
    push @publications, [map {$entry->field($_)} @COLUMNS];
  }

  write_file(qq[$JSON_DIR/$filename.json], $json->pretty->encode({$JSON_VAR => \@publications}));

  $faculty_ref->{$filename} = clean_name($filename);
}

write_file($FAC_JSON, $json->pretty->encode($faculty_ref));

sub clean_name {
  my ($name) = @_;

  $name =~ s/\_/ /g;
  $name = autoformat $name, {case => 'title'};
  $name =~ s/[\r\n]//g;

  return $name;
}
