use strict;
use warnings;

use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Mail::Mailgun;
use Data::Dump::Streamer;

$ENV{'MAILGUN_CONFIG_DIR'} = 't/corpus/01';

my $mailgun = Mail::Mailgun->new(from => 'test@example.com');

subtest domain_credential_list => sub {
    my $domain_credential_list = $mailgun->domain_credential_list;

    is $domain_credential_list->repose_response->status, 200, 'Correct http status';
    is $domain_credential_list->total_count, 1, 'Correct number of domain credentials';
    is $domain_credential_list->get_items(0)->created_at->hour, 13, 'Correct created_at for first domain in list';
    is $domain_credential_list->get_items(0)->mailbox, 'postmaster@sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org', 'Correct mailbox on checked domain';
    is $domain_credential_list->repose_raw_response->{'items'}[0]{'login'}, 'postmaster@sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org', 'Correct to_hash smtp_login';
};

subtest domain_credential_add_update => sub {
    my $credential_add = $mailgun->domain_credential_add(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
                                                         login => 'test1@sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
                                                         password => '123pass456');

    is $credential_add->message, 'Created 1 credentials pair(s)', 'Correct add message';

    my $credential_update = $mailgun->domain_credential_update(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
                                                               login_name => 'test1',
                                                               password => 'newpass');

    is $credential_update->message, 'Password changed', 'Correct update message';
};

subtest domain_credential_delete => sub {
    my $credential_delete = $mailgun->domain_credential_delete(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org', login_name => 'test1');

    is $credential_delete->ok, 1, 'Is ok';
    is $credential_delete->message, 'Credentials have been deleted', 'Correct delete message';
    is $credential_delete->spec, 'test1@sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org', 'Correct deleted login';
};

done_testing;
