#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
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
use YAML qw(LoadFile);

Readonly::Scalar my $DATA_DIR => qq{$Bin/../data};
Readonly::Scalar my $JSON_DIR => qq{$Bin/../public/json};
Readonly::Scalar my $FAC_JSON => qq{$JSON_DIR/faculty.json};
Readonly::Scalar my $JSON_VAR => q{aaData};
Readonly::Scalar my $BASE_URL => q{http://scholar.google.com/citations?user=};

Readonly::Array my @FACULTY => LoadFile(qq{$Bin/../config/faculty.yml});
Readonly::Array my @COLUMNS => (qw(title author journal volume number pages year));

my $json        = JSON->new()->utf8;
my @exports     = read_dir($DATA_DIR);
my $faculty_ref = [];

foreach my $export (@exports) {
  my @publications = ();
  my $file         = File::PathInfo->new();

  $file->set(qq{$DATA_DIR/$export});

  next if $file->ext ne 'bib';

  my $fh       = IO::File->new($file->abs_path());
  my $bib      = BibTeX::Parser->new($fh);
  my $gid      = $file->filename_only();
  my ($member) = grep {$_->{gid} eq $gid} @FACULTY;

  while (my $entry = $bib->next) {
    push @publications, [map {$entry->field($_)} @COLUMNS];
  }

  write_file(qq[$JSON_DIR/$gid.json], $json->encode({$JSON_VAR => \@publications}));

  push @{$faculty_ref}, {
    gid  => $gid,
    name => $member->{name},
    url  => $BASE_URL . $gid,
  };
}

write_file($FAC_JSON, $json->encode([sort {$a->{name} cmp $b->{name}} @{$faculty_ref}]));
