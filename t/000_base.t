#!/usr/bin/env perl

use local::lib qw(./);
use Biostat::Publications::Base qw(www biostat files testing);

can_ok('Text::Names', 'cleanName');
can_ok('Mojo::UserAgent', 'new');
can_ok('File::Slurp::Tiny', 'read_file');
can_ok('Biostat::LDAP', 'get_umod_realname');

done_testing();
