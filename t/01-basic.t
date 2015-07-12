use strict;
use warnings;

use Test::More;
use Data::Dump::Streamer;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

BEGIN {
	use_ok 'Mail::Mailgun';
}

$ENV{'MAILGUN_CONFIG_DIR'} = 't/corpus/01';

my $mailer = Mail::Mailgun->new(from => 'test@example.com');

isa_ok $mailer, 'Mail::Mailgun';

is $mailer->key, 'key-ce158c6cd03e8e05f9d14866efc4077e', 'Correct key';
is $mailer->domain, 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org', 'Correct domain';

subtest send_ok_mail => sub {
    my $sent_message = $mailer->message_send(to => ['ex@example.com', 'exa@example.com'],
                                             subject => 'An email',
                                             text => 'the contents',
                                             from => 'test@example.com',
                                             attachments => ['t/corpus/01/attach_1.txt', 't/corpus/01/attach_2.txt'],
                                             inlines => 't/corpus/01/attach_1.txt',
                                             options => {
                                                 tags => 'first-tag',
                                                 testmode => 1,
                                                 deliverytime => Time::Moment->now->plus_hours(3),
                                             },
                                             headers => {
                                                 'Reply-To' => 'another@example.com',
                                             },
                                             variables => {
                                                 a_test_var => { is_this => 'crazy' },
                                             },
                                        );

    is $sent_message->repose_request->get_to(0), 'ex@example.com', 'Got correct first to';
    is $sent_message->repose_request->options->get_tag(0), 'first-tag', 'Got correct first tag';
#
    is $sent_message->repose_response->headers->{'access-control-allow-headers'}, 'Content-Type, x-requested-with', 'Got expected access-control-allow-headers header';
    is $sent_message->repose_response->status, 200, 'Got expected status';
    is $sent_message->repose_response->reason, 'OK', 'Got expected reason';
    is $sent_message->repose_response->success, 1, 'Successful, as expected';
    is (($sent_message->message)[0], 'Queued. Thank you.', 'Got expected message');

    diag Dump($sent_message->repose_request->_printable);
    diag Dump($sent_message->repose_response);

};

done_testing;
