package CanvasCloud::API::Users;

# ABSTRACT: extends L<CanvasCloud::API>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API';

=attr user_id

I<required:> set to the user id for Canvas call

=cut

has user_id => ( is => 'ro', required => 1 );

=attr uri

augments base uri to append '/users/user_id'

=cut

augment 'uri' => sub {
    my $self = shift;
    my $rest = inner() || '';
    $rest = '/' if ( defined $rest && $rest && $rest !~ /^\// );
    return sprintf( '/users/%s', $self->user_id ) . $rest;
};

__PACKAGE__->meta->make_immutable;

1;
