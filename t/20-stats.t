use strict;
use warnings;

use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Mail::Mailgun;
use Data::Dump::Streamer;
use Time::Moment;

$ENV{'MAILGUN_CONFIG_DIR'} = 't/corpus/01';

my $mailgun = Mail::Mailgun->new;

subtest stats_get => sub {
    my $stats_get = $mailgun->stats_get(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
    									start_date => Time::Moment->now->minus_days(7),
    								#	event => [qw/open sent/],
    								  );

    is $stats_get->repose_response->status, 200, 'Correct http status';
    is $stats_get->count_items, 0, 'Correct item count';

    diag Dump $stats_get->repose_request->_printable;
    diag Dump $stats_get->repose_raw_response;
    diag $stats_get->repose_request->_repose_url;

};

done_testing;
