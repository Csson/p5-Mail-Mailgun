use Mail::Mailgun::Standard;
use strict;
use warnings;

# PODCLASSNAME

 role Mail::Mailgun::Role::Domain::CompleteDomainProperties with Mail::Mailgun::Role::Domain::DomainProperties {

    with 'Rest::Repose::Mopes::ReposeAttributeTrait',
         'Rest::Repose::Role::Printable';

    # VERSION:
    # ABSTRACT: All domain properties
    has receiving_dns_records => (
        is => 'ro',
        isa => DnsRecords,
        traits => [qw/Array Repose/],
        default => sub { [] },
        coerce => 1,
        printable_method => 1,
        predicate => 1,
        handles => {
            all_receiving_dns_records => 'elements',
        }
    );
    has sending_dns_records => (
        is => 'ro',
        isa => DnsRecords,
        traits => [qw/Array Repose/],
        default => sub { [] },
        coerce => 1,
        printable_method => 1,
        predicate => 1,
        handles => {
            all_sending_dns_records => 'elements',
        }
    );

    method receiving_dns_records_printable(--> DnsRecords but assumed) {
        return [ map { $_->_printable } $self->all_receiving_dns_records ];
    }
    method sending_dns_records_printable(--> DnsRecords but assumed) {
        return [ map { $_->_printable } $self->all_sending_dns_records ];
    }
}

1;
