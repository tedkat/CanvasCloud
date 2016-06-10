package CanvasCloud::API::Account;

# ABSTRACT: extends L<CanvasCloud::API>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API';

=attr account_id

I<required:> set to the account id for Canvas call

=cut

has account_id => ( is => 'ro', required => 1 );

=attr uri

augments base uri to append '/accounts/account_id'

=cut

augment 'uri' => sub {
    my $self = shift;
    my $rest = inner() || '';
    $rest = '/' if ( defined $rest && $rest && $rest !~ /^\// );
    return sprintf( '/accounts/%s', $self->account_id ) . $rest;
};

__PACKAGE__->meta->make_immutable;

1;
