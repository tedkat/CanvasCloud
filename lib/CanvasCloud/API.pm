package CanvasCloud::API;

# ABSTRACT: Base Class for talking Canvas LMS API

use Moose;
use namespace::autoclean;
use LWP::UserAgent;
use Hash::Merge qw/merge/;
use URI;
use JSON;

has debug  => ( is => 'ro', lazy => 1, default => 0 );
has scheme => ( is => 'ro', lazy => 1, default => 'https' );
has domain => ( is => 'ro', required => 1 );
has token  => ( is => 'ro', required => 1 );


has ua => ( is => 'ro', lazy => 1, default => sub { LWP::UserAgent->new; } );

=method uri

Base uri for Canvas LMS

=cut

sub uri {
    my $self = shift;
    my $rest = inner() || '';
    $rest = '/' if ( defined $rest && $rest && $rest !~ /^\// );
    return sprintf('%s://%s/api/v1', $self->scheme, $self->domain) . $rest;
}

=method request( $method, $uri )

returns HTTP::Request;

request creates a HTTP::Request->new( $method => $uri ) it then sets the 'Authorization' header

=cut

sub request {
    my ( $self, $method, $uri ) = @_;
    my $r = HTTP::Request->new( $method => $uri );
    $r->header( 'Authorization' => 'Bearer '.$self->token );
    return $r;
}

=method send( $request )

Attempts to send request to Canvas recursively depending on return Link header.
Finally returns a hashref data structure as response from Canvas.

=cut

sub send {
    my ( $self, $request ) = @_;
    $request->header( 'Content-Type' => 'application/x-www-form-urlencoded' ) if ( $request->method eq 'POST' && $request->content_type eq '' );
    warn join("\n", 'REQUEST:--->',$request->as_string, 'REQUEST:<----'), "\n" if ( $self->debug );
    my $resp = $self->ua->request( $request );
    warn join("\n", 'RESPONSE:--->',$resp->as_string, 'RESPONSE:<----'), "\n" if ( $self->debug );
    my $struct;
    if ( $resp->is_success ) {
        $struct = $self->decode( $resp->content );
        if ( my $link = $resp->header( 'Link' ) ) {
            my $LINK = _parse_link($link);
            if ( $LINK->{'current'} ne $LINK->{'last'} ) {
              $request->uri( $LINK->{'next'} );
              $struct = merge( $struct, $self->send( $request ) );
            }
        }
    }
    return $struct;
}

=method decode( 'jsonstring' );

returns results from from_json on jsonstring

=cut

sub decode { from_json $_[1]; }

sub _parse_link {
    my $link = shift;
    $link =~ s/\R//g;
    my %struct =  map { $_ => '' } qw/current next prev first last/;
    for my $l ( split( /,/, $link ) ) {
        my ($url, $type) = split( /;/, $l );
        my $TYPE = 0;
        for my $t ( keys %struct ) {
            if ( $type =~ m/rel="$t"/ ) {
                $url =~ s/^<//;
                $url =~ s/>$//;
                $struct{$t} = $url;
                $TYPE = $t;
                last;
            }
        }
        die 'Bad Link: none of listed relation found - '.join(', ', keys %struct) unless ( $TYPE );
    }
    return \%struct;
}

## Taken from HTTP::Request::Common

=method encode_url( $content )

encode structure to url

=cut

sub encode_url {
   my ( $self, $content ) = @_;
   my $url = URI->new('http:');
   $url->query_form( ref($content) eq 'HASH' ? %$content : @$content );
   $content = $url->query;
   $content =~ s/(?<!%0D)%0A/%0D%0A/g if defined($content); ## html 4.01 line breaks CR LF
   return $content;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 DESCRIPTION

Base class to be inherited by CanvasCloud API modules.

=attr domain

I<required:> Domain for your Canvas LMS site.

=attr token

I<required:> Your Oauth2 string token

=attr debug

I<optional:> 1  or 0  : 0 is default

=attr scheme

I<optional:> http or https : https is default

=attr ua

LWP::UserAgent
