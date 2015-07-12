use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

package Mail::Mailgun::Rest;

# VERSION
# PODCLASSNAME
# ABSTRACT: .

use Hash::Merge;

resource Stats {

    purpose Get {

        request {

            get ':domain/stats';

            param domain => (
                isa => Str,
            );
            param limit => (
                isa => NonNegativeInt,
                default => 100,
                qs => 1,
            );
            has page => (
                is => 'ro',
                isa => NonNegativeInt,
                default => 1,
            );
            param skip => (
                isa => NonNegativeInt,
                lazy => 1,
                qs => 1,
                default => sub {
                    my $self = shift;
                    return ($self->page - 1) * $self->limit;
                },
            );
            param event => (
                qs => 1,
                isa => ArrayRef[Str],
                printable_method => sub {
                    return map { (event => $_) } shift->all_event;
                },
            );
            param start_date => (
                isa => TimeMoment,
                qs => 1,
                coerce => 1,
                printable_method => sub {
                    my $self = shift;
                    return ('start-date', $self->start_date->strftime('%Y-%m-%d')) if $self->has_start_date;
                },
                optional => 1,
            );
        }
        response {
            prop total_count => (
                isa => Int,
            );
            prop items => (
                isa => StatsGetItems,
            );

            class Item {
                has event => (
                    is => 'ro',
                    isa => Str,
                );
                has total_count => (
                    is => 'ro',
                    isa => Int,
                );
                has created_at => (
                    is => 'ro',
                    isa => TimeMoment,
                    coerce => 1,
                );
                has id => (
                    is => 'ro',
                    isa => Str,
                );
                has tags => (
                    is => 'ro',
                    isa => HashRef,
                    default => sub { { } },
                );
            }
        }
    }
}

1;
