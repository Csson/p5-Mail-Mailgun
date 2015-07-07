use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

# PODCLASSNAME

class Mail::Mailgun::Core::DnsRecord
 with Rest::Repose::Role::Printable {

 #   with 'Rest::Repose::Mopes::ReposeAttributeTrait';

    # VERSION:
    # ABSTRACT: A dns record

    has priority => (
        is => 'ro',
        isa => NonNegativeInt,
        required => 1,
        documentation_default => 'hello',
        printable_asis => 1,
    );
    has record_type => (
        is => 'ro',
        isa => Enum[qw/MX CNAME TEXT/],
        required => 1,
        printable_asis => 1,
    );
    has valid => (
        is => 'ro',
        isa => Bool->plus_coercions(Str, sub { $_ eq 'valid' ? 1 : 0 }),
        required => 1,
        printable_asis => 1,
    );
    has value => (
        is => 'ro',
        isa => Str,
        required => 1,
        printable_asis => 1,
    );
}

1;
