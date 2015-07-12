use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

package Mail::Mailgun::Rest;

# VERSION
# PODCLASSNAME
# ABSTRACT: .

use Hash::Merge;

resource Event {

    purpose Get {

        request {

            get ':domain/events';

            param domain => (
                isa => Str,
            );
            param begin => (
                isa => TimestampRFC2822,
                coerce => 1,
                printable_asis => 1,
                qs => 1,
            );
            param end => (
                isa => TimestampRFC2822,
                coerce => 1,
                optional => 1,
                printable_asis => 1,
                qs => 1,
            );
            param ascending => (
                isa => Bool,
                default => 0,
                qs => 1,
                printable_method => sub {
                    return (ascending => shift->ascending ? 'yes' : 'no');
                },
            );
            param limit => (
                isa => NonNegativeInt->where(sub { $_ <= 300 }),
                default => 300,
                qs => 1,
            );

            param event => (
                isa => EventEnums,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (event => $_) } shift->all_event;
                },
            );
            param list => (
                isa => EmailAddresses,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (list => $_) } shift->all_list;
                },
            );
            param attachment => (
                isa => ArrayRefStr,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (attachment => $_) } shift->all_attachment;
                },
            );
            param from => (
                isa => EmailAddresses,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (from => $_) } shift->all_from;
                },
            );
            param message_id => (
                isa => ArrayRefStr,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (message_id => $_) } shift->all_message_id;
                },
            );
            param subject => (
                isa => ArrayRefStr,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (subject => $_) } shift->all_subject;
                },
            );
            param to => (
                isa => EmailAddresses,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (to => $_) } shift->all_to;
                },
            );
            param size => (
                isa => ArrayRefInt,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (size => $_) } shift->all_size;
                },
            );
            param recipient => (
                isa => EmailAddresses,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (recipient => $_) } shift->all_recipient;
                },
            );
            param tags => (
                isa => ArrayRefStr,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (tags => $_) } shift->all_tags;
                },
            );
            param severity => (
                isa => ArrayRefStr,
                coerce => 1,
                optional => 1,
                qs => 1,
                printable_method => sub {
                    return map { (severity => $_) } shift->all_severity;
                },
            );
        }
        response {

            prop items => (
                isa => EventItems,
                dpath => '/items',
            );
            prop next => (
                isa => Str,
                optional => 1,
                dpath => '/paging/next',
            );
            prop previous => (
                isa => Str,
                optional => 1,
                dpath => '/paging/previous',
            );

           # method BUILD {
           #     warn Dump 'IN BUILD';
           #     warn 'scalar items: ' . scalar @{ $self->repose_raw_response->{'items'}};
           # }
        }

    }

    role Common {
        has event => (
            is => 'ro',
            isa => EventEnum,
            required => 1,
        );
        has id => (
            is => 'ro',
            isa => Str,
        );
        
        has timestamp => (
            is => 'ro',
            isa => TimeMoment->plus_coercions(Str, sub { Time::Moment->from_epoch(split /\./ => $_) }),
            coerce => 1,
        );
        has campaigns => (
            is => 'ro',
            isa => ArrayRef[Str],
            default => sub { [] },
            traits => ['Array'],
            handles => {
                all_campaigns => 'elements',
                find_campaign => 'first',
                count_campaigns => 'count',
            },
        );
        has tags => (
            is => 'ro',
            isa => ArrayRef[Str],
            default => sub { [] },
            traits => ['Array'],
            handles => {
                all_tags => 'elements',
                find_tags => 'first',
                count_tags => 'count',
            },
        );
        has user_variables => (
            is => 'ro',
            isa => HashRef,
            traits => ['Hash'],
            default => sub { { } },
            handles => {
            },
        );
    }

    class Flags {
        has is_authenticated => (
            is => 'ro',
            isa => Bool,
            predicate => 1,
        );
        has is_test_mode => (
            is => 'ro',
            isa => Bool,
            predicate => 1,
        );
        has is_routed => (
            is => 'ro',
            isa => Bool,
            predicate => 1,
        );
        has is_system_test => (
            is => 'ro',
            isa => Bool,
            predicate => 1,
        );
        
        
    }

    class Envelope {
        has transport => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has sender => (
            is => 'ro',
            isa => EmailAddress,
            coerce => 1,
            predicate => 1,
        );
        has sending_ip => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has targets => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        
    }

    class Attachment {
        has content_type => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has filename => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has size => (
            is => 'ro',
            isa => NonNegativeInt,
            predicate => 1,
        );
    }

    class FullHeaders {
        has to => (
            is => 'ro',
            isa => Str,
        );
        has message_id => (
            is => 'ro',
            isa => Str,
        );
        has from => (
            is => 'ro',
            isa => EmailAddress,
            coerce => 1,
        );
        has subject => (
            is => 'ro',
            isa => Str,
        );
    }

    class FullMessage {
        has headers => (
            is => 'ro',
            isa => EventFullHeaders,
            coerce => 1,
        );
        has attachments => (
            is => 'ro',
            isa => EventAttachments,
            default => sub { [] },
            traits => ['Array'],
            coerce => 1,
            handles => {
                count_attachments => 'count',
                all_attachments => 'elements',
            },
        );
        has recipients => (
            is => 'ro',
            isa => ArrayRef[Str],
            default => sub { [] },
            traits => ['Array'],
        );
        has size => (
            is => 'ro',
            isa => NonNegativeInt,
            predicate => 1,
        );
    }
    class TinyHeaders {
        has message_id => (
            is => 'ro',
            isa => Str,
        );
    }
    class TinyMessage {
        has headers => (
            is => 'ro',
            isa => EventTinyHeaders,
            coerce => 1,
        );
    }

    class DeliveryStatus {
        has message => (
            is => 'ro',
            isa => Str,
        );
        has code => (
            is => 'ro',
            isa => Int,
        );
        has description => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has retry_seconds => (
            is => 'ro',
            isa => NonNegativeInt,
            predicate => 1,
        );
        has session_seconds => (
            is => 'ro',
            isa => NonNegativeInt,
            predicate => 1,
        );
        
    }

    class Geolocation {
        has country => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has region => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
        has city => (
            is => 'ro',
            isa => Str,
            predicate => 1,
        );
    }

    class ClientInfo {
        has client_type => (
            is => 'ro',
            isa => Str,
        );
        has client_os => (
            is => 'ro',
            isa => Str,
        );
        has device_type => (
            is => 'ro',
            isa => Str,
        );
        has client_name => (
            is => 'ro',
            isa => Str,
        );
        has user_agent => (
            is => 'ro',
            isa => Str,
        );
    }

    class Storage {
        has url => (
            is => 'ro',
            isa => Uri,
        );
        has key => (
            is => 'ro',
            isa => Str,
        );
    }
    class Type {
        class Accepted with Mail::Mailgun::Rest::Event::Common {
            has envelope => (
                is => 'ro',
                isa => EventEnvelope,
                coerce => 1,
            );
            has flags => (
                is => 'ro',
                isa => EventFlags,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventFullMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
            has recipient_domain => (
                is => 'ro',
                isa => Str,
                predicate => 1,
            );
            
            has method => (
                is => 'ro',
                isa => Str,
            );
        }

        class Delivered with Mail::Mailgun::Rest::Event::Common {
            has envelope => (
                is => 'ro',
                isa => EventEnvelope,
                coerce => 1,
            );
            has delivery_status => (
                is => 'ro',
                isa => EventDeliveryStatus,
            );
            has flags => (
                is => 'ro',
                isa => EventFlags,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventFullMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
        }

        class Failed with Mail::Mailgun::Rest::Event::Common {
            has envelope => (
                is => 'ro',
                isa => EventEnvelope,
                coerce => 1,
            );
            has delivery_status => (
                is => 'ro',
                isa => EventDeliveryStatus,
            );
            has flags => (
                is => 'ro',
                isa => EventFlags,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventFullMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
            has log_level => (
                is => 'ro',
                isa => Str,
                predicate => 1,
            );
            has severity => (
                is => 'ro',
                isa => Enum[qw/permanent temporary/],
            );
            has reason => (
                is => 'ro',
                isa => Str,
            );
        }

        class Opened with Mail::Mailgun::Rest::Event::Common {
            has geolocation => (
                is => 'ro',
                isa => EventGeolocation,
                coerce => 1,
                predicate => 1,
            );
            has ip => (
                is => 'ro',
                isa => Str,
            );
            has client_info => (
                is => 'ro',
                isa => EventClientInfo,
                coerce => 1,
                predicate => 1,
            );
            has message => (
                is => 'ro',
                isa => EventTinyMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
        }

        class Clicked with Mail::Mailgun::Rest::Event::Common {
            has geolocation => (
                is => 'ro',
                isa => EventGeolocation,
                coerce => 1,
            );
            has url => (
                is => 'ro',
                isa => Uri,
                coerce => 1,
            );
            has ip => (
                is => 'ro',
                isa => Str,
            );
            has client_info => (
                is => 'ro',
                isa => EventClientInfo,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventTinyMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
        }

        class Unsubscribed with Mail::Mailgun::Rest::Event::Common {
            has geolocation => (
                is => 'ro',
                isa => EventGeolocation,
                coerce => 1,
            );
            has ip => (
                is => 'ro',
                isa => Str,
            );
            has client_info => (
                is => 'ro',
                isa => EventClientInfo,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventTinyMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
        }

        class Complained with Mail::Mailgun::Rest::Event::Common {
            has flags => (
                is => 'ro',
                isa => EventFlags,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventFullMessage,
                coerce => 1,
            );
            has recipient => (
                is => 'ro',
                isa => EmailAddress,
                predicate => 1,
                coerce => 1,
            );
        }

        class Stored with Mail::Mailgun::Rest::Event::Common {
            has storage => (
                is => 'ro',
                isa => EventStorage,
                coerce => 1,
            );
            has flags => (
                is => 'ro',
                isa => EventFlags,
                coerce => 1,
            );
            has message => (
                is => 'ro',
                isa => EventFullMessage,
                coerce => 1,
            );
        }
    }
}

1;
