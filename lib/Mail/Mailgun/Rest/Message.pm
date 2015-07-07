use 5.14.0;
use strict;
use warnings;
use Mail::Mailgun::Standard;
use Rest::Repose;

package Mail::Mailgun::Rest;

# VERSION
# PODCLASSNAME
# ABSTRACT: .

use Hash::Merge;

resource Message {

    purpose Send {

        request {

            use JSON::MaybeXS 'encode_json';

            post ':domain/messages';

            param from => (
                isa => EmailAddress,
                printable_asis => 1,
                coerce => 1,
            );

            param to => (
                isa => EmailAddresses,
                printable_method => 1,
                coerce => 1,
            );

            param cc => (
                isa => EmailAddresses,
                printable_method => 1,
                coerce => 1,
                optional => 1,
            );

            param bcc => (
                isa => EmailAddresses,
                printable_method => 1,
                coerce => 1,
                optional => 1,
            );

            param subject => (
                isa => Str,
                printable_asis => 1,
            );

            param text => (
                isa => Str,
                printable_asis => 1,
                optional => 1,
            );

            param html => (
                isa => Str,
                printable_asis => 1,
                optional => 1,
            );

            param attachments => (
                isa => Files,
                printable_method => 1,
                coerce => 1,
                optional => 1,
            );

            param inlines => (
                isa => Files,
                printable_method => 1,
                coerce => 1,
                optional => 1,
            );

            param options => (
                isa => MessageSendOptions,
                printable_method => 1,
                coerce => 1,
                optional => 1,
            );

            param headers => (
                isa => HashRef,
                traits => ['Hash'],
                printable_method => 1,
                optional => 1,
            );

            param variables => (
                isa => HashRef,
                traits => ['Hash'],
                printable_method => 1,
                optional => 1,
            );
            method to_printable {
                return to => $self->join_to(',');
            }
            method cc_printable {
                return () if !$self->count_cc;
                return cc => $self->join_cc(',');
            }
            method bcc_printable {
                return () if !$self->count_bcc;
                return bcc => $self->join_bcc(',');
            }
            method attachments_printable {
                return () if !$self->has_attachments;
                return map { (attachment => [$_->stringify]) } $self->all_attachments;
            }
            method inlines_printable {
                return () if !$self->has_inlines;
                return map { (inline => [$_->stringify]) } $self->all_inlines;
            }

            method variables_printable {
                return $self->structure_printable('kv_variables', 'v', jsonify => 1);
            }
            method headers_printable {
                return $self->structure_printable('kv_headers', 'h', jsonify => 0);
            }

            method structure_printable($method, $prefix, :$jsonify!) {

                my @data = ();

                foreach my $setting ($self->$method) {
                    my $key = sprintf '%s:%s', $prefix, $setting->[0];
                    my $value = $setting->[1];

                    if(ArrayRef->check($value)) {

                        foreach my $val (@$value) {
                            if($jsonify) {
                                $val = encode_json($val);
                            }
                            push @data => ($key => $val);
                        }
                    }
                    else {
                        if($jsonify) {
                            $value = encode_json($value);
                        }
                        push @data => ($key => $value);
                    }
                }
                return @data;
            }
            method options_printable(--> HashRef but assumed) {
                return $self->options->_printable;
            }

        }
        response {
            prop message => (
                isa => Str,
          #      value => '$.message',
            );
#
#          #  prop id => (
#          #      value => '$.id',
          #  );
        }
    }
}

1;

=pod


use Mail::Mailgun::Standard;
use strict;
use warnings;

# PODCLASSNAME

