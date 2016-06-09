package CanvasCloud::API::Account::Term;

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Account';

augment 'uri' => sub { return '/terms'; };

sub list {
    my $self = shift;
    return $self->send( $self->request( 'GET', $self->uri ) );
}

__PACKAGE__->meta->make_immutable;

1;
