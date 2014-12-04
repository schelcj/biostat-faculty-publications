#!/usr/bin/env perl

use lib qq($ENV{HOME}/src/biostat/lib/perl5);
use FindBin qw($Bin);
use Modern::Perl;
use JSON;
use File::Slurp qw(write_file read_file);
use Biostat::LDAP qw(get_umod_realname);
use Text::Names qw(cleanName samePerson reverseName);

my $names = from_json(read_file(qq{$Bin/../public/json/faculty.json}), {utf8 => 1});

for my $name (@{$names}) {
  my $file         = qq{$Bin/../public/json/faculty/$name->{uniqname}.json};
  my $publications = from_json(read_file($file), {utf8 => 1});
  my @articles     = @{$publications->{publications}->{article}};
  my $count        = ($publications->{publications}->{count} - 1);
  my $realname     = reverseName($name->{cleanname});

  for my $i (0 .. $count) {
    my @authors = split(/; /, $articles[$i]->{author});
    my @cleaned_authors = map {(samePerson($realname, $_)) ? $realname : $_} map {reverseName(cleanName($_))} @authors;

    $publications->{publications}->{article}->[$i]->{clean_author} = join('; ', @cleaned_authors);
    $publications->{umod_realname} = $realname;
  }

  write_file($file, to_json($publications, {pretty => 1, utf8 => 1}));
}
