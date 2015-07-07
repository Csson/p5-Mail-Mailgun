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
    Files,
    Uris,
    ActualHttpResponse,
    HttpResponse,

    DnsRecord,
    DnsRecords,

    MessageSendRequest,
    MessageSendResponse,
    MessageSendOptions,

    DomainAddRequest,
    DomainAddResponse

{

    use Path::Tiny;
    use Types::Path::Tiny qw/File/;
    use Types::URI qw/Uri/;

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

        'Action::Domain::Delete' => {
            type => DomainDelete,
            coerce_from => ['HashRef'],
        },
        'Action::Domain::Delete::Call' => {
            type => DomainDeleteCall,
            coerce_from => ['HashRef'],
        },

        'Action::DomainCredentials::List::Item' => {
            type => DomainCredentialsListItem,
        },
        'Action::DomainCredentials::List' => {
            type => DomainCredentialsList,
            coerce_from => ['HashRef'],
        },
        'Action::DomainCredentials::List::Call' => {
            type => DomainCredentialsListCall,
            coerce_from => ['HashRef'],
        },
        'Action::DomainCredentials::Add' => {
            type => DomainCredentialsAdd,
        },
        'Action::DomainCredentials::Add::Call' => {
            type => DomainCredentialsAddCall,
            coerce_from => ['HashRef'],
        },
        'Action::DomainCredentials::Update' => {
            type => DomainCredentialsUpdate,
        },
        'Action::DomainCredentials::Update::Call' => {
            type => DomainCredentialsUpdateCall,
            coerce_from => ['HashRef'],
        },
        'Action::DomainCredentials::Delete' => {
            type => DomainCredentialsDelete,
        },
        'Action::DomainCredentials::Delete::Call' => {
            type => DomainCredentialsDeleteCall,
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
=pod
    my $item_declarations = [
        'Action::Domain::List::Item' => {
            as => ArrayRef[DomainListItem],
            one => DomainListItem,
            many => DomainListItems,
        },
        'Action::DomainCredentials::List::Item' => {
            as => ArrayRef[DomainCredentialsListItem],
            one => DomainCredentialsListItem,
            many => DomainCredentialsListItems,
        },
        'Action::Unsubscribe::List::Item' => {
            as => ArrayRef[UnsubscribeListItem],
            one => UnsubscribeListItem,
            many => UnsubscribeListItems,
        },
    ];

    for (my $i = 0; $i < scalar @$item_declarations; $i += 2) {
        my $partclass = $item_declarations->[$i];
        my $def = $item_declarations->[$i + 1];
        my $fullclass = 'Mail::Mailgun::' . $partclass;

        my $as = $def->{'as'};
        my $one = $def->{'one'};
        my $many = $def->{'many'};

        declare $many,
        as $as,
        message { sprintf "Those are not $one objects." };

        coerce $many,
        from ArrayRef[HashRef],
        via { [ map { $fullclass->new($_) } @$_ ] };

        coerce $one,
        from ArrayRef,
        via { [ $fullclass->new(@$_) ] };
    }


=cut


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
