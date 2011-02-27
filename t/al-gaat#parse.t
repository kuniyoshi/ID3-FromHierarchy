use utf8;
use Modern::Perl;
use File::Spec::Functions qw( catfile );
use ID3::FromHierarchy::GenreArtistAlbumTitle;

use Test::More tests => 18;
use Test::Data qw( Hash );

my @keys = qw( genre artist album track title );

my $p = ID3::FromHierarchy::GenreArtistAlbumTitle->new;

my $file;
my %tag;

# One path pattern.
$file = catfile(
    "favorite",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, "" );

# Two pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, "" );

# Three pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, "" );

# Four pathes pattern.
my %wish = (
    title  => "水のない晴れた海へ",
    track  => "01",
    artist => "GARNET CROW",
    album  => "first soundscope ～水のない晴れた海へ～",
    genre  => "favorite",
);

$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "01-水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "01 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, { %wish, track => undef } );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 - first soundscope ～水のない晴れた海へ～",
    "01 - 水のない晴れた海へ.MP3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 - first soundscope ～水のない晴れた海へ～",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "first soundscope ～水のない晴れた海へ～",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
is_deeply( \%tag, \%wish );

# Five pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "Disc 1",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, "" );

