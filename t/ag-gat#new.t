use utf8;
use Modern::Perl;
use ID3::FromHierarchy::GenreArtistTitle;

use Test::More tests => 1;

my $class = "ID3::FromHierarchy::GenreArtistTitle";

new_ok( $class );

