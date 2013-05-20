#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use Mojo::UserAgent;
use File::Slurp qw(write_file read_file);
use File::Spec;
use Getopt::Compact;
use List::MoreUtils qw(none);
use Biostat::Publications::DB::Schema;
use English qw(-no_match_vars);

$OUTPUT_AUTOFLUSH = 1;

## no tidy
my $opts = Getopt::Compact->new(
  modes  => [qw(verbose debug)],
  struct => [
    [[qw(u urls)],         q{Get urls for all results}],
    [[qw(p publications)], q{Get publication data}],
    [[qw(s sleep)],        q{Time, in seconds, to sleep between page fetches}],
    [[qw(update)],         q{Force updating any publications found}],
  ]
)->opts();
## use tidy

my $schema        = Biostat::Publications::DB::Schema->connect('dbi:SQLite:db/publications.db');
my $max_sleep     = $opts->{sleep} || 120;
my $base_url      = q{http://scholar.google.com};
my $cite_list_url = q{/citations?hl=en&pagesize=100&user=};
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
  for my $member ($schema->resultset('Faculty')->all()) {
    verbose('Getting urls for ' . $member->name);
    my $urls = get_urls_for_faculty_member($member->gid);

    for my $url (@{$urls}) {
      my $url = $member->urls({url => $url});

      if (not $url) {
        verbose('Found new url for ' . $member->name);
        $member->add_to_urls({url => $url});
      }
    }
  }
}

if ($opts->{publications}) {
  for my $member ($schema->resultset('Faculty')->all()) {
    verbose('Processing publications for ' . $member->name);
    record_publications_for_member($member);
  }
}

sub record_publications_for_member {
  my ($member) = @_;
  my $publications = [];

  for my $url ($member->urls) {
    verbose('Fetch publications list on ' . $url->url);
    my $pub_page = get_page($url->url);

    $pub_page->res->dom->find($css_path_ref->{item})->each(
      sub {
        my $title = $_->text;
        my $href  = $_->attrs('href');

        my $publication = $member->publications->find({title => $title});

        if ($publication) {
          if ($opts->{update}) {
            my $pub_ref = get_publication($href);
            verbose("Updating $title");
            $publication->update($pub_ref);
          } else {
            verbose('Found existing publication and not updating');
          }
        } else {
          my $pub_ref = get_publication($href);
          verbose("Found new publication '$title'");
          $member->add_to_publications($pub_ref);
        }
      }
    );
  }

  return;
}

sub get_urls_for_faculty_member {
  my ($gid) = @_;
  my $urls = [];

  push @{$urls}, $cite_list_url . $gid;

  {
    my $page  = get_page($urls->[-1]);
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
  my $uri = URI->new_abs($url, $base_url);

  verbose("Fetching $uri");
  debug("Delaying for $sleep seconds before next GET");
  sleep $sleep;

  return $agent->get($uri->as_string);
}

sub get_publication {
  my ($href) = @_;
  my $page   = get_page($href);

  debug("Parsing publication on $href");

  return {
    url     => $href,
    title   => get_title($page) || get_title_alt($page),
    date    => get_pub_date($page),
    journal => get_journal($page),
    volume  => get_volume($page),
    issue   => get_issue($page),
    pages   => get_pages($page),
    authors => get_authors($page),
  };
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

sub debug   {say "[DEBUG] $_[0]" if $opts->{debug};}
sub verbose {say "[INFO] $_[0]"  if $opts->{verbose};}
