#!/usr/bin/env perl

use FindBin qw($Bin);
use Modern::Perl;
use YAML qw(LoadFile);
use Mojo::UserAgent;
use Text::Names qw(samePerson);
use List::MoreUtils qw(none);

my $ua  = Mojo::UserAgent->new();
my @fac = LoadFile(qq{$Bin/../config/faculty.yml});
my $tx  = $ua->get('http://www.sph.umich.edu/iscr/faculty/dept.cfm?deptID=1');
my $css = q{td#content table:nth-child(7) tr td.list a strong};

$tx->res->dom($css)->each(sub {
  (my $name = shift->text) =~ s/,.*$//g;
  if (none {samePerson($_, $name)} map {$_->{name}} @fac) {
    say $name;
  }
});
