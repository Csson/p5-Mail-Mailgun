use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

# PODCLASSNAME

role Mail::Mailgun::Role::Response {

    # VERSION
    # ABSTRACT: .

    use List::UtilsBy 'extract_by';

    has mailgun => (
        is => 'rw',
        isa => InstanceOf['Mail::Mailgun'],
    );
    has retry_seconds => (
        is => 'ro',
        isa => Int,
        predicate => 1,
    );
    has ok => (
        is => 'ro',
        isa => Bool,
        lazy => 1,
        default => sub {
            my $self = shift;
            return $self->repose_response->status == 200 && !$self->has_retry_seconds ? 1 : 0;
        },
    );

}

1;
