package CanvasCloud::API::Account::Users;

# ABSTRACT: extends L<CanvasCloud::API::Account>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Account';

=attr uri

augments base uri to append '/users'

=cut

augment 'uri' => sub { return '/users'; };

=method list

return data object response from GET ->uri

=cut

sub list {
    my $self = shift;
    return $self->send( $self->request( 'GET', $self->uri ) );
}

sub search {
    my $self = shift;
    my $search = shift || '';
    return $self->send( $self->request( 'GET', $self->uri . '?search_term=' . $search ) );
}

__PACKAGE__->meta->make_immutable;

1;
