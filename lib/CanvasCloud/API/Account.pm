package CanvasCloud::API::Account;

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API';

has account_id => ( is => 'ro', required => 1 );

augment 'uri' => sub {
    my $self = shift; 
    my $rest = inner() || '';
    $rest = '/' if ( defined $rest && $rest && $rest !~ /^\// );
    return sprintf( '/accounts/%s', $self->account_id ) . $rest;
};

__PACKAGE__->meta->make_immutable;

1;
