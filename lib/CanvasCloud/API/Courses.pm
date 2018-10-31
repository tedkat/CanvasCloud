package CanvasCloud::API::Courses;

# ABSTRACT: extends L<CanvasCloud::API>

use Moose;
use namespace::autoclean;

extends 'CanvasCloud::API';

=attr course_id

I<required:> set to the user id for Canvas call

=cut

has course_id => ( is => 'ro', required => 1 );

=attr uri

augments base uri to append '/courses/course_id'

=cut

augment 'uri' => sub {
    my $self = shift;
    my $rest = inner() || '';
    $rest = '/' if ( defined $rest && $rest && $rest !~ /^\// );
    return sprintf( '/courses/%s', $self->course_id ) . $rest;
};

sub get {
    my $self = shift;
    my $hash = shift || {};
    my $url = $self->uri;
    my ( $include );
    if ( exists $hash->{include} ) {
        my @accept = qw/needs_grading_count syllabus_body public_description total_scores current_grading_period_scores term account course_progress sections storage_quota_used_mb total_students passback_status favorites teachers observed_users all_courses permissions course_image/;
        for my $x ( @accept ) {
            if ( $hash->{include} eq $x ) {
                $include = $x;
                last;
            }
        }
    }
    $url .= '?include[]='.$include if ( $include );
    return $self->send( $self->request( 'GET',  $url ) );
}

__PACKAGE__->meta->make_immutable;

1;
