package ID3::FromHierarchy;

use 5.010000;
use utf8;
use Modern::Perl;
use Carp qw( carp croak );
use File::Spec::Functions qw( splitdir catfile );
use ID3::FromHierarchy::GenreArtistTitle;
use ID3::FromHierarchy::GenreArtistAlbumTitle;

use Mouse;

has gat => (
    is      => "rw",
    isa     => "Object",
    default => sub { ID3::FromHierarchy::GenreArtistTitle->new },
);

has gaat => (
    is      => "rw",
    isa     => "Object",
    default => sub { ID3::FromHierarchy::GenreArtistAlbumTitle->new },
);

no Mouse;

our $VERSION = '0.02';


sub parse {
    my $self   = shift;
    my $target = shift;
    croak "Target required."
        unless $target;

    my @pathes = splitdir( $target );
    croak "Could not parse. Its depth is too shallow."
        unless @pathes > 2;
    croak "Could not parse: Its depth is too deep."
        unless @pathes < 5;

    my $parser;

    given ( scalar @pathes ) {
        when ( 3 ) {
            $parser = $self->gat;
        }
        when ( 4 ) {
            $parser = $self->gaat;
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

=head1 ATTRIBUTES

A instance has no attribute.

=head1 METHODS

=over

=item parse( $filename )

Parse ID3 tag from filename. Id can't, croak.
The order of parse is:

  - <genre>/<artist>/<disc_class><disc_number> - <disc_name>/<track> - <title>.mp3
  - <genre>/<artist>/<album>/<title>.mp3
  - <genre>/<artist>/<title>.mp3

=back

=head1 SEE ALSO

MP3::Tag
ID3::FromHierarchy::GenreArtistTitle
ID3::FromHierarchy::GenreArtistAlbumTitle

=head1 AUTHOR

Kuniyoshi Kouji, E<lt>kuniyoshi@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Kuniyoshi Kouji

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

