package App::Pinto::Remote::Command;

# ABSTRACT: Base class for pinto-remote commands

use strict;
use warnings;

use Carp;
use App::Cmd::Setup -command;

#-----------------------------------------------------------------------------

our $VERSION = '0.037'; # VERSION

#-----------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    return "%c --root=URL $command [OPTIONS] [ARGS]"
}

#-----------------------------------------------------------------------------


sub pinto {
    my ($self) = @_;
    return $self->app->pinto();
}

#-----------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    $self->pinto->new_batch( %{$opts} );
    $self->pinto->add_action( $self->action_name(), %{$opts} );
    my $result = $self->pinto->run_actions();

    return $result->is_success() ? 0 : 1;
}

#-----------------------------------------------------------------------------


sub action_name {
    my ($self) = @_;

    my $class = ref $self || $self;

    $class =~ m{ ([^:]+) $ }mx
        or croak "Unable to parse Action name from $class";

    return ucfirst $1;
}

#-----------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command - Base class for pinto-remote commands

=head1 VERSION

version 0.037

=head1 METHODS

=head2 pinto()

Returns a reference to the L<Pinto::Remote> object that has been
constructed for this command.

=head2 action_name()

Returns a fragment of the L<Pinto::Remote::Action> subclass name for
this command.  For example, if this command class name is
Pinto::Remote::Command::shizzle, then this method will return
C<Shizzle> which Pinto will then translate into
Pinto::Remote::Action::Shizzle.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
