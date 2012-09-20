# ABSTRACT: Base class for remote Actions

package Pinto::Remote::Action;

use Moose;
use MooseX::Types::Moose qw(Str);
use Pinto::Types qw(Io);

use Carp;
use URI;
use JSON;
use HTTP::Request::Common;

use Pinto::Remote::Result;
use Pinto::Exception qw(throw);
use Pinto::Constants qw(:all);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.047'; # VERSION

#------------------------------------------------------------------------------

has name      => (
    is        => 'ro',
    isa       => Str,
    required  => 1,
);


has args    => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
);


has config   => (
    is       => 'ro',
    isa      => 'Pinto::Remote::Config',
    required => 1,
);


has logger    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Logger',
    handles   => [ qw(debug info notice warning fatal) ],
    required  => 1,
);


has ua        => (
    is        => 'ro',
    isa       => 'LWP::UserAgent',
    required  => 1,
);

#------------------------------------------------------------------------------


sub execute {
    my ($self) = @_;

    my $request = $self->_make_request;
    my $result  = $self->_send_request(req => $request);

    return $result;
}

#------------------------------------------------------------------------------

sub _make_request {
    my ($self, %args) = @_;

    my $action_name = $args{name}      || $self->name;
    my $post_data   = $args{post_data} || $self->_as_post_data;

    my $url = URI->new( $self->config->root );
    $url->path_segments('', 'action', lc $action_name);

    my $request = POST( $url, Content_Type => 'form-data',
                              Content      => $post_data );

    if ( $self->config->password ) {
        $request->authorization_basic( $self->config->username,
                                       $self->config->password );
    }

    return $request;
}


#------------------------------------------------------------------------------

sub _pinto_args {
    my ($self) = @_;

    my $pinto_args = { log_level => $self->config->log_level,
                       username  => $self->config->username };

    return ( pinto_args => encode_json($pinto_args) );
}

#------------------------------------------------------------------------------

sub _action_args {
    my ($self) = @_;

    return ( action_args => encode_json($self->args) );
}

#------------------------------------------------------------------------------

sub _as_post_data {
    my ($self) = @_;

    return [ $self->_pinto_args, $self->_action_args ];
}

#------------------------------------------------------------------------------

sub _send_request {
    my ($self, %args) = @_;

    my $request = $args{req} || $self->make_request;
    my $out     = $args{out} || \*STDOUT;

    my $status   = 0;
    my $buffer   = '';

    # Currying in some extra args to the callback...
    my $callback = sub { $self->_response_callback(@_, \$status, \$buffer, $out) };
    my $response = $self->ua->request($request, $callback, 128);

    if (not $response->is_success()) {
        $self->logger->error($response->content);
        return Pinto::Remote::Result->new(was_successful => 0);
    }

    return Pinto::Remote::Result->new(was_successful => $status);
}

#------------------------------------------------------------------------------

sub _response_callback {                  ## no critic qw(ProhibitManyArgs)
    my ($self, $data, $request, $proto, $status, $buffer, $out) = @_;

    ${ $buffer } .= $data;
    # Look mom! Homemade line buffering...
    my $line = ( ${$buffer} =~ s{^ (.*\n) }{}sx ) ? $1 : ''; ## no critic qw(CaptureWithoutTest)

    for (split m{\n}x, $line) {

        # Ignore the prologue
        next if $_ eq $PINTO_SERVER_RESPONSE_PROLOGUE;

        # Ignore the epilogue, but note that we saw it
        if ($_ eq $PINTO_SERVER_RESPONSE_EPILOGUE) {
            ${ $status } = 1;
            next;
        }

        # Send diagnostic messages to logger
        if (m{^\Q$PINTO_SERVER_RESPONSE_LINE_PREFIX\E}x) {
            $self->logger->log_server_message($_);
            next;
        }

        print $out "$_\n";
    }

    return 1;
}

#-----------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action - Base class for remote Actions

=head1 VERSION

version 0.047

=head1 METHODS

=head2 execute

Runs this Action on the remote server by serializing itself and
sending a POST request to the server.  Returns a
L<Pinto::Remote::Result>.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
