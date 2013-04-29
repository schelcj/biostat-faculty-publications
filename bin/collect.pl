#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use YAML qw(LoadFile);
use Mojo::UserAgent;
use JSON;
use File::Slurp qw(write_file);
use Data::Dumper;

my $publications     = [];
my $publication_json = qq{$Bin/../public/js/publications.json};
my @faculty          = LoadFile(qq{$Bin/../config/faculty.yml});
my $base_url         = q{http://scholar.google.com};
my $cite_list_url    = q{/citations?hl=en&pagesize=100&user=};
my $agent_ref        = {
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

for my $member (@faculty) {
  my $pub_ref = {};

  $pub_ref->{$member->{name}}->{urls} = get_urls_for_faculty_member($member);

=cut
  $fac_pubs->res->dom->find($css_path_ref->{item})->each(
    sub {
      my $cite_url = $base_url . $_->attrs('href');
      my $ua       = get_agent();
      my $dom      = $ua->get($cite_url)->res->dom();

      push @{$pub_ref->{$member->{name}}->{publications}}, {
        url     => $cite_url,
        title   => get_title($dom) || get_title_alt($dom),
        authors => get_authors($dom),
        date    => get_pub_date($dom),
        journal => get_journal($dom),
        volume  => get_volume($dom),
        issue   => get_issue($dom),
        pages   => get_pages($dom),
        };
    }
  );
=cut

  push @{$publications}, $pub_ref;
}

write_file($publication_json, to_json($publications, {pretty => 1, utf8 => 1}));

sub get_agent {
  my $agent   = Mojo::UserAgent->new();
  my @aliases = keys %{$agent_ref};
  my $alias   = $aliases[rand(int(scalar @aliases))];

  $agent->name($agent_ref->{$alias});

  return $agent;
}

sub get_urls_for_faculty_member {
  my ($member) = @_;
  my $urls     = [];

  push @{$urls}, $cite_list_url . $member->{gid};

  {
    sleep 5;

    my $url   = $base_url . $urls->[-1];
    my $agent = get_agent();

    my $links = $agent->get($url)->res->dom->find($css_path_ref->{next_lnk});
    last if not $links;

    my $lnk = $links->first(sub {$_->text =~ /^Next/});
    last if not $lnk;

    push @{$urls}, $lnk->attrs('href');
    redo;
  }

  return $urls;
}

sub _get_node_text {
  my ($dom, $path) = @_;
  my $node = $dom->at($css_path_ref->{$path});
  return $node ? $node->text : q{};
}

sub get_title     {return _get_node_text(shift, q{title});}
sub get_title_alt {return _get_node_text(shift, q{title_alt});}
sub get_authors   {return _get_node_text(shift, q{authors});}
sub get_pub_date  {return _get_node_text(shift, q{pub_date});}
sub get_journal   {return _get_node_text(shift, q{journal});}
sub get_volume    {return _get_node_text(shift, q{volume});}
sub get_issue     {return _get_node_text(shift, q{issue});}
sub get_pages     {return _get_node_text(shift, q{pages});}
