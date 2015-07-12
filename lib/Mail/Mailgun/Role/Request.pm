use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

# PODCLASSNAME

role Mail::Mailgun::Role::Request {

    # VERSION
    # ABSTRACT: .

    has mailgun => (
        is => 'ro',
        isa => InstanceOf['Mail::Mailgun'],
        required => 1,
    );
    has domain => (
        is => 'ro',
        isa => Str,
        default => 'www.example.com',
    );

    around make_request {

        my $response = $self->$next;
        $response->mailgun($self->mailgun);
        return $response;
    }
}

1;
