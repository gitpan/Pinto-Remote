package App::Pinto::Remote::Command::add;

# ABSTRACT: add a distribution to the remote repository

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.039'; # VERSION

#-------------------------------------------------------------------------------

sub command_names { return qw( add inject ) }

#-------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'author=s'    => 'Your (alphanumeric) author ID' ],
        [ 'message|m=s' => 'Prepend a message to the VCS log' ],
        [ 'norecurse'   => 'Do not recursively import prereqs' ],
        [ 'tag=s'       => 'Specify a VCS tag name' ],

    );
}

#-------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    return "%c --root=URL $command [OPTIONS] ARCHIVE_FILE";
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error("Must specify exactly one archive file") if @{ $args } != 1;

    return 1;
}

#-------------------------------------------------------------------------------

sub execute {
    my ( $self, $opts, $args ) = @_;

    $self->pinto->new_batch( %{$opts} );
    $self->pinto->add_action('Add', %{$opts}, archive => $args->[0]);
    my $result = $self->pinto->run_actions();
    return $result->is_success() ? 0 : 1;
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::add - add a distribution to the remote repository

=head1 VERSION

version 0.039

=head1 SYNOPSIS

  pinto-remote --root=URL add [OPTIONS] ARCHIVE_FILE

=head1 DESCRIPTION

This command adds a local distribution archive to the repository.
When a local distribution is first added to the repository, the author
becomes the owner of the distribution.  Thereafter, only the same
author can add a new version of that distribution. [Technically
speaking, the author really owns the *packages* within the
distribution, not the distribution itself.]

=head1 COMMAND ARGUMENTS

The argument to this command is the path to the distribution archive
file that you wish to add.  This file must exist and must be readable.

=head1 COMMAND OPTIONS

=over 4

=item --author=NAME

Sets your identity as a distribution author.  The C<NAME> must be
alphanumeric characters (no spaces) and will be forced to uppercase.
Defaults to the C<user> specified in your C<~/.pause> configuration
file (if such file exists).  Otherwise, defaults to your current login
username.

=item --norecurse

Prevents L<Pinto> from recursively importing distributions required to
satisfy the prerequisites of the added distribution.  Imported
distributions are pulled from whatever remote repositories are
configured as the C<source> for the remove repository.

=item --message=MESSAGE

Prepends the C<MESSAGE> to the VCS log message that L<Pinto>
generates.  This is only relevant if you are using a VCS-based storage
mechanism for L<Pinto>.

=item --tag=NAME

Instructs L<Pinto> to tag the head revision of the repository at
C<NAME>.  This is only relevant if you are using a VCS-based storage
mechanism.  The syntax of the NAME depends on the type of VCS you are
using.

=back

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

