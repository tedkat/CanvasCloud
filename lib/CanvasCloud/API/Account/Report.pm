package CanvasCloud::API::Account::Report;

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Account';

augment 'uri' => sub { return '/reports'; };

sub list {
    my $self = shift;
    return $self->send( $self->request( 'GET', $self->uri ) );
}

sub check {
    my ( $self, $report, $report_id ) = @_;
    return $self->send( $self->request( 'GET', join( '/', $self->uri, $report, $report_id ) ) );
}

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