class Mail::Mailgun::Action::Message::Send::Call
using Moose {

    # VERSION:
    # ABSTRACT: Send message call

    use List::UtilsBy 'extract_by';
    use JSON::MaybeXS 'encode_json';

    has mailgun => (
        is => 'ro',
        isa => MailGun,
        required => 1,
    );
    has from => (
        is => 'ro',
        isa => EmailAddress,
        mailgun_hashable_string => 1,
        predicate => 1,
        required => 1,
        lazy => 1,
        default => sub { shift->mailgun->from },
    );
    has to => (
        is => 'ro',
        isa => EmailAddresses,
        traits => ['Array'],
        mailgun_hashable_method => 1,
        default => sub { [] },
        coerce => 1,
        required => 1,
        handles => {
            get_to => 'get',
            join_to => 'join',
        }
    );
    has cc => (
        is => 'ro',
        isa => EmailAddresses,
        traits => ['Array'],
        mailgun_hashable_method => 1,
        default => sub { [] },
        coerce => 1,
        handles => {
            all_cc => 'elements',
            join_cc => 'join',
            has_cc => 'count',
        }
    );
    has bcc => (
        is => 'ro',
        isa => EmailAddresses,
        traits => ['Array'],
        mailgun_hashable_method => 1,
        default => sub { [] },
        coerce => 1,
        handles => {
            all_bcc => 'elements',
            join_bcc => 'join',
            has_bcc => 'count',
        }
    );
    has subject => (
        is => 'ro',
        isa => Str,
        required => 1,
        mailgun_hashable_string => 1,
    );
    has text => (
        is => 'ro',
        isa => Str,
        mailgun_hashable_string => 1,
        predicate => 1,
    );
    has html => (
        is => 'ro',
        isa => Str,
        mailgun_hashable_string => 1,
        predicate => 1,
    );
    has attachments => (
        is => 'ro',
        isa => Files,
        traits => ['Array'],
        mailgun_hashable_method => 1,
        coerce => 1,
        default => sub { [] },
        handles => {
            all_attachments => 'elements',
            has_attachments => 'count',
        },
    );
    has inlines => (
        is => 'ro',
        isa => Files,
        traits => ['Array'],
        mailgun_hashable_method => 1,
        coerce => 1,
        default => sub { [] },
        handles => {
            all_inlines => 'elements',
            has_inlines => 'count',
        }
    );
    has options => (
        is => 'ro',
        isa => MessageSendCallOptions,
        mailgun_hashable_method => 1,
        predicate => 1,
        coerce => 1,
    );
    has headers => (
        is => 'ro',
        isa => HashRef,
        traits => ['Hash'],
        mailgun_hashable_method => 1,
        default => sub { {} },
        predicate => 1,
        handles => {
            headers_kv => 'kv',
        },
    );
    has variables => (
        is => 'ro',
        isa => HashRef,
        traits => ['Hash'],
        mailgun_hashable_method => 1,
        default => sub { {} },
        predicate => 1,
        handles => {
            variables_kv => 'kv',
        },
    );

    method method { 'post' }
    method prefix { undef }
    method with_domain { 1 }
    method postfix { 'messages' }
    method qs { { } }

    with 'Mail::Mailgun::Role::Call' => {
        create_class => 'Mail::Mailgun::Action::Message::Send',
    };

    # since some keys can appear multiple time in the call to mailgun
    # this instead returns an array ref...
    around to_hash {

        my @attributes = map { $self->meta->get_attribute($_) } $self->meta->get_attribute_list;
        my @hashable_attributes = extract_by { $_->does('Mailgun') && $_->mailgun_hashable } @attributes;
        my @mailgun_attributes = extract_by { my $predicate = sprintf 'has_%s', $_->name; $_->is_required || $self->$predicate } @hashable_attributes;

        my $arrayref = [ map { 
                                  my $attr = $_;
                                  my $attr_name = $attr->name;
                                  my $hashify_attr = sprintf 'hashify_%s', $_->name;

                                  # either use the attribute directly, or call the respective hashify method below
                                  $attr->mailgun_hashable_string ? ($attr_name => $self->$attr_name) : $self->$hashify_attr;
                              }
                            @mailgun_attributes
                       ];

        return $arrayref;
    }

    method hashify_to {
        return to => $self->join_to(',');
    }
    method hashify_cc {
        return () if !$self->has_cc;
        return cc => $self->join_cc(',');
    }
    method hashify_bcc {
        return () if !$self->has_bcc;
        return bcc => $self->join_bcc(',');
    }
    method hashify_attachments {
        return () if !$self->has_attachments;
        return map { (attachment => [$_->stringify]) } $self->all_attachments;
    }
    method hashify_inlines {
        return () if !$self->has_inlines;
        return map { (inline => $_->stringify) } $self->all_inlines;
    }
    method hashify_headers {
        return $self->hashify_headers_and_variables(h => 'headers_kv');
    }
    method hashify_variables {
        return $self->hashify_headers_and_variables(v => 'variables_kv', jsonify => 1);
    }

    method hashify_headers_and_variables(Str $prefix, Enum[qw/headers_kv variables_kv/] $method, Bool :$jsonify = 0) {

        my @data = ();

        foreach my $setting ($self->$method) {
            my $key = sprintf '%s:%s', $prefix, $setting->[0];
            my $value = $setting->[1];

            if(ArrayRef->check($value)) {

                foreach my $val (@$value) {
                    if($jsonify) {
                        $val = encode_json($val);
                    }
                    push @data => ($key => $val);
                }
            }
            else {
                if($jsonify) {
                    $value = encode_json($value);
                }
                push @data => ($key => $value);
            }
        }
        return @data;
    }

    method hashify_options(--> HashRef but assumed) {
        return $self->options->to_hash;
    }
}

1;
=cut