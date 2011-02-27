use utf8;
use Modern::Perl;
use Path::Class qw( dir );
use File::Spec::Functions qw( catfile );
use ID3::FromHierarchy;

use Test::Data qw( Hash );
use Test::More tests => 7;

my $dir = dir( "sample_data" );

my @keys = qw( genre artist album track title );

my $p = ID3::FromHierarchy->new;

my $file;
my %tag;

# One path pattern.
$file = $dir->subdir( "favorite" );
%tag  = eval { $p->parse( $file->relative( $dir ) ) };
isnt( $@, q{} );

# Two pathes pattern.
$file = $dir->subdir( "favorite" )->subdir( "GARNET CROW" );
%tag = eval { $p->parse( $file->relative( $dir ) ) };
isnt( $@, q{} );

# Three pathes pattern.
my %wish = (
    genre  => "favorite",
    artist => "GARNET CROW",
    album  => undef,
    track  => undef,
    title  => "水のない晴れた海へ",
);

$file = $dir->subdir( "favorite" )
            ->subdir( "GARNET CROW" )
            ->file( "水のない晴れた海へ.mp3" );
%tag = eval { $p->parse( $file->relative( $dir ) ) };
is( $@, q{} );
is_deeply( \%tag, \%wish );

# Four pathes pattern.
%wish = (
    genre  => "favorite",
    artist => "GARNET CROW",
    album  => "first soundscope ～水のない晴れた海へ～",
    track  => "01",
    title  => "水のない晴れた海へ",
);

$file = $dir->subdir( "favorite" )
            ->subdir( "GARNET CROW" )
            ->subdir( "a01 - first soundscope ～水のない晴れた海へ～" )
            ->file( "01 - 水のない晴れた海へ.mp3" );
%tag = eval { $p->parse( $file->relative( $dir ) ) };
is( $@, q{} );
is_deeply( \%tag, \%wish );

# Five pathes pattern.
$file = $dir->subdir( "musics" )
            ->subdir( "favorite" )
            ->subdir( "GARNET CROW" )
            ->subdir( "a01 - first soundscope ～水のない晴れた海へ～" )
            ->file( "01 - 水のない晴れた海へ.mp3" );
%tag = eval { $p->parse( $file->relative( $dir ) ) };
isnt( $@, q{} );

