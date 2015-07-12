use Mail::Mailgun::Standard;
use strict;
use warnings;

# PODCLASSNAME

 role Mail::Mailgun::Role::Domain::DomainProperties
 with Rest::Repose::Role::Printable {

    # VERSION:
    # ABSTRACT: Role for basic domain properties

    has created_at => (
        is => 'ro',
        isa => TimeMoment,
        traits => [qw/Repose/],
        printable_method => 1,
        predicate => 1,
        coerce => 1,
    );
#    prop created_at => (
#        isa => TimeMoment,
#        coerce => 1,
#    );
    has smtp_login => (
        is => 'ro',
        isa => EmailAddress,
        traits => [qw/Repose/],
        printable_asis => 1,
        predicate => 1,
    );
    has name => (
        is => 'ro',
        isa => Str,
        traits => [qw/Repose/],
        printable_asis => 1,
        predicate => 1,
    );
    has smtp_password => (
        is => 'ro',
        isa => Str,
        traits => [qw/Repose/],
        printable_asis => 1,
        predicate => 1,
    );
    has wildcard => (
        is => 'ro',
        isa => Bool,
        traits => [qw/Repose/],
        printable_method => 1,
        predicate => 1,
    );
    has spam_action => (
        is => 'ro',
        isa => Enum[qw/disabled tag/],
        traits => [qw/Repose/],
        printable_asis => 1,
        predicate => 1,
    );
    # Should probably be enum, but incomplete list of possible values.
    has state => (
        is => 'ro',
        isa => Str,
        traits => [qw/Repose/],
        printable_asis => 1,
        predicate => 1,
    );
    has require_tls => (
        is => 'ro',
        isa => Bool,
        default => 0,
    );
    has type => (
        is => 'ro',
        isa => Str,
    );
    has skip_verification => (
        is => 'ro',
        isa => Bool,
    );
    
    
    

    method created_at_printable(--> TimestampRFC2822 but assumed) {
        return TimestampRFC2822->coerce($self->created_at);
    }

    method wildcard_printable(--> Str but assumed) {
        return $self->wildcard.'';
    }

}

1;