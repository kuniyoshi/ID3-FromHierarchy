package ID3::FromHierarchy;

use 5.10.0;
use utf8;
use Modern::Perl;
use Carp qw( carp croak );
use base "Class::Accessor";
use File::Spec::Functions qw( splitdir catfile );
use ID3::FromHierarchy::GenreArtistTitle;
use ID3::FromHierarchy::GenreArtistAlbumTitle;

our $VERSION = '0.03';

sub parse {
    my $self   = shift;
    my $target = shift
        or croak "Target required.";

    my @pathes = splitdir( $target );

    my $parser;

    given ( scalar @pathes ) {
        when ( 3 ) {
            $parser = ID3::FromHierarchy::GenreArtistTitle->new;
        }
        when ( 4 ) {
            $parser = ID3::FromHierarchy::GenreArtistAlbumTitle->new;
        }
        default {
            croak "The depth of target is not neither 3 nor 4.";
        }
    }

    return $parser->parse( $target );
}

1;
__END__
=head1 NAME

ID3::FromHierarchy - Parses ID3 tag from file path.

=head1 SYNOPSIS

  use ID3::FromHierarchy;
  my $parser = ID3::FromHierarchy->new;
  my $file   = "splited/by/directory";
  my %tag    = eval { $parser->parse( $file ) };
  die $@
      if $@;
  print map { "$_: $tag{$_}\n" } keys %tag;

=head1 DESCRIPTION

Parses ID3 tag from directory hierarchy, and returns ID3 tag.
Parse patterns are exist in sub namespace of this.
See ID3::FromHierarchy::**.

=head1 METHODS

=over

=item parse( $filename )

Parse ID3 tag from filename. If can't, croak.
The order of parse is:

  - <genre>/<artist>/<disc_class><disc_number> - <disc_name>/<track> - <title>.mp3
  - <genre>/<artist>/<album>/<title>.mp3
  - <genre>/<artist>/<title>.mp3

=back

=head1 SEE ALSO

=over

=item MP3::Tag

=item ID3::FromHierarchy::GenreArtistTitle

=item ID3::FromHierarchy::GenreArtistAlbumTitle

=back

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

