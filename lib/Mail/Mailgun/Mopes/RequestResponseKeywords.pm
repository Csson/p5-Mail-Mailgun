package Mail::Mailgun::Mopes::RequestResponseKeywords;

use strict;
use warnings;

use Moo::Role;
use Module::Runtime qw/$module_name_rx/;

after parse => sub {
    my $self = shift;

    if($self->keyword eq 'request') {
        push @{ $self->relations->{'with'} ||= [] } => (
            'Mail::Mailgun::Role::Request',
        );
    }
    elsif($self->keyword eq 'response') {
        push @{ $self->relations->{'with'} ||= [] } => (
            'Mail::Mailgun::Role::Response',
        );
    }
};


1;
