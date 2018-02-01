package CanvasCloud::API::Account::SISImport;

# ABSTRACT: extends L<CanvasCloud::API::Account>

use Moose;
use namespace::autoclean;
use IO::String;

extends 'CanvasCloud::API::Account';

=attr uri

augments base uri to append '/sis_imports''

=cut

augment 'uri' => sub { return '/sis_imports'; };

=method sendzip

send zip data as POST ->uri

=cut

sub sendzip {
    my $self = shift;
    my $file_or_hash = shift || die 'no data given!';
    my $compressed;
    if ( -f $file_or_hash ) {
        open( my $ZF, '<', $file_or_hash ) or die sprintf( 'cannot open input file {%s} error {%s}', $file_or_hash, $! );
        binmode $ZF;
        while (<$ZF>) { $compressed .= $_; }
        close $ZF;
    }
    elsif ( ref($file_or_hash) eq 'HASH' ) {
        my $sh = IO::String->new($compressed);
        $file_or_hash->{zip}->writeToFileHandle($sh);
    }
    else {
        die sprintf( 'file {%s}{%%%s} does not exist or is not Archive::Zip object', $file_or_hash, ref($file_or_hash) );
    }
    my $r = $self->request( 'POST', $self->uri . '.json?import_type=instructure_csv&extension=zip' );
    $r->content_type( 'application/zip' );
    $r->content($compressed);
    return $self->send( $r );
}

=method zipstatus

get sendzip status as GET ->uri/$id.json

=cut

sub status {
    my $self = shift;
    my $id   = shift || die 'id must be given!';
    return $self->send( $self->request( 'GET', $self->uri . '/' . $id . '.json' ) );
}

__PACKAGE__->meta->make_immutable;

1;
