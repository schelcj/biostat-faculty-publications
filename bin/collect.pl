#!/usr/bin/env perl

use Modern::Perl;
use FindBin qw($Bin);
use WWW::Mechanize;
use YAML qw(LoadFile);
use File::Slurp qw(write_file);
use Readonly;
use URI;

Readonly::Scalar my $BASE_URL        => 'http://scholar.google.com/citations?view_op=export_citations&hl=en&user=%s';
Readonly::Scalar my $EXPORT_FORMAT   => 0;
Readonly::Scalar my $EXPORT_BTN_TEXT => q{Export all articles by %s};

Readonly::Array  my @FACULTY  => LoadFile(qq{$Bin/../config/faculty.yml});

foreach my $member (@FACULTY) {
  my $agent = get_agent();
  my $uri   = get_export_uri($member->{gid});
  my $post  = build_post_data($member->{name});

  $agent->post($uri, $post);

  store_publications($member->{name}, $agent->content);
}

sub get_agent {
  my $agent = WWW::Mechanize->new();
  $agent->agent_alias('Windows Mozilla');

  return $agent;
}

sub get_export_uri {
  my ($gid) = @_;
  my $url   = sprintf $BASE_URL, $gid;

  return URI->new($url);
}

sub build_post_data {
  my ($name) = @_;

  return {
    cit_fmt        => $EXPORT_FORMAT,
    export_all_byn => sprintf($EXPORT_BTN_TEXT, $name),
  };
}

sub store_publications {
  my ($name, $export) = @_;

  $name =~ s/\s+/_/g;
  my $file = sprintf q{data/%s.bib}, lc($name);

  write_file($file, $export);

  return;
}
