use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

# PODCLASSNAME

class Mail::Mailgun::Rest::Message::SendOptions {

    # VERSION:
    # ABSTRACT

    with 'Rest::Repose::Role::Printable';

    has tags => (
        is => 'ro',
        isa => ArrayRefMaxThreeStr128,
        traits => [qw/Array Repose/],
        coerce => 1,
        default => sub { [] },
        printable_asis => 0,
        printable_method => 1,
        real_name => 'o:tags',
        predicate => 1,
        handles => {
            get_tag => 'get',
            count_tags => 'count',
            all_tags => 'elements',
        },
    );

    #method tags_printable {
    #    return (adsf => 'asdf');
    #}

#    has campaign => (
#        is => 'ro',
#        isa => Str,
#        predicate => 1,
#        mailgun_hashable_string => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );
#    has dkim => (
#        is => 'ro',
#        isa => Bool,
#        predicate => 1,
#        mailgun_hashable_method => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );
#    has deliverytime => (
#        is => 'ro',
#        isa => TimeMoment,
#        default => sub { Time::Moment->now },
#        coerce => 1,
#        predicate => 1,
#        mailgun_hashable_method => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );
#    has testmode => (
#        is => 'ro',
#        isa => Bool,
#        predicate => 1,
#        mailgun_hashable_method => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );
#    has tracking => (
#        is => 'ro',
#        isa => Bool,
#        predicate => 1,
#        mailgun_hashable_method => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );
#    has tracking_clicks => (
#        is => 'ro',
#        isa => Enum[qw/0 1 htmlonly/],
#        predicate => 1,
#        mailgun_hashable_method => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );
#    has tracking_opens => (
#        is => 'ro',
#        isa => Bool,
#        predicate => 1,
#        mailgun_hashable_method => 1,
#        mailgun_hashable_with_prefix => 'o',
#    );

    # Since this is placed on the same level as the ::Call stuff,
    # we make the array ref into a list
    around _printable {
        return @{ $self->$next };
    }

#    method hashify_deliverytime(--> TimestampRFC2822 but assumed) {
#        return TimestampRFC2822->coerce($self->deliverytime);
#    }
#    method hashify_testmode(--> Str but assumed) {
#        return $self->testmode ? 'yes' : 'no';
#    }
#    method hashify_dkim(--> Str but assumed) {
#        return $self->dkim ? 'yes' : 'no';
#    }
#    method hashify_tracking(--> Str but assumed) {
#        return $self->tracking ? 'yes' : 'no';
#    }
#    method hashify_tracking_clicks(--> Str but assumed) {
#        return $self->tracking_clicks ? 'yes' : 'no';
#    }
#    method hashify_tracking_opens(--> Str but assumed) {
#        return $self->tracking_opens ? 'yes' : 'no';
#    }
    method tags_printable {
        return () if !$self->count_tags;
        return map { ('o:tag' => $_) } $self->all_tags;
    }

};

1;
