use strict;
use warnings;

use Test::More;
use if $ENV{'AUTHOR_TESTING'}, 'Test::Warnings';

use Mail::Mailgun;
use Data::Dump::Streamer;

$ENV{'MAILGUN_CONFIG_DIR'} = 't/corpus/01';

my $mailgun = Mail::Mailgun->new(from => 'test@example.com');

subtest domain_connection_get => sub {
    my $domain_connection_get = $mailgun->domain_connection_get(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org');

    is $domain_connection_get->repose_response->status, 200, 'Correct http status';
    is $domain_connection_get->require_tls, 0, 'Correct tls requirement';
    is $domain_connection_get->skip_verification, 0, 'Correct skip verification';
};


subtest domain_connection_update => sub {
    my $domain_connection_update = $mailgun->domain_connection_update(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
                                                                      require_tls => 1,
                                                                      skip_verification => 1);

    is $domain_connection_update->repose_response->status, 200, 'Correct http status';
    is $domain_connection_update->require_tls, 1, 'Correct tls requirement';
    is $domain_connection_update->skip_verification, 1, 'Correct skip verification';

    $domain_connection_update = $mailgun->domain_connection_update(domain => 'sandbox1bb3c1305a0743a88eae78e1687a1f84.mailgun.org',
                                                                   require_tls => 0,
                                                                   skip_verification => 0);

    is $domain_connection_update->require_tls, 0, 'Require tls restored';

};

done_testing;
