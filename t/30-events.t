use strict;
use warnings;

use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Mail::Mailgun;
use Mail::Mailgun::Types -types;
use Mail::Mailgun::Rest::Event;
use Data::Dump::Streamer;
use Time::Moment;
use List::MoreUtils qw/uniq/;

$ENV{'MAILGUN_CONFIG_DIR'} = 't/corpus/01';

my $mailgun = Mail::Mailgun->new;

subtest events => sub {
    my $events = $mailgun->events_get(
                                    domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
                                    begin => Time::Moment->from_string('20150712T000000Z'),
                                    end => Time::Moment->from_string('20150712T240000Z'),
                                    ascending => 1,

    );

  #  diag Dump $events->repose_raw_response;
    is $events->repose_response->status, 200, 'Correct http status';
    is $events->count_items, 32, 'Correct item count';
    is $events->get_items(0)->event, 'accepted', 'Correct event type';
    is $events->get_items(0)->message->count_attachments, 2, 'Correct no of attachments';

#    diag Dump $events->repose_raw_response;
#    my $event = EventTypeAccepted->coerce($events->repose_raw_response->{'items'}[2]);
#    is $event->event, 'accepted', 'Yes';
#    diag $events->next;
#
#    my $wha = EventItems->coerce($events->repose_raw_response->{'items'});
#    is $wha->[0]->event, 'accepted', '!!!!';
#
#    my $boh = Mail::Mailgun::Rest::Event::Get::Response->new(#%{ $events->repose_raw_response },
#                                                             repose_raw_response => $events->repose_raw_response,
#                                                             repose_request => $events->repose_request,
#                                                             repose_response => $events->repose_response,
#                                                            );
#    diag ref $boh;
#    diag $boh;
#    is $boh->count_items, 4, '???????';
};

done_testing;
