use utf8;
use Modern::Perl;
use File::Spec::Functions qw( catfile );
use ID3::FromHierarchy;

use Test::Data qw( Hash );
use Test::More tests => 35;

my @keys = qw( title track artist album comment year genre );

my $p = ID3::FromHierarchy->new;

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
    track  => "01",
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
check_values( \%tag, %wish, track => undef );


# Four pathes pattern.
%wish = (
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
check_keys( \%tag );
check_values( \%tag, %wish );


# Five pathes pattern.
$file = catfile(
    "musics",
    "favorite",
    "GARNET CROW",
    "a01 - first soundscope ～水のない晴れた海へ～",
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
}

