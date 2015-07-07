use 5.14.0;
use strict;
use warnings;


package #
    Mail::Mailgun::Standard {

    # VERSION:

    use base 'Rest::Repose';
    use List::AllUtils();
    use MooseX::AttributeDocumented();
    use Path::Tiny();
    use Types::Standard();
    use Types::Path::Tiny();
    use Types::Email();
    use Types::URI();
    use Mail::Mailgun::Types();
    use Rest::Repose::Mopes::ApplyReposeAttributeTrait();
    use Time::Moment();
    use PerlX::Maybe();
    use Data::Dump::Streamer();

    sub import {
        my $class = shift;
        my %opts = @_;

        push @{ $opts{'imports'} ||= [] } => (
            'List::AllUtils'    => [qw/any none sum uniq/],
            'MooseX::AttributeDocumented' => [],
            'Path::Tiny' => ['path'],
            'Rest::Repose::Mopes::ApplyReposeAttributeTrait' => [],
            'Mail::Mailgun::Types' => [{ replace => 1 }, '-types'],
            'Types::Standard' => [{ replace => 1 }, '-types'],
            'Types::Path::Tiny' => [{ replace => 1 }, '-types'],
            'Types::URI' => [{ replace => 1}, '-types'],
            'Types::Email' => [{ replace => 1 }, '-types'],
            'Time::Moment' => [],
            'PerlX::Maybe' => [qw/maybe provided/],
            'Data::Dump::Streamer' => ['Dump'],
        );

        push @{ $opts{'traits'} ||= [] } => (
            'Mail::Mailgun::Mopes::RequestResponseKeywords',
        );

        $class->SUPER::import(%opts);
    }
}

1;
