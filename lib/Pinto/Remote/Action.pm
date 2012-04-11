package Pinto::Remote::Action;

# ABSTRACT: Base class for remote Actions

use Moose;

use Carp;
use URI;
use LWP::UserAgent;
use HTTP::Request::Common;

use Pinto::Remote::Result;
use Pinto::Constants qw(:all);
use Pinto::Types qw(IO);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.038'; # VERSION

#------------------------------------------------------------------------------

has config    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Config',
    required  => 1,
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
    default   => sub { LWP::UserAgent->new(timeout => 600) },
);

#------------------------------------------------------------------------------


sub execute {
    my ($self) = @_;

    my $class = ref $self;
    $class =~ m{ ([^:]+) $}mx or confess "Could not parse action name from $class";
    my $action_name = lc $1;

    my $form_data  = $self->can('as_post_data') ? $self->as_post_data : [];

    my $url = URI->new( $self->config->root() );
    $url->path_segments('', 'action', $action_name);

    my $request = POST( $url, Content_Type => 'form-data',
                              Content      => $form_data );

    if ( $self->config->password() ) {
        $request->authorization_basic( $self->config->username(),
                                       $self->config->password() );
    }


    return $self->_send_request($request);
}

#------------------------------------------------------------------------------

sub _send_request {
    my ($self, $request) = @_;

    my $status   = 0;
    my $buffer   = '';
    my $callback = sub { $self->_response_data_handler(@_, \$status, \$buffer) };
    my $response = $self->ua->request($request, $callback, 128);

    if (not $response->is_success()) {
        $self->logger->error($response->content);
        return Pinto::Remote::Result->new(is_success => 0);
    }

    return Pinto::Remote::Result->new(is_success => $status);
}

#------------------------------------------------------------------------------

sub _response_data_handler {                  ## no critic qw(ProhibitManyArgs)
    my ($self, $data, $request, $proto, $status, $buffer) = @_;

    ${ $buffer } .= $data;
    # Look mom! Homemade line buffering...
    my $line = ${ $buffer } =~ s{^ (.*\n) }{}sx ? $1 : '';

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

        # Send everything else to the output handle
        if ($self->can('out')) {
            print {$self->out} "$_\n";
            next;
        }

        # If we get here, then something is fishy
        $self->error("Unexpected response: $_");
    }

    return 1;
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action - Base class for remote Actions

=head1 VERSION

version 0.038

=head1 METHODS

=head2 execute()

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
