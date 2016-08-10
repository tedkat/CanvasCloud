package CanvasCloud::API::Account::SISImport;

# ABSTRACT: extends L<CanvasCloud::API::Account>

use Moose;
use namespace::autoclean;

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
    my $file = shift || die 'no file given!';
    die sprintf( 'file {%s} does not exist!', $file ) unless ( -f $file );
    my $m = '';
    open( my $ZF, '<', $file ) or die sprintf( 'cannot open input file {%s} error {%s}', $file, $! );
    binmode $ZF;
    while (<$ZF>) { $m .= $_; }
    close $ZF;
    my $r = $self->request( 'POST', $self->uri . '.json?import_type==instructure_csv&extension=zip' );
    $r->content_type( 'application/zip' );
    $r->content($m);
    return $self->send( $r );
}

=method zipstatus

get sendzip status as GET ->uri/$id.json

=cut

sub status {
    my $self = shift;
    my $id   = shift;
    return $self->send( $self->request( 'GET', $self->uri . '/' . $id . '.json' ) );
}

__PACKAGE__->meta->make_immutable;

1;
