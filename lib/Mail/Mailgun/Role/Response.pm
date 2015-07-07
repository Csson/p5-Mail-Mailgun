use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

# PODCLASSNAME

role Mail::Mailgun::Role::Response {

    # VERSION
    # ABSTRACT: .

    has mailgun => (
        is => 'rw',
        isa => InstanceOf['Mail::Mailgun'],
    );
   
}

1;
