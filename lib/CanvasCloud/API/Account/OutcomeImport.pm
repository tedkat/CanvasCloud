package CanvasCloud::API::Account::OutcomeImport;

# ABSTRACT: extends L<CanvasCloud::API::Account>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Account';

=attr uri

augments base uri to append '/outcome_imports'

=cut

augment 'uri' => sub { return '/outcome_imports'; };

=method sendcsv( $csvfile )

return data object response from POST ->uri / $csvfile

=cut

sub sendcsv {
    my ( $self, $file_or_string ) = @_;
    my $text;
    if ( -f $file_or_string ) {
        open( my $ZF, '<', $file_or_string ) or die sprintf( 'cannot open input file {%s} error {%s}', $file_or_string, $! );
        binmode $ZF;
        while (<$ZF>) { $text .= $_; }
        close $ZF;
    }
    else {
        $text = $file_or_string;
    }
    my $r = $self->request( 'POST', $self->uri . '?import_type=instructure_csv&extension=csv' );
    $r->content_type( 'text/csv' );
    $r->content("$text");
    return $self->send( $r );
}

=method csvstatus

get sendfile status as GET ->uri/$id.json

=cut

sub status {
    my $self = shift;
    my $id   = shift || die 'id must be given!';
    return $self->send( $self->request( 'GET', $self->uri . '/' . $id  ) );
}

__PACKAGE__->meta->make_immutable;

1;
