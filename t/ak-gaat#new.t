use utf8;
use Modern::Perl;
use ID3::FromHierarchy::GenreArtistAlbumTitle;

use Test::More tests => 1;

my $class = "ID3::FromHierarchy::GenreArtistAlbumTitle";

new_ok( $class );

