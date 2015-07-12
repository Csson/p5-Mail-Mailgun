use Moops;
use strict;
use warnings;

# PODCLASSNAME
# VERSION
# ABSTRACT

library Mail::Mailgun::Types

declares
    MailGun,
    StrMax128,
    NonNegativeInt,
    PositiveInt,
    TimeMoment,
    TimestampRFC2822,
    ArrayRefMaxThreeStr128,
    ArrayRefStr,
    ArrayRefInt,
    Files,
    Uris,
    ActualHttpResponse,
    HttpResponse,

    DnsRecord,
    DnsRecords,

    MessageSendRequest,
    MessageSendResponse,
    MessageSendOptions,

    DomainListRequest,
    DomainListResponse,
    DomainListItem,
    DomainListItems,

    DomainDeleteRequest,
    DomainDeleteResponse,

    DomainCredentialListRequest,
    DomainCredentialListResponse,
    DomainCredentialListItem,
    DomainCredentialListItems,

    DomainCredentialAddRequest,
    DomainCredentialAddResponse,
    DomainCredentialUpdateRequest,
    DomainCredentialUpdateResponse,
    DomainCredentialDeleteRequest,
    DomainCredentialDeleteResponse,
    
    DomainConnectionGetRequest,
    DomainConnectionGetResponse,    
    DomainConnectionUpdateRequest,
    DomainConnectionUpdateResponse,

    DomainAddRequest,
    DomainAddResponse,

    StatsGetRequest,
    StatsGetResponse,
    StatsGetItem,
    StatsGetItems,

    EventEnum,
    EventEnums,
    EventItem,
    EventItems,
    EventGetRequest,
    EventGetResponse,
    EventFlags,
    EventEnvelope,
    EventAttachment,
    EventAttachments,
    EventFullHeaders,
    EventFullMessage,
    EventTinyHeaders,
    EventTinyMessage,
    EventDeliveryStatus,
    EventGeolocation,
    EventClientInfo,
    EventStorage,

    EventTypeAccepted,
    EventTypeDelivered,
    EventTypeFailed,
    EventTypeOpened,
    EventTypeClicked,
    EventTypeUnsubscribed,
    EventTypeComplained,
    EventTypeStored

