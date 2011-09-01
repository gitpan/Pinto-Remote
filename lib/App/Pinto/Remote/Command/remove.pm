package App::Pinto::Remote::Command::remove;

# ABSTRACT: remove a distribution from a remote Pinto repository

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.020'; # VERSION

#-------------------------------------------------------------------------------

sub command_names { return qw( remove rm delete del ) }

#-------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'author|a=s'  => 'Your (alphanumeric) author ID' ],
        [ 'message|m=s' => 'Prepend a message to the VCS log' ],
        [ 'tag=s'       => 'Specify a VCS tag name' ],
    );
}

#-------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    return "%c --repos=URL $command [OPTIONS] DISTRIBUTION_NAME";
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error("Must specify exactly one distribution name") if @{ $args } != 1;

    return 1;
}

#-------------------------------------------------------------------------------

sub execute {
    my ( $self, $opts, $args ) = @_;

    $self->pinto->new_action_batch( %{$opts} );
    $self->pinto->add_action('Remove', %{$opts}, dist_name => $args->[0]);
    my $result = $self->pinto->run_actions();
    print $result->to_string();

    return $result->is_success() ? 0 : 1;
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::remove - remove a distribution from a remote Pinto repository

=head1 VERSION

version 0.020

=head1 SYNOPSIS

  pinto-remote --repos=URL remove [OPTIONS] DISTRIBUTION_NAME

=head1 DESCRIPTION

This command removes a local distribution from the repository.  You
cannot remove foreign distributions that were pulled in from another
repository using the C<update> command (however you can mask them by
C<add>ing your own versions).

=head1 COMMAND ARGUMENTS

The argument to this command is the name of the distribution you wish
to remove.  You must specify the complete distribution name, including
version number and extension.  The precise identity of the
distribution that will be removed depends on who you are.  So if you
are C<JOE> and you ask to remove C<Foo-1.0.tar.gz> then you are really
asking to remove C<J/JO/JOE/Foo-1.0.tar.gz>.

To remove a distribution that was added by another author, use the
C<--author> option to change who you are.  Or you can just
explicitly specify the full identity of the distribution.  So the
following two examples are equivalent:

  $> pinto-remote --repos=http://my.server:3000 remove --author=SUSAN Foo-1.0.tar.gz
  $> pinto-remote --repos=http://my.server:3000 remove S/SU/SUSAN/Foo-1.0.tar.gz

=head1 COMMAND OPTIONS

=over 4

=item --author=NAME

Sets your identity as a distribution author.  The C<NAME> can only be
alphanumeric characters only (no spaces) and will be forced to
uppercase.  The default is your username.

=item --message=MESSAGE

Prepends the MESSAGE to the VCS log message that L<Pinto> generates.
This is only relevant if you are using a VCS-based storage mechanism
for L<Pinto>.

=item --tag=NAME

Instructs L<Pinto> to tag the head revision of the repository at NAME.
This is only relevant if you are using a VCS-based storage mechanism.
The syntax of the NAME depends on the type of VCS you are using.

=back

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

