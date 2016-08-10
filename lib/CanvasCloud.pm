package CanvasCloud;

# ABSTRACT: Perl access for Canvas LMS API

use Moose;
use namespace::autoclean;
use Module::Load;

my %LOADER = (
                 'CanvasCloud::API::Account::Report'    => { small => 'reports',    short => 'Account::Report',    wanted => [qw/domain token account_id/] },
                 'CanvasCloud::API::Account::Term'      => { small => 'terms',      short => 'Account::Term',      wanted => [qw/domain token account_id/] },
                 'CanvasCloud::API::Account::SISImport' => { small => 'sisimports', short => 'Account::SISImport', wanted => [qw/domain token account_id/] },
             );

=attr config

I<required:> HashRef of key value pairs to be accessed when ->api is called

=cut
             
has config => ( is => 'rw', isa => 'HashRef', required => 1 );

=method api( 'api type' )

Factory method that creates Canvas::API object based on 'api type' passed.

  'reports'    or 'Account::Report'    CanvasCloud::API::Account::Report
  'terms'      or 'Account::Term'      CanvasCloud::API::Account::Term
  'sisimports' or 'Account::SISImport' CanvasCloud::API::Account::SISImport

=cut

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

=head1 SEE ALSO

L<CanvasCloud::API>
