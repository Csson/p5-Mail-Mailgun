use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

package Mail::Mailgun::Rest;

# VERSION
# PODCLASSNAME
# ABSTRACT: .

use Hash::Merge;

resource Domain {

    purpose Add {

        request {

            post 'domains';

            param name => (
                isa => Str,
                printable_asis => 1,
            );
            param smtp_password => (
                isa => Str,
                printable_asis => 1,
            );
            param spam_action => (
                isa => Enum[qw/tag enabled/],
                optional => 1,
                printable_asis => 1,
            );
            param wildcard => (
                isa => Bool,
                optional => 1,
                printable_asis => 1,
            );

            modify_response {
                my $self = shift;
                my $args = shift;
                return Hash::Merge::merge($args, delete $args->{'domain'});
            };

        }
        response {
            with 'Mail::Mailgun::Role::Domain::CompleteDomainProperties';
        }
    }
}

1;
