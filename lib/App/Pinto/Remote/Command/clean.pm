package App::Pinto::Remote::Command::clean;

# ABSTRACT: remove all distributions that are not in the index

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Remote::Command';

#------------------------------------------------------------------------------

our $VERSION = '0.038'; # VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'message|m=s' => 'Prepend a message to the VCS log' ],
        [ 'nocommit'    => 'Do not commit changes to VCS' ],
        [ 'noinit'      => 'Do not pull/update from VCS' ],
        [ 'tag=s'       => 'Specify a VCS tag name' ]
    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed') if @{ $args };

    return 1;
}

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::clean - remove all distributions that are not in the index

=head1 VERSION

version 0.038

=head1 SYNOPSIS

  pinto-remote --root=URL clean [OPTIONS]

=head1 DESCRIPTION

This command removes any distribution in the repository that is not
currently listed in the index.  In other words, it removes any
distribution that doesn't have at least one package that is considered
to be the latest version of that package.  Beware that running the
C<clean> command will make it impossible to install outdated
distributions from your repository, and the only way to get them back
is to C<add> or C<import> them again (or rollback, if using VCS).

=head1 COMMAND ARGUMENTS

None.

=head1 COMMAND OPTIONS

=over 4

=item --message=MESSAGE

Prepends the MESSAGE to the VCS log message that L<Pinto> generates.
This is only relevant if you are using a VCS-based storage mechanism
for L<Pinto>.

=item --nocommit

Prevents L<Pinto> from committing changes in the repository to the VCS
after the operation.  This is only relevant if you are using a
VCS-based storage mechanism.  Beware this will leave your working copy
out of sync with the VCS.  It is up to you to then commit or rollback
the changes using your VCS tools directly.  Pinto will not commit old
changes that were left from a previous operation.

=item --noinit

Prevents L<Pinto> from pulling/updating the repository from the VCS
before the operation.  This is only relevant if you are using a
VCS-based storage mechanism.  This can speed up operations
considerably, but should only be used if you *know* that your working
copy is up-to-date and you are going to be the only actor touching the
Pinto repository within the VCS.

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

