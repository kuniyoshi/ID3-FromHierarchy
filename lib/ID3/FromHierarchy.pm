package ID3::FromHierarchy;
use utf8;
use strict;
use warnings;
use Readonly;
use Carp qw( carp croak );
use File::Basename qw( basename );
use File::Spec::Functions qw( splitdir catfile );

Readonly our $VERSION     => "0.05";
Readonly my $IS_MP3_RE    => qr{ [.] mp3 }i;
Readonly my $TRACK_PARSER => qr{\A (\d{1,3}) (?:[ ][-][ ] | [ ]) (.*) }msx;

sub _make_genre_artist_title {
    my @paths = @_;
    my %tag = (
        title   => basename( $paths[2], $IS_MP3_RE ),
        track   => undef,
        artist  => $paths[1],
        album   => undef,
        genre   => $paths[0],
    );
    return %tag;
}

sub _make_genre_artist_album_title {
    my @paths = @_;
    my %tag = (
        title   => basename( $paths[3], $IS_MP3_RE ),
        track   => undef,
        artist  => $paths[1],
        album   => $paths[2],
        genre   => $paths[0],
    );
    return %tag;
}

sub _get_tag_from_paths {
    return &_make_genre_artist_title
        if @_ == 3;
    return &_make_genre_artist_album_title
        if @_ == 4;
    croak "Paths should be 3, or 4.";
}

sub _split_title_into_track_and_path {
    my %tag = @_;
    if ( $tag{title} =~ $TRACK_PARSER ) {
        @tag{ qw( track title ) } = ( $1, $2 );
    }
    return @tag{ qw( track title ) };
}

sub _split_album_into_number_and_name {
    my %tag = @_;
    if ( $tag{album} =~ $TRACK_PARSER ) {
        @tag{ qw( disk_number album ) } = ( $1, $2 );
    }
    return @tag{ qw( disk_number album ) };
}

sub get_tag_from_filename {
    my $filename = shift
        or croak "filename required.";

    my @paths = splitdir( $filename );
    croak "The depth of target is not neither 3 nor 4.  This requires relative path."
        if @paths != 3 && @paths != 4;
    my $has_album = @paths == 4;

    my %tag = _get_tag_from_paths( @paths );
    @tag{ qw( track title ) } = _split_title_into_track_and_path( %tag );

    @tag{ qw( disk_number album ) } = _split_album_into_number_and_name( %tag )
        if $has_album;

    return %tag;
}

1;

__END__
=head1 NAME

ID3::FromHierarchy - Parses ID3 tag from path hierarchy.

=head1 SYNOPSIS

  use ID3::FromHierarchy;
  my $file = "path/of/mp3filename";
  my %tag  = ID3::FromHierarchy::get_tag_from_filename( $file );

=head1 DESCRIPTION

Make tag data from filename.
Note that this module does not read the file to get ID3 tag.

=head1 FUNCTIONS

=over

=item get_tag_from_filename( $filename )

Returns ID3 tag daat from filename which can be:

  - <genre>/<artist>/<album_number> - <album_name>/<track> - <title>.mp3
  - <genre>/<artist>/<album_number> - <album_name>/<title>.mp3
  - <genre>/<artist>/<album>/<title>.mp3
  - <genre>/<artist>/<album>/<track> - <title>.mp3
  - <genre>/<artist>/<track> - <title>.mp3
  - <genre>/<artist>/<title>.mp3

=back

=head1 SEE ALSO

=over

=item MP3::Tag

=back

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
