use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;

# VERSION:
# PODCLASSNAME
# ABSTRACT: Short intro

class Mail::Mailgun {

    use File::HomeDir;
    use Config::Any;
    use LWP::UserAgent;
    use JSON::MaybeXS 'decode_json';

   # use Mail::Mailgun::Core::HttpResponse;

    use Mail::Mailgun::Core::DnsRecord;
    use Mail::Mailgun::Rest::Message;
    use Mail::Mailgun::Rest::Message::SendOptions;
    use Mail::Mailgun::Rest::Domain;
    use Mail::Mailgun::Rest::DomainCredential;
    use Mail::Mailgun::Rest::DomainConnection;
    use Mail::Mailgun::Rest::Stats;
    use Mail::Mailgun::Rest::Event;


    has config => (
        is => 'ro',
        isa => Dict[key => Optional[Str], domain => Optional[Str] ],
        builder => 1,
    );
    has key => (
        is => 'ro',
        isa => Str,
        lazy => 1,
        required => 1,
        default => sub { $ENV{'MAILGUN_KEY'} || shift->config->{'key'} },
    );
    has domain => (
        is => 'ro',
        isa => Str,
        lazy => 1,
        predicate => 1,
        default => sub { $ENV{'MAILGUN_DOMAIN'} || shift->config->{'domain'} },
    );
    #has from => (
    #    is => 'ro',
    #    isa => EmailAddress,
    #    lazy => 1,
    #    predicate => 1,
    #    default => sub { $ENV{'MAILGUN_FROM'} || shift->config->{'from'} },
    #);
    has ua => (
        is => 'ro',
        isa => InstanceOf['LWP::UserAgent'],
        default => sub { LWP::UserAgent->new },
    );
    has default_url => (
        is => 'ro',
        isa => Str,
        lazy => 1,
        default => sub { 'api.mailgun.net/v3' },
    );
    has base_url => (
        is => 'ro',
        isa => Str,
        init_arg => undef,
        lazy => 1,
        default => method { sprintf 'https://api:%s@%s', $self->key, $self->default_url }
    );

    method _build_config {
        my $dist_config_dir = File::HomeDir->my_dist_config('Mail-Mailgun') ? path(File::HomeDir->my_dist_config('Mail-Mailgun')) : undef;
        my $home_dir =        File::HomeDir->my_home('Mail-Mailgun')        ? path(File::HomeDir->my_home('Mail-Mailgun'))        : undef;
        my $env_dir =         exists $ENV{'MAILGUN_CONFIG_DIR'}             ? path($ENV{'MAILGUN_CONFIG_DIR'}) : undef;

        my $config_dir = defined $env_dir && $env_dir->exists                 ? $env_dir
                       : defined $dist_config_dir && $dist_config_dir->exists ? $dist_config_dir
                       : defined $home_dir && $home_dir->exists               ? $home_dir
                       :                                                        undef
                       ;

        return { } if !defined $config_dir;

        my $config = Config::Any->load_stems( { stems => [$config_dir->child('mailgun')->stringify], use_ext => 1, flatten_to_hash => 1 });
        return $config->{ (keys %$config)[0] }; # pick the 'first' config file if more than one.
    }

    method message_send(MessageSendRequest $request does coerce --> MessageSendResponse but assumed) {
        return $request->make_request;
    }

    method domain_add(DomainAddRequest $request does coerce --> DomainAddResponse but assumed) {
        return $request->make_request;
    }
    method domain_delete(DomainDeleteRequest $request does coerce --> DomainDeleteResponse but assumed) {
        return $request->make_request;
    }
    method domain_list(DomainListRequest $request does coerce --> DomainListResponse but assumed) {
        return $request->make_request;
    }

    method domain_credential_list(DomainCredentialListRequest $request does coerce --> DomainCredentialListResponse but assumed) {
        return $request->make_request;
    }
    method domain_credential_add(DomainCredentialAddRequest $request does coerce --> DomainCredentialAddResponse but assumed) {
        return $request->make_request;
    }
    method domain_credential_update(DomainCredentialUpdateRequest $request does coerce --> DomainCredentialUpdateResponse but assumed) {
        return $request->make_request;
    }
    method domain_credential_delete(DomainCredentialDeleteRequest $request does coerce --> DomainCredentialDeleteResponse but assumed) {
        return $request->make_request;
    }

    method domain_connection_get(DomainConnectionGetRequest $request does coerce --> DomainConnectionGetResponse but assumed) {
        return $request->make_request;
    }
    method domain_connection_update(DomainConnectionUpdateRequest $request does coerce --> DomainConnectionUpdateResponse but assumed) {
        return $request->make_request;
    }

    method stats_get(StatsGetRequest $request does coerce --> StatsGetResponse but assumed) {
        return $request->make_request;
    }

    method events_get(EventGetRequest $request does coerce --> EventGetResponse but assumed) {
        return $request->make_request;
    }

    around message_send,
           domain_list, domain_add, domain_delete,
           domain_credential_list, domain_credential_add, domain_credential_update, domain_credential_delete,
           domain_connection_get, domain_connection_update,
           stats_get,
           events_get
           ($next: $self, HashRef $data does slurpy) {
        
        $data->{'mailgun'} //= $self;
        $data->{'base_url'} = $self->base_url;
        $data->{'ua'} = $self->ua;
        $data->{'domain'} //= $self->domain;
        return $self->$next($data);
    }

}

1;


__END__

=pod

=head1 SYNOPSIS

    use Mail::Mailgun2;

=head1 DESCRIPTION

Mail::Mailgun2 is ...

=head1 SEE ALSO

=cut
