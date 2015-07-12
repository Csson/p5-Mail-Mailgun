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
        documentation_default => 'hello',
        traits => ['Repose'],
        printable_asis => 1,
    );
    has record_type => (
        is => 'ro',
        isa => Enum[qw/MX CNAME TXT/],
        traits => ['Repose'],
        printable_asis => 1,
    );
    has valid => (
        is => 'ro',
        isa => Enum[qw/valid invalid unknown/],
        traits => ['Repose'],
        printable_asis => 1,
    );
    has value => (
        is => 'ro',
        isa => Str,
        traits => ['Repose'],
        printable_asis => 1,
    );
    has name => (
        is => 'ro',
        isa => Str,
        traits => ['Repose'],
        printable_asis => 1,
    );
    
    method isvalid(--> Bool but assumed) {
        return $self->valid eq 'valid' ? 1 : 0;
    }
}

1;
