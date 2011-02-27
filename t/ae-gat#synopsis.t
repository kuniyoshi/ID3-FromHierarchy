use utf8;
use Modern::Perl;
use File::Spec::Functions qw( catfile );

use Test::More;
eval "use Test::Synopsis";
if ( $@ ) {
    plan skip_all => "Test::Synopsis required for testing";
}
else {
    plan tests => 1;
}

my $module = catfile( "lib", "ID3", "FromHierarchy", "GenreArtistTitle.pm" );

synopsis_ok( $module );

