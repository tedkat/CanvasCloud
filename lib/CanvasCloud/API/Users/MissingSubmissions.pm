package CanvasCloud::API::Users::MissingSubmissions;

# ABSTRACT: extends L<CanvasCloud::API::Users>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API::Users';

=attr uri

augments base uri to append '/missing_submissions'

=cut

augment 'uri' => sub { return '/missing_submissions'; };

=method list

return data object response from GET ->uri

=cut

sub list {
    my $self = shift;
    my $hash = shift || {};
    my $url = $self->uri;
    my ( $filter, $include );
    if ( exists $hash->{include} ) {
        $include = 'course' if ( $hash->{include} eq 'course' );
        $include = 'planner_overrides' if ( $hash->{include} eq 'planner_overrides' );
    }
    if ( exists $hash->{filter} ) {
        $filter = 'submittable' if ( $hash->{filter} eq 'submittable' );
    }
    if ( $filter || $include ) {
        $url .= '?' . ( $filter ? 'filter[]='.$filter : '' ) . ( $include ? 'include[]='.$include : '' );
    }
    
    return $self->send( $self->request( 'GET',  $url ) );
}

__PACKAGE__->meta->make_immutable;

1;
