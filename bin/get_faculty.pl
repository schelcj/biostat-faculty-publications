#!/usr/bin/env perl

use lib qq($ENV{HOME}/src/biostat/lib/perl5);
use FindBin qw($Bin);
use Modern::Perl;
use JSON;
use Mojo::UserAgent;
use Biostat::LDAP qw(get_umod_realname);
use File::Slurp qw(write_file read_file);
use Text::Names qw(reverseName cleanName);
use URI;
use URI::QueryParam;

my $faculty_url = q{http://www.sph.umich.edu/iscr/faculty/dept.cfm?deptID=1};
my $css         = q{#main-content > h2:nth-child(9) ~ p > a:nth-child(1)};
my $agent       = Mojo::UserAgent->new();
my @uniqnames   = ();
my @names       = ();

$agent->get($faculty_url)->res->dom($css)->each(
  sub {
    my $uri      = URI->new(shift->attr('href'));
    my $uniqname = $uri->query_param('uniqname');
    my $realname = get_umod_realname($uniqname);

    if ($uniqname eq 'yili') {
      $realname = 'Yi Li';
    }

    push @uniqnames, {uniqname => $uniqname, realname => $realname, cleanname => cleanName($realname)};
  }
);

@names = sort {$a->{cleanname} cmp $b->{cleanname}} @uniqnames;
write_file(qq{$Bin/../public/json/faculty.json}, to_json(\@names, {pretty => 1, utf8 => 1}));
