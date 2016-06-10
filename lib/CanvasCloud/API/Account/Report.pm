package CanvasCloud::API::Account::Report;

# ABSTRACT: extends L<CanvasCloud::API::Account>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Account';

=attr uri

augments base uri to append '/reports'

=cut

augment 'uri' => sub { return '/reports'; };

=method list

return data object response from GET ->uri

=cut

sub list {
    my $self = shift;
    return $self->send( $self->request( 'GET', $self->uri ) );
}

=method check( $report, $report_id )

return data object response from GET ->uri / $report / $report_id 

=cut

sub check {
    my ( $self, $report, $report_id ) = @_;
    return $self->send( $self->request( 'GET', join( '/', $self->uri, $report, $report_id ) ) );
}

=method run( $report, { term_id => 1 } )

return data object response from POST ->uri / $report

arguments are POST'ed

=cut

sub run {
    my ( $self, $report, $args ) = @_;

    my $r  = $self->request( 'POST', join( '/', $self->uri, $report ) );

    ## Process Args
    if ( defined $args && ref( $args ) eq 'HASH' ) {
        my $struct = {};

        if ( exists $args->{term_id} && defined $args->{term_id} ) {
            my $term_id = $args->{term_id} + 0;
            die 'Illegal Term '.$term_id if ( $term_id < 0 );
            $struct->{'parameters[enrollment_term_id]'} = $term_id;
        }

        $r->content( $self->encode_url( $struct ) );
    }

    return $self->send( $r );
}


__PACKAGE__->meta->make_immutable;

1;
