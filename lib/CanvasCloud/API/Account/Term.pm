package CanvasCloud::API::Account::Term;

# ABSTRACT: extends L<CanvasCloud::API::Account>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Account';

=attr uri

augments base uri to append '/reports'

=cut

augment 'uri' => sub { return '/terms'; };

=method list

return data object response from GET ->uri

=cut

sub list {
    my $self = shift;
    return $self->send( $self->request( 'GET', $self->uri ) );
}

__PACKAGE__->meta->make_immutable;

1;
