use Rest::Repose::Standard;
use strict;
use warnings;

# PODCLASSNAME

package Domain;

class List using Moose :ro {

    # VERSION:
    # ABSTRACT: Create api for the Mailgun/Domain api

    has repose_meta => (
        repose_call_consumes => ['Mail::Mailgun::Role::Call::List'],
        repose_http_method => 'get',
        repose_endpoint_url => [qw/ domains /],
    );

    has total_count => (
        isa => NonNegativeInt,
        repose_response_arg => 1,
        repose_required => 1,
    );
    has items => (
        isa => ReposeArrayRef,
        repose_response_arg => 1,
        repose_required => 1,
        repose_list_of => DomainListItem,
    );

}

class Domain::List::Item
using Moose {

    has repose_meta => (
        repose_consumes => ['::Role::Domain::DomainProperties']
    );

}

1;

__END__

package Repose;

resource Domain {

    purpose Add {

        request {

            post 'domains';

            param name => (
                isa => Str,
            );
            param smtp_password => (
                isa => Str,
            );
            param spam_action => (
                isa => Enum[qw/tag enabled/],
                optional => 1,
            );
            param wildcard => (
                isa => Bool,
                optional => 1,
            );
        }
        response {

            with ['::Role::Domain::CompleteDomainProperties'];

            modifier {
                my $response = shift;
                require Hash::Merge;
                return Hash::Merge::merge($response->{'args'}, delete $response->{'args'}{'domain'});
            }
        }
    }

    purpose List {

        request {

            get 'domains';

            with ['::Role::Call::List'];
        }

        response {

            param total_count => (
                isa => NonNegativeInt,
            );
            param items => (
                isa => ArrayRef[DomainListItem],
            );
        }
    }
}

resource Unsubscribe {

    purpose Check {

        request {

            get ':domain/unsubscribes/:address';

            param address => (
                isa => EmailAddress,
           );
        }

        response {

            with ['::Role::Unsubscribe::ItemProperties'];

        }
    }
}

1;
