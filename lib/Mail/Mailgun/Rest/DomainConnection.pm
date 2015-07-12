use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

package Mail::Mailgun::Rest;

# VERSION
# PODCLASSNAME
# ABSTRACT: .

resource DomainConnection {

    purpose Get {

        request {
            get 'domains/:domain/connection';

            param domain => (
                isa => Str,
            );
        }
        response {

            prop require_tls => (
                isa => Bool,
                dpath => '/connection/require_tls',
            );

            prop skip_verification => (
                isa => Bool,
                dpath => '/connection/skip_verification',
            );
        }
    }

    purpose Update {

        request {
            put 'domains/:domain/connection';

            param domain => (
                isa => Str,
            );
            param require_tls => (
                isa => Bool,
            );
            param skip_verification => (
                isa => Bool,
            );
        }
        response {

            prop message => (
                isa => Str,
            );
            prop require_tls => (
                isa => Bool,
            );
            prop skip_verification => (
                isa => Bool,
            );
        }
    }
}

1;
