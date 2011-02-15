#!/usr/bin/perl

use utf8;
use open ":utf8";
use open ":std";
use Modern::Perl;
use lib "lib";
use ID3::FromHierarchy;

my $parser = ID3::FromHierarchy->new;

my @files = (
    "/home/prigel/musics/+musics/+KAORI/lasting.mp3",
);
__END__
foreach my $file ( @files ) {
    my %tag = eval { $parser->parse( $file ) };
    if ( $@ ) {
        warn "Could not parse a file[$file]\n";
        next;
    }

    say "#" x 80;
    say "Parsed.";
    print map { "$_: $tag{$_}\n" } keys %tag;
}
