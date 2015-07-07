use Mail::Mailgun::Standard;
use strict;
use warnings;

# PODCLASSNAME

 role Mail::Mailgun::Role::Domain::CompleteDomainProperties {

    with 'Mail::Mailgun::Role::Domain::DomainProperties',
         'Rest::Repose::Mopes::ReposeAttributeTrait',
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

    method hashify_receiving_dns_records(--> DnsRecords but assumed) {
        return [ map { $_->to_hash } $self->all_receiving_dns_records ];
    }
    method hashify_sending_dns_records(--> DnsRecords but assumed) {
        return [ map { $_->to_hash } $self->all_sending_dns_records ];
    }
}

1;
