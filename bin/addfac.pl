#!/usr/bin/env perl

use FindBin qw($Bin);
use lib qq($Bin/../lib/perl5);
use Modern::Perl;
use IO::Prompt::Simple;
use Biostat::Publications::DB::Schema;

my $schema = Biostat::Publications::DB::Schema->connect('dbi:SQLite:db/publications.db');
my $name   = prompt 'Faculty member name';
my $gid    = prompt 'Google Scholar user id [gid]';

$schema->resultset('Faculty')->create({name => $name,gid => $gid});
