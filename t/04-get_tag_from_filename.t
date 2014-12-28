use utf8;
use strict;
use warnings;
use File::Spec::Functions qw( catfile );
use ID3::FromHierarchy;
use Test::More;

my @cases = (
    [
        [ "genre", "artist", "music.mp3" ],
        { genre => "genre", artist => "artist", album => undef, title => "music.mp3", track => undef },
    ],
    [
        [ "genre", "artist", "01 - music.mp3" ],
        { genre => "genre", artist => "artist", album => undef, title => "music.mp3", track => "01" },
    ],
    [
        [ "genre", "artist", "album", "music.mp3" ],
        { genre => "genre", artist => "artist", disk_number => undef, album => "album", title => "music.mp3", track => undef },
    ],
    [
        [ "genre", "artist", "album", "01 - music.mp3" ],
        { genre => "genre", artist => "artist", disk_number => undef, album => "album", title => "music.mp3", track => "01" },
    ],
    [
        [ "genre", "artist", "01 - album", "music.mp3" ],
        { genre => "genre", artist => "artist", disk_number => "01", album => "album", title => "music.mp3", track => undef },
    ],
    [
        [ "genre", "artist", "01 - album", "01 - music.mp3" ],
        { genre => "genre", artist => "artist", disk_number => "01", album => "album", title => "music.mp3", track => "01" },
    ],
);

plan tests => scalar @cases;

for my $case_ref ( @cases ) {
    my( $paths_ref, $tag_ref ) = @{ $case_ref };
    my $filename = catfile( @{ $paths_ref } );
    my %tag = ID3::FromHierarchy::get_tag_from_filename( $filename );
    is_deeply( \%tag, $tag_ref, $filename );
}
