# ABSTRACT: Record events in the repository log file (and elsewhere).

package Pinto::Remote::Logger;

use Moose;

use Log::Dispatch;

use Pinto::Constants qw(:all);

use namespace::autoclean;

#-----------------------------------------------------------------------------

our $VERSION = '0.037'; # VERSION

#-----------------------------------------------------------------------------

has log_handler => (
    is       => 'ro',
    isa      => 'Log::Dispatch',
    builder  => '_build_log_handler',
    handles  => [qw(debug info notice warning error)], # fatal is handled below
    lazy     => 1,
);

#-----------------------------------------------------------------------------

sub _build_log_handler {
    my ($self) = @_;

    my $handler = Log::Dispatch->new();

    return $handler;
}

#-----------------------------------------------------------------------------


sub add_output {
    my ($self, $output) = @_;

    my $base_class = 'Log::Dispatch::Output';
    $output->isa($base_class) or confess "Argument is not a $base_class";

    $self->log_handler->add($output);

    return $self;
}

#-----------------------------------------------------------------------------


sub log_server_message {
    my ($self, $message) = @_;

    # Shorthand...
    my $prefix    = $PINTO_SERVER_RESPONSE_LINE_PREFIX;
    my $levels_rx = qr{DEBUG|NOTICE|INFO|WARNING|ERROR|CRITICAL|EMERGENCY}ix;


    if ( $message =~ s{^ \Q$prefix\E ($levels_rx): \s+}{$prefix}x ) {
        return $self->log_handler->log(level => lc $1, message => $message);
    }

    return $self->warning("Unable to parse message: $message");
}

#-----------------------------------------------------------------------------
# Logging methods handled by Log::Dispatch


#-----------------------------------------------------------------------------


sub fatal {  ## no critic qw(FinalReturn)
    my ($self, $message) = @_;

    $self->log_handler->log_and_croak(level => 'critical', message => $message);
}

#-----------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-----------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems redispatches

=head1 NAME

Pinto::Remote::Logger - Record events in the repository log file (and elsewhere).

=head1 VERSION

version 0.037

=head1 METHODS

=head2 add_output( $obj )

Adds the object to the output destinations that this logger writes to.
The object must be an instance of a L<Log::Dispatch::Output> subclass,
such as L<Log::Dispatch::Screen> or L<Log::Dispatch::Handle>.

=head2 log_server_message( $message )

Parses a log message received from the Pinto server and redispatches
it through the local logger at the appropriate level.

=head2 debug( $message )

Logs a message at the 'debug' log level.

=head2 notice( $message )

Logs a message at the 'notice' log level.

=head2 info( $message )

Logs a message at the 'info' log level.

=head2 warning( $message )

Logs a message at the 'warning' log level.

=head2 error( $message )

Logs a message at the 'error' log level.

=head2 fatal( $message )

Logs a message at the 'critical' log level and croaks.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

