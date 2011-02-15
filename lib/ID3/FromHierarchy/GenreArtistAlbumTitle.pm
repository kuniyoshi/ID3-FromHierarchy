package ID3::FromHierarchy::GenreArtistAlbumTitle;

use 5.010000;
use utf8;
use Modern::Perl;
use Carp qw( carp croak );

use Mouse;

has tag => (
    is  => "rw",
    isa => "HashRef",
);

no Mouse;

use File::Basename qw( basename );
use File::Spec::Functions qw( splitdir );

our $VERSION = '0.02';

my @SUFFIXES = qw( .mp3 .MP3 );


sub parse {
    my $self   = shift;
    my $target = shift;
    croak "Target required."
        unless $target;

    my @pathes = splitdir( $target );
    croak "Could not parse. Its depth is too shallow."
        unless @pathes > 3;
    croak "Could not parse: Its depth is too deep."
        unless @pathes < 5;

    my %tag = (
        title   => basename( $pathes[3], @SUFFIXES ),
        track   => undef,
        artist  => $pathes[1],
        album   => $pathes[2],
        comment => undef,
        year    => undef,
        genre   => $pathes[0],
    );

    # Velify title, and set track.
    given ( $tag{title} ) {
        when ( m{\A (\d{2}) [ ] [-] [ ] (.*) \z}msx ) {
            $tag{track} = $1;
            $tag{title} = $2;
        }
        when ( m{\A (\d{2}) [-] (.*) \z}msx ) {
            $tag{track} = $1;
            $tag{title} = $2;
        }
        when ( m{\A (\d{2}) [ ] (.*) \z}msx ) {
            $tag{track} = $1;
            $tag{title} = $2;
        }
    }

    # Trim disc number from album.
    if ( $tag{album} =~ m{\A ([sab]? \d{2} [ ] [-] [ ]) (.*) \z}msx ) {
        $tag{album} = $2;
    }
    elsif ( $tag{album} =~ m{\A ([sab]? \d{2} [ ]) (.*) \z}msx ) {
        $tag{album} = $2;
    }

    $self->tag( \%tag );

    return %{ $self->tag };
}


1;
__END__
=head1 NAME

ID3::FromHierarchy::GenreArtistAlbumTitle - Perl extension for ID3::FromHierarchy

=head1 SYNOPSIS

  use ID3::FromHierarchy::GenreArtistAlbumTitle;
  use File::Spec;
  my $file = File::Spec->catfile( "genre", "artist", "title" );
  my %tag  = eval {
      ID3::FromHierarchy::GenreArtistAlbumTitle->new->parse( $file )
  };
  die $@
      if ( $@ );
  print map { "$_: $tag{$_}\n" } keys %tag;

=head1 DESCRIPTION

In this module expects the file system has hierarchy like
genre - artist - album - music file.
According to this expection, parses ID3 tag, and returns tag.

=head1 ATTRIBUTES

=over

=item tag

The tag has same key with autoinfo method of MP3::Tag.

=back

=head1 METHODS

=over

=item parse( $filename )

Gets filename, and returns ID3 tag.

=back

=head1 SEE ALSO

ID3::FromHierarchy
ID3::FromHierarchy::GenreArtistTitle

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

