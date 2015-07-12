use strict;
use warnings;

use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Mail::Mailgun;
use Data::Dump::Streamer;

$ENV{'MAILGUN_CONFIG_DIR'} = 't/corpus/01';

my $mailgun = Mail::Mailgun->new(from => 'test@example.com');

subtest domain_list => sub {
    my $domain_list = $mailgun->domain_list;

    is $domain_list->repose_response->status, 200, 'Correct http status';
    is $domain_list->total_count, 2, 'Correct number of domains';
    is $domain_list->get_items(0)->created_at->hour, 17, 'Correct created_at for first domain in list';
    is $domain_list->get_items(0)->name, 'mgtest.code301.com', 'Correct name on checked domain';
    is $domain_list->repose_raw_response->{'items'}[0]{'smtp_login'}, 'postmaster@mgtest.code301.com', 'Correct to_hash smtp_login';
};

#subtest domain_delete => sub {
#    my $domain = 'test.sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org';
#    my $domain_delete = $mailgun->domain_delete(name => $domain);
#
#    is $domain_delete->repose_request->url, "https://api:key-ce158c6cd03e8e05f9d14866efc4077e\@api.mailgun.net/v2/domains/$domain", 'Correct call url';
#    is $domain_delete->repose_response->status, 200, 'Correct http status';
#    #is $domain_delete->deleted, 1, 'Domain deleted';
#};
#subtest domain_add => sub {
#    my $domain_add = $mailgun->domain_add(name => 'test.sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org', smtp_password => 'woo');
#
#    diag Dump($domain_add->repose_request->_printable);
#
#    is $domain_add->repose_response->status, 200, 'Correct http status';
#    is $domain_add->repose_response->reason, 'OK', 'Correct response reason';
#    is $domain_add->ok, 1, 'All good';
#    is $domain_add->message, '<unknown>', 'Correct message';
#};


#subtest domain_info => sub {
#    my $domain_info = $mailgun->domain_info(domain => 'samples.mailgun.org');
#
#    is $domain_info->response->status, 200, 'Correct http status';
#    is $domain_info->ok, 1, 'All good';
#    is $domain_info->name, 'samples.mailgun.org', 'Expected domain name';
#};
#
#subtest domain_add => sub {
#    my $domain_add = $mailgun->domain_add(name => 'mailgun.example.com', smtp_password => 'woo');
#
#    diag Dump($domain_add->call->to_hash);
#
#    is $domain_add->response->status, 200, 'Correct http status';
#    is $domain_add->response->reason, 'OK', 'Correct response reason';
#    is $domain_add->ok, 1, 'All good';
#    is $domain_add->message, '<unknown>', 'Correct message';
#};
#
##subtest domain_delete => sub {
##    my $domain_delete = $mailgun->domain_delete(name => 'ktwakes.mailgun.org');
##
##    is $domain_delete->call->url, '...', 'Correct call url';
##    is $domain_delete->response->status, 200, 'Correct http status';
##    is $domain_delete->deleted, 1, 'Domain deleted';
##};
#


done_testing;
