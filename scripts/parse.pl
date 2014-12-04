#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use IO::File;
use File::PathInfo;
use BibTeX::Parser;
use File::Slurp qw(read_dir write_file);
use Data::Dumper;
use Readonly;
use JSON;
use Text::Autoformat;
use YAML qw(LoadFile);
use HTML::Template;

Readonly::Scalar my $DATA_DIR     => qq{$Bin/../data};
Readonly::Scalar my $TEMPLATE_DIR => qq{$Bin/../lib/templates};
Readonly::Scalar my $PUBLIC_DIR   => qq{$Bin/../public};
Readonly::Scalar my $JSON_DIR     => qq{$PUBLIC_DIR/json};
Readonly::Scalar my $FAC_HTML     => qq{$PUBLIC_DIR/faculty.html};
Readonly::Scalar my $JSON_VAR     => q{aaData};
Readonly::Scalar my $BASE_URL     => q{http://scholar.google.com/citations?user=};

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

my $tmpl = HTML::Template->new(
  filename => qq{$TEMPLATE_DIR/faculty.html.tmpl},
  utf8     => 1,
);

my $params = {
  faculty => [
    map {
      name => $_->{name},
      gid  => $_->{gid},
      url  => $_->{url},
    }, sort {$a->{name} cmp $b->{name}} @{$faculty_ref}
  ]
};

$tmpl->param($params);
write_file($FAC_HTML, $tmpl->output);
