package CanvasCloud;
use Moose;
use namespace::autoclean;

use Module::Load;

my %LOADER = (
                 'CanvasCloud::API::Account::Report' => { small => 'reports', short => 'Account::Report', wanted => [qw/domain token account_id/] },
                 'CanvasCloud::API::Account::Term'   => { small => 'terms',   short => 'Account::Term',   wanted => [qw/domain token account_id/] },
             );

has config => ( is => 'rw', isa => 'HashRef', required => 1 );


## Factory method
sub api {
    my $self = shift;
    my $type = shift;
    
    for my $k ( keys %LOADER ) {
        if ( $type eq $LOADER{$k}{small} || $type eq $LOADER{$k}{short} ) {
            $type = $k;
            last;
        }
    }
    if ( $type =~ /^CanvasCloud::API::\w+/ && exists $LOADER{$type} ) {
        load $type;
        my %wanted;
        for my $arg ( @{ $LOADER{$type}{wanted} } ) {
            $wanted{$arg} = $self->config->{$arg} if ( exists $self->config->{$arg} && defined $self->config->{$arg} );
        }
        return $type->new( %wanted );
    }
    die 'Unable to create CanvasCloud->api(', $type, ") -- $type not found!\n";
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

CanvasCloud - Factory Class for access parts of the Canvas LMS api

=head1 SYNOPSIS

  use CanvasCloud;

  my $canvas = CanavasCloud->new( config => { domain => 'yourdomain.instructure.com', token => 'stringSoupGoesHere', account_id => 'A } );
  
  ## To list Terms
  
  my $terms = $canvas->api( 'terms' )->list;
  
  ## or

  my $terms = $canvas->api( 'Account::Term' )->list;
  
  ## or but why
  
  my $terms = $canvas->api( 'CanvasCloud::API::Account::Term' )->list;
  
  print to_json( $terms );  ## show contents of what was returned!!!
  

=head1 DESCRIPTION

This module provides a factory method for accessing various API modules.

=head2 new( config => {} )

Create a new instance of CanvasCloud with configuation data needed when calling CanvasCloud->api

=head3 config => HashRef

Required argument: key value list of needed information

=over 6

=item domain

Domain for your Canvas LMS site.

=item token

your Oauth2 string token 

=item account_id

Account ID: used in query

=back

=head1 SEE ALSO

L<CanvasCloud::API>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Theodore Katseres.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Terms of the Perl programming language system itself

a) the GNU General Public License as published by the Free
   Software Foundation; either version 1, or (at your option) any
   later version, or
b) the "Artistic License"


This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