{

    use Path::Tiny;
    use Types::Path::Tiny qw/File/;
    use Types::URI qw/Uri/;
    use Data::Dump::Streamer;

    declare EventEnum, as Enum[qw/accepted rejected delivered failed opened clicked unsubscribed compained stored/];

    class_type MailGun   => { class => 'Mail::Mailgun' };
    class_type TimeMoment => { class => 'Time::Moment' };

    my $class_types = [
        'Rest::Message::Send::Request' => {
            type => MessageSendRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::Message::Send::Response' => {
            type => MessageSendResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::Message::SendOptions' => {
            type => MessageSendOptions,
            coerce_from => ['HashRef'],
        },

        'Rest::Domain::Add::Request' => {
            type => DomainAddRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::Domain::Add::Response' => {
            type => DomainAddResponse,
            coerce_from => ['HashRef'],
        },

        'Rest::Domain::Delete::Request' => {
            type => DomainDeleteRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::Domain::Delete::Response' => {
            type => DomainDeleteResponse,
            coerce_from => ['HashRef'],
        },

        'Rest::Domain::List::Request' => {
            type => DomainListRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::Domain::List::Response' => {
            type => DomainListResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::Domain::List::Item' => {
            type => DomainListItem,
        },


        'Rest::DomainCredential::List::Request' => {
            type => DomainCredentialListRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::List::Response' => {
            type => DomainCredentialListResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::List::Item' => {
            type => DomainCredentialListItem,
        },
        'Rest::DomainCredential::Add::Request' => {
            type => DomainCredentialAddRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::Add::Response' => {
            type => DomainCredentialAddResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::Update::Request' => {
            type => DomainCredentialUpdateRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::Update::Response' => {
            type => DomainCredentialUpdateResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::Delete::Request' => {
            type => DomainCredentialDeleteRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainCredential::Delete::Response' => {
            type => DomainCredentialDeleteResponse,
            coerce_from => ['HashRef'],
        },

        'Rest::DomainConnection::Get::Request' => {
            type => DomainConnectionGetRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainConnection::Get::Response' => {
            type => DomainConnectionGetResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainConnection::Update::Request' => {
            type => DomainConnectionUpdateRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::DomainConnection::Update::Response' => {
            type => DomainConnectionUpdateResponse,
            coerce_from => ['HashRef'],
        },

        'Rest::Stats::Get::Request' => {
            type => StatsGetRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::Stats::Get::Response' => {
            type => StatsGetResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::Stats::Get::Item' => {
            type => StatsGetItem,
        },

# ([A-Z][a-z]+)([A-Z][a-z]+)([A-Z][a-z]+)
# 'Rest::$1::$2::$3' => {\n\t\t\ttype => $1$2$3,\n\t\t\tcoerce_from => ['HashRef'],\t\t},
        'Rest::Event::Get::Request' => {
            type => EventGetRequest,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Get::Response' => {
            type => EventGetResponse,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Flags' => {
            type => EventFlags,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Attachment' => {
            type => EventAttachment,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Envelope' => {
            type => EventEnvelope,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::FullHeaders' => {
            type => EventFullHeaders,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::FullMessage' => {
            type => EventFullMessage,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::TinyHeaders' => {
            type => EventTinyHeaders,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::TinyMessage' => {
            type => EventTinyMessage,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::DeliveryStatus' => {
            type => EventDeliveryStatus,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Geolocation' => {
            type => EventGeolocation,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::ClientInfo' => {
            type => EventClientInfo,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Storage' => {
            type => EventStorage,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Accepted' => {
            type => EventTypeAccepted,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Delivered' => {
            type => EventTypeDelivered,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Failed' => {
            type => EventTypeFailed,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Opened' => {
            type => EventTypeOpened,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Clicked' => {
            type => EventTypeClicked,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Unsubscribed' => {
            type => EventTypeUnsubscribed,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Complained' => {
            type => EventTypeComplained,
            coerce_from => ['HashRef'],
        },
        'Rest::Event::Type::Stored' => {
            type => EventTypeStored,
            coerce_from => ['HashRef'],
        },


        'Core::DnsRecord' => {
            type => DnsRecord,
            coerce_from => [qw/HashRef/],
        },
    ];

=pod
    my $class_types = [
        'Core::HttpResponse' => {
            type => HttpResponse,
            coerce_from => [qw/HashRef/],
        },

        'Action::Message::Send' => {
            type => MessageSend,
            coerce_from => [qw/HashRef/],
        },
        'Action::Message::Send::Call' => {
            type => MessageSendCall,
            coerce_from => [qw/HashRef/],
        },
        'Action::Message::Send::Call::Options' => {
            type => MessageSendCallOptions,
            coerce_from => [qw/HashRef/],
        },

        'Action::Message::Retrieve' => {
            type => MessageRetrieve,
            coerce_from => [qw/HashRef/],
        },
        'Action::Message::Retrieve::Call' => {
            type => MessageRetrieveCall,
            coerce_from => [qw/HashRef/],
        },

        'Action::Message::Delete' => {
            type => MessageDelete,
            coerce_from => [qw/HashRef/],
        },
        'Action::Message::Delete::Call' => {
            type => MessageDeleteCall,
            coerce_from => [qw/HashRef/],
        },
        'Action::Domain::List' => {
            type => DomainList,
            coerce_from => [qw/HashRef/],
        },
        'Action::Domain::List::Call' => {
            type => DomainListCall,
            coerce_from => [qw/HashRef/],
        },
        'Action::Domain::List::Item' => {
            type => DomainListItem,
        },

        'Action::Domain::Info' =>  {
            type => DomainInfo,
            coerce_from => [qw/HashRef/],
        },
        'Action::Domain::Info::Call' => {
            type => DomainInfoCall,
            coerce_from => [qw/HashRef/],
        },

        'Action::Domain::Add' => {
            type => DomainAdd,
            coerce_from => ['HashRef'],
            coerce_from_method => 'make_call',
        },
        'Action::Domain::Add::Call' => {
            type => DomainAddCall,
            coerce_from => ['HashRef'],
        },




        'Action::Unsubscribe::List' => {
            type => UnsubscribeList,
            coerce_from => ['HashRef'],
        },
        'Action::Unsubscribe::List::Item' => {
            type => UnsubscribeListItem,
            coerce_from => ['HashRef'],
        },
        'Action::Unsubscribe::List::Call' => {
            type => UnsubscribeListCall,
            coerce_from => ['HashRef'],
        },

        'Action::Unsubscribe::Check' => {
            type => UnsubscribeCheck,
            coerce_from => ['HashRef'],
        },
        'Action::Unsubscribe::Check::Call' => {
            type => UnsubscribeCheckCall,
            coerce_from => ['HashRef'],
        },

        'Action::Unsubscribe::Delete' => {
            type => UnsubscribeDelete,
            coerce_from => ['HashRef'],
        },
        'Action::Unsubscribe::Delete::Call' => {
            type => UnsubscribeDeleteCall,
            coerce_from => ['HashRef'],
        },
    ];
=cut
    for (my $i = 0; $i < scalar @$class_types; $i += 2) {

        my $partclass = $class_types->[$i];
        my $def = $class_types->[$i + 1];
        my $fullclass = 'Mail::Mailgun::' . $partclass;
        my $type = $def->{'type'};
        my $coercions = $def->{'coerce_from'} // [];
        my $coerce_from_method = $def->{'coerce_from_method'} // 'new';

        class_type $type => { class => $fullclass };

        foreach my $coercion (@$coercions) {
            coerce_from_hashref($type, $fullclass, $coerce_from_method) if $coercion eq 'HashRef';
        }
    }
    my $item_declarations = [
        'Domain::List::Item' => {
            as => ArrayRef[DomainListItem],
            one => DomainListItem,
            many => DomainListItems,
        },
        'DomainCredential::List::Item' => {
            as => ArrayRef[DomainCredentialListItem],
            one => DomainCredentialListItem,
            many => DomainCredentialListItems,
        },
        'Stats::Get::Item' => {
            as => ArrayRef[StatsGetItem],
            one => StatsGetItem,
            many => StatsGetItems,
        },
        'Event::Attachment' => {
            as => ArrayRef[EventAttachment],
            one => EventAttachment,
            many => EventAttachments,
        },
        'Event::Type::Accepted' => {
            as => ArrayRef[EventTypeAccepted],
            one => EventTypeAccepted,
            many => EventItems,
        },
#        'Action::Unsubscribe::List::Item' => {
#            as => ArrayRef[UnsubscribeListItem],
#            one => UnsubscribeListItem,
#            many => UnsubscribeListItems,
#        },
    ];

    for (my $i = 0; $i < scalar @$item_declarations; $i += 2) {
        my $partclass = $item_declarations->[$i];
        my $def = $item_declarations->[$i + 1];
        my $fullclass = 'Mail::Mailgun::Rest::' . $partclass;

        my $as = $def->{'as'};
        my $one = $def->{'one'};
        my $many = $def->{'many'};

        declare $many,
        as $as,
        message { sprintf "Those are not $one objects" };

        coerce $many,
        from ArrayRef[HashRef],
        via { [ map { $fullclass->new($_) } @$_ ] };

        coerce $one,
        from ArrayRef,
        via { [ $fullclass->new(@$_) ] };
    }


    declare EventEnums,
    as ArrayRef[EventEnum],
    message { 'Those are not EventEnum strings' };

    coerce EventEnums,
    from Str,
    via { [$_] };

        'Rest::Event::Item' => {
            type => EventItem,
            coerce_from => ['HashRef'],
        },

#    declare EventItem,
#    as ArrayRef[EventTypeAccepted];
#    #as ConsumerOf['Mail::Mailgun::Rest::Event::Common'];
#
#    declare EventItems,
#    #as ArrayRef[ConsumerOf['Mail::Mailgun::Rest::Event::Common']],
#    as ArrayRef[EventItem],
#    message { 'Those are not EventItem objects' };
#
#    coerce EventItems,
#    from ArrayRef[HashRef],
#    via { [
#        map {
#            my $fullclass = 'Mail::Mailgun::Rest::Event::Type::Accepted' . uc $_->{'event'};
#            warn 'create event: ' . $fullclass;
#            $fullclass->new($_)
#        } @$_ ]
#    };



    declare DnsRecords,
    as ArrayRef[DnsRecord],
    message { 'Those are not DnsRecord objects.' };

    coerce DnsRecords,
    from ArrayRef[HashRef],
    via { [ map { 'Mail::Mailgun::Core::DnsRecord'->new($_) } @$_  ] };

    declare NonNegativeInt,
    as Int,
    where { $_ >= 0 },
    message { 'Must be 0 or greater.' };

    declare PositiveInt,
    as Int,
    where { $_ > 0 },
    message { 'Must be greater than 0.' };

    declare StrMax128,
    as Str,
    where { length $_ <= 128 },
    message { 'Maximum allowed string length is 128 characters.' };

    declare ArrayRefMaxThreeStr128,
    as ArrayRef[StrMax128],
    where { scalar @$_ <= 3 },
    message { 'This array ref takes not more than three items.' };

    coerce ArrayRefMaxThreeStr128,
    from StrMax128,
    via { [ $_ ] };

    declare ArrayRefStr,
    as ArrayRef[Str],
    message { 'Those are not strings' };

    coerce ArrayRefStr,
    from Str,
    via { [$_] };

    declare ArrayRefInt,
    as ArrayRef[Int],
    message { 'Those are not ints' };

    coerce ArrayRefInt,
    from Int,
    via { [$_] };

    declare Files,
    as ArrayRef[File],
    message { 'Those are not File objects.' };

    coerce Files,
    from ArrayRef[Str],
    via { [ map { path($_) } @$_ ] };

    coerce Files,
    from Str,
    via { [ path($_) ] };

    declare Uris,
    as ArrayRef[Uri],
    message { 'Those are not Uri objects.' };

    coerce Uris,
    from ArrayRef[Str],
    via { [ map { $_ } @$_ ] };

    coerce Uris,
    from Str,
    via { [ Uri->coerce($_) ] };

    declare TimestampRFC2822,
    as Str,
    where {
        $_ =~ m{^\w{3},   \s    # day of week
                 \d{1,2}  \s    # day of month
                 \w{3}    \s    # month
                 \d{4}    \s    # year
                 \d{1,2}  :     # hour
                 \d{1,2}  :     # minute
                 \d{1,2}  \s    # second
                 .+             # time zone
            }x;
    },
    message { sprintf q{That (%s) doesn't look like an RFC2822 time stamp}, $_ };

    coerce TimestampRFC2822,
    from TimeMoment,
    via { $_->strftime('%a, %d %b %Y %H:%M:%S %z') };

    coerce TimeMoment,
    from TimestampRFC2822,
    via { 
        $_ =~ m{^(?<dow>\w{3}),   \s    # day of week
                 (?<day>\d{1,2})  \s    # day of month
                 (?<mon>\w{3})    \s    # month
                 (?<year>\d{4})   \s    # year
                 (?<hour>\d{1,2}) :     # hour
                 (?<min>\d{1,2})  :     # minute
                 (?<sec>\d{1,2})  \s    # second
                 (?<tz>.+)              # time zone
            }x;

        my %months = (Jan => 1, Feb => 2, Mar => 3, Apr => 4, May => 5, Jun => 6, Jul => 7, Aug => 8, Sep => 9, Oct => 10, Nov => 11, Dec => 12);

        'Time::Moment'->new(year => $+{'year'},
                            month => $months{ $+{'mon'} },
                            day => $+{'day'},
                            hour => $+{'hour'},
                            minute => $+{'minute'},
                            second => $+{'second'}
                        );
    };

   # coerce TimestampRFC2822,
   # from Str,
   # via { 'Time::Moment'->from_string($_)->strftime('%a, %d %b %Y %H:%M:%S %z') };

    sub coerce_from_hashref {
        my $type = shift;
        my $class = shift;
        my $method = shift;

        coerce $type,
        from HashRef,
        via {
            # transform all keys with '-' to '_'
            my $inref = $_;
            my $hashref = { map { my $key = $_; $key =~ s{-}{_}g; { $key => $inref->{ $_ } } } keys %$inref };

            $class->$method(%$hashref);
        };
    }

}

1;
