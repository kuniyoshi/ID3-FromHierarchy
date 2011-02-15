use utf8;
use Modern::Perl;
use File::Spec::Functions qw( catfile );
use ID3::FromHierarchy::GenreArtistTitle;

use Test::More tests => 84;
use Test::Data qw( Hash );

my @keys = qw( title track artist album comment year genre );

my $p = ID3::FromHierarchy::GenreArtistTitle->new;

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
my %wish = (
    title  => "水のない晴れた海へ",
    artist => "GARNET CROW",
    genre  => "favorite",
);

$file = catfile(
    "favorite",
    "GARNET CROW",
    "水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
check_keys( \%tag );
check_values( \%tag, %wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "水のない晴れた海へ.MP3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
check_keys( \%tag );
check_values( \%tag, %wish );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
check_keys( \%tag );
check_values( \%tag, %wish, track => "01" );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01-水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
check_keys( \%tag );
check_values( \%tag, %wish, track => "01" );

$file = catfile(
    "favorite",
    "GARNET CROW",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
is( $@, "" );
check_keys( \%tag );
check_values( \%tag, %wish, track => "01" );


# Four pathes pattern.
$file = catfile(
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
    "01 - 水のない晴れた海へ.mp3",
);
%tag = eval { $p->parse( $file ) };
isnt( $@, "" );


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


sub check_values {
    my $tag_ref = shift;
    my %hash    = ( ( map { $_ => undef } @keys ), @_ );

    foreach my $key ( @keys ) {
        is( $tag_ref->{ $key }, $hash{ $key } );
    }

    return;
}

sub check_keys {
    my $tag_ref = shift;

    foreach my $key ( @keys ) {
        exists_ok( $key, %{ $tag_ref } );
    }

    is( keys %{ $tag_ref }, @keys );

    return;
}

