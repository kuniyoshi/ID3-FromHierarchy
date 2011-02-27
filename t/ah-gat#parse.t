use utf8;
use Modern::Perl;
use File::Spec::Functions qw( catfile );
use ID3::FromHierarchy::GenreArtistTitle;

use Test::More tests => 14;
use Test::Data qw( Hash );

my @keys = qw( genre artist album track title );

my $p = ID3::FromHierarchy::GenreArtistTitle->new;

my $file;
my %tag;

# One path pattern.
$file = catfile(
    "favorite",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, q{} );

# Two pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, q{} );

# Three pathes pattern.
my %wish = (
    genre  => "favorite",
    artist => "GARNET CROW",
    album  => undef,
    track  => undef,
    title  => "水のない晴れた海へ",
);

$file = catfile(
    "favorite",
    "GARNET CROW",
    "水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, q{} );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "水のない晴れた海へ.MP3",
);
%tag = eval { $p->parse( $file ) };
is( $@, q{} );
is_deeply( \%tag, \%wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, q{} );
is_deeply( \%tag, { %wish, track => "01" } );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01-水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, q{} );
is_deeply( \%tag, { %wish, track => "01" } );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, q{} );
is_deeply( \%tag, { %wish, track => "01" } );

# Four pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, q{} );

# Five pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "Disc 1",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, q{} );

