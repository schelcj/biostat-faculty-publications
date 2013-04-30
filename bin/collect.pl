#!/usr/bin/env perl

# TODO - do not pull results for publications we already have

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use YAML qw(LoadFile);
use Mojo::UserAgent;
use JSON;
use File::Slurp qw(write_file read_file);
use File::Spec;
use Getopt::Compact;
use List::MoreUtils qw(none);
use Data::Dumper;

## no tidy
my $opts = Getopt::Compact->new(
  modes  => [qw(verbose debug)],
  struct => [
    [[qw(u urls)],         q{Get urls for all results}],
    [[qw(p publications)], q{Get publication data}],
    [[qw(s sleep)],        q{Time, in seconds, to sleep between page fetches}],
  ]
)->opts();
## use tidy

my $max_sleep = $opts->{sleep} || 120;
my $public_dir  = File::Spec->join($Bin,        q{../public});
my $json_dir    = File::Spec->join($public_dir, q{json});
my $faculty_yml = File::Spec->join($Bin,        q{../config/faculty.yml});
my @faculty     = LoadFile($faculty_yml);
my $base_url    = q{http://scholar.google.com};
my $cite_list_url = q{/citations?hl=en&pagesize=100&user=};
my $json_opts     = {pretty => 1, utf8 => 1};
my $agent_ref     = {
  'Windows IE 6'    => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
  'Windows Mozilla' => 'Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6',
  'Mac Safari'      => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/85 (KHTML, like Gecko) Safari/85',
  'Mac Mozilla'     => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401',
  'Linux Mozilla'   => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624',
  'Linux Konqueror' => 'Mozilla/5.0 (compatible; Konqueror/3; Linux)',
  'Linux Ubuntu FF' => q{Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:20.0) Gecko/20100101 Firefox/20.0},
};
my $css_path_ref = {
  item      => q{td#col-title a.cit-dark-large-link},
  title     => q{div#main_sec.g-section div.cit-dl div.cit-dd div#title a},
  title_alt => q{div#main_sec.g-section div.cit-dl div.cit-dd div#title},
  authors   => q{div#main_sec.g-section div.cit-dl div.g-section div.cit-dd},
  pub_date  => q{div#main_sec.g-section div.cit-dl div#pubdate_sec.g-section div.cit-dd},
  journal   => q{div#main_sec.g-section div.cit-dl div#venue_sec.g-section div.cit-dd},
  volume    => q{div#main_sec.g-section div.cit-dl div#volume_sec.g-section div.cit-dd},
  issue     => q{div#main_sec.g-section div.cit-dl div#issue_sec.g-section div.cit-dd},
  pages     => q{div#main_sec.g-section div.cit-dl div#pages_sec.g-section div.cit-dd},
  next_lnk  => q{a.cit-dark-link},
};

if ($opts->{urls}) {
  for my $member (@faculty) {
    my %publications = ();
    @publications{keys %{$member}} = values %{$member};
    $publications{urls} = get_urls_for_faculty_member($member);

    save_publications($member->{gid}, \%publications);
  }
}

if ($opts->{publications}) {
  for my $member (@faculty) {
    verbose("Processing publications for $member->{name}");

    my $fac_json     = get_faculty_json($member->{gid});
    my $publications = from_json(read_file($fac_json));

    for my $url (@{$publications->{urls}}) {
      $url = $base_url . $url;
      verbose("Fetch publications list on $url");

      my $page    = get_page($url);
      get_publications($page, $publications->{publications});
    }

    save_publications($member->{gid}, $publications);
  }
}

sub get_faculty_json {
  my ($gid) = @_;
  return File::Spec->join($json_dir, $gid . q{.json});
}

sub save_publications {
  my ($gid, $publications) = @_;
  my $fac_json = get_faculty_json($gid);
  debug("Writing publications to $fac_json");
  write_file($fac_json, to_json($publications, $json_opts));
  return;
}

sub get_publications {
  my ($page, $publications) = @_;

  $page->res->dom->find($css_path_ref->{item})->each(
    sub {
      my $title = $_->text;
      my $href  = $_->attrs('href');
      my $url   = $base_url . $href;

      if (none {$_->{title} eq $title} @{$publications}) {
        my $page = get_page($url);

        debug("Parsing publication on $url");

        my $pub_ref = {
          url     => $url,
          title   => get_title($page) || get_title_alt($page),
          date    => get_pub_date($page),
          journal => get_journal($page),
          volume  => get_volume($page),
          issue   => get_issue($page),
          pages   => get_pages($page),
        };

        verbose("Found publication $pub_ref->{title}");

        push @{$publications}, $pub_ref;
      }
    }
  );

  return $publications;
}

sub get_urls_for_faculty_member {
  my ($member) = @_;
  my $urls = [];

  push @{$urls}, $cite_list_url . $member->{gid};

  {
    my $url   = $base_url . $urls->[-1];
    my $page  = get_page($url);
    my $links = $page->res->dom->find($css_path_ref->{next_lnk});
    last if not $links;

    my $lnk = $links->first(sub {$_->text =~ /^Next/});
    last if not $lnk;

    push @{$urls}, $lnk->attrs('href');
    redo;
  }

  return $urls;
}

sub get_page {
  my ($url) = @_;
  my $agent = _get_agent();
  my $sleep = int(rand($max_sleep));

  debug("Delaying for $sleep seconds before next GET");
  sleep $sleep;
  return $agent->get($url);
}

sub get_title     {return _get_node_text(shift, q{title});}
sub get_title_alt {return _get_node_text(shift, q{title_alt});}
sub get_authors   {return _get_node_text(shift, q{authors});}
sub get_pub_date  {return _get_node_text(shift, q{pub_date});}
sub get_journal   {return _get_node_text(shift, q{journal});}
sub get_volume    {return _get_node_text(shift, q{volume});}
sub get_issue     {return _get_node_text(shift, q{issue});}
sub get_pages     {return _get_node_text(shift, q{pages});}

sub _get_agent {
  my $agent   = Mojo::UserAgent->new();
  my @aliases = keys %{$agent_ref};
  my $alias   = $aliases[rand(int(scalar @aliases))];

  debug("UserAgent set to $alias");

  $agent->name($agent_ref->{$alias});

  return $agent;
}

sub _get_node_text {
  my ($page, $path) = @_;
  my $node = $page->res->dom->at($css_path_ref->{$path});
  return $node ? $node->text : q{};
}

sub debug   { say "[DEBUG] $_[0]" if $opts->{debug}; }
sub verbose { say "[INFO] $_[0]" if $opts->{verbose}; }
