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

    purpose List {

        request {

            get 'domains';

            param limit => (
                isa => PositiveInt,
                default => 100,
            );
            param skip => (
                isa => NonNegativeInt,
                default => 0,
            );
        }
        response {

            prop total_count => (
                isa => NonNegativeInt,
            );

            prop items => (
                isa => DomainListItems,
            );
        }

        class Item with Mail::Mailgun::Role::Domain::DomainProperties { }
    }

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
                isa => Maybe[Enum[qw/tag enabled/]],
                optional => 1,
                printable_asis => 1,
            );
            param wildcard => (
                isa => Bool,
                default => 0,
                printable_asis => 1,
            );
        }
#        response {
#            prop created_at => (
#                isa => TimeMoment,
#                coerce => 1,
#            );
#            prop smtp_login => (
#                isa => EmailAddress,
#                predicate => 1,
#            );
#            prop name => (
#                isa => Str,
#            );
#            prop smtp_password => (
#                isa => Str,
#            );
#            prop wildcard => (
#                isa => Bool,
#            );
#            prop spam_action => (
#                isa => Enum[qw/disabled tag/],
#            );
#            # Should probably be enum, but incomplete list of possible values.
#            prop state => (
#                isa => Str,
#            );
#            prop require_tls => (
#                isa => Bool,
#                default => 0,
#            );
#            prop type => (
#                isa => Str,
#            );
#            prop skip_verification => (
#                isa => Bool,
#            );
#            propgroup receiving_dns_records => (
#                isa => ReceivingDnsRecord,
#                dpaths => {
#                    priority => '/'
#                },
#            );
#        }
        response {
            with 'Mail::Mailgun::Role::Domain::DomainProperties';

            prop receiving_dns_records => (
                isa => DnsRecords,
            );
            prop sending_dns_records => (
                isa => DnsRecords,
            );
        }
    }

    purpose Delete {

        request {

            http_delete 'domains/:name';

            param name => (
                isa => Str,
                printable_asis => 1,
            );

        }

        response {}
    }
}

1;
