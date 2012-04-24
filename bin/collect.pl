#!/usr/bin/env perl

use Modern::Perl;
use FindBin qw($Bin);
use WWW::Mechanize;
use YAML qw(LoadFile);
use File::Slurp qw(write_file);
use Readonly;
use URI;

Readonly::Scalar my $BASE_URL        => 'http://scholar.google.com/citations?view_op=export_citations&hl=en&user=';
Readonly::Scalar my $EXPORT_FORMAT   => 0;
Readonly::Scalar my $EXPORT_BTN_TEXT => q{Export all articles by };

Readonly::Array my @FACULTY => LoadFile(qq{$Bin/../config/faculty.yml});

foreach my $member (@FACULTY) {
  my $uri   = URI->new($BASE_URL . $member->{gid});
  my $agent = WWW::Mechanize->new();

  $agent->agent_alias('Windows Mozilla');
  $agent->post($uri, {
    cit_fmt        => $EXPORT_FORMAT,
    export_all_byn => $EXPORT_BTN_TEXT . $member->{name},
  });

  write_file(
    qq{data/$member->{gid}.bib},
    {binmode => ':utf8'},
    $agent->content
  );
}
