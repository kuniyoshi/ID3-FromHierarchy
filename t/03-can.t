use utf8;
use strict;
use warnings;
use ID3::FromHierarchy;
use Test::More tests => 1;

my @methods = qw( get_tag_from_filename );

can_ok( "ID3::FromHierarchy", @methods );
