use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

package Mail::Mailgun::Rest;

# VERSION
# PODCLASSNAME
# ABSTRACT: .

resource DomainCredential {

    purpose List {

        request {
            get 'domains/:domain/credentials';

            param domain => (
                isa => Str,
            );
        }
        response {

            prop total_count => (
                isa => NonNegativeInt,
            );

            prop items => (
                isa => DomainCredentialListItems,
            );
        }

        class Item {

            has size_bytes => (
                is => 'ro',
                isa => NonNegativeInt->plus_coercions(Undef, sub { 0 }),
                coerce => 1,
                required => 1,
            );
            has created_at => (
                is => 'ro',
                isa => TimeMoment,
                coerce => 1,
                required => 1,
            );
            has mailbox => (
                is => 'ro',
                isa => EmailAddress,
                coerce => 1,
                required => 1,
            );
            has login => (
                is => 'ro',
                isa => EmailAddress,
                coerce => 1,
                required => 1,
            );
        }
    }

    purpose Add {

        request {

            post 'domains/:domain/credentials';

            param domain => (
                isa => Str,
            );
            param login => (
                isa => Str,
            );
            param password => (
                isa => Str,
            );
        }
        response {     
            prop message => (
                isa => Str,
            );
        }
    }

    purpose Update {

        request {

            put '/domains/:domain/credentials/:login_name';

            param domain => (
                isa => Str,
            );
            param login_name => (
                isa => Str,
            );
            param password => (
                isa => Str,
            );
        }
        response {
            prop message => (
                isa => Str,
            );
        }
    }

    purpose Delete {

        request {

            http_delete 'domains/:domain/credentials/:login_name';

            param domain => (
                isa => Str,
            );
            param login_name => (
                isa => Str,
            );
        }
        response {
            prop spec => (
                isa => Maybe[Str],
            );
            prop message => (
                isa => Str,
            );
        }
    }
}

1;
