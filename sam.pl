#!/usr/bin/perl

use 5.10.0;
use utf8;
use open ":utf8";
use open ":std";
use Modern::Perl;
use lib "lib";
use ID3::FromHierarchy;
use File::Spec::Functions qw( catfile );

my $parser = ID3::FromHierarchy->new(
    root => [ $ENV{HOME}, "Musics" ],
);

my @files = (
    catfile( qw( favorite angela Spirial ), "01 - Spirial.mp3" ),
);

foreach my $file ( @files ) {
    my %tag = eval { $parser->parse( $file ) };

    if ( my $e = $@ ) {
        warn "!!! Could not parse a file[$file].[$e]\n";
        next;
    }

    say "#" x 80;
    say "Parsed.";
    print map { "$_: $tag{$_}\n" } keys %tag;
}

