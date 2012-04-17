package App::Pinto::Remote::Command::import;

# ABSTRACT: get selected distributions from a remote repository

use strict;
use warnings;

#------------------------------------------------------------------------------

use base 'App::Pinto::Remote::Command';

#------------------------------------------------------------------------------

our $VERSION = '0.039'; # VERSION

#-----------------------------------------------------------------------------

sub command_names { return qw( import ) }

#-----------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'message|m=s' => 'Prepend a message to the VCS log' ],
        [ 'nocommit'    => 'Do not commit changes to VCS' ],
        [ 'norecurse'   => 'Do not recursively import prereqs' ],
        [ 'noinit'      => 'Do not pull/update from VCS' ],
        [ 'tag=s'       => 'Specify a VCS tag name' ],
    );
}

#------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    my $usage =  <<"END_USAGE";
%c --root=PATH $command [OPTIONS] TARGET
END_USAGE

    chomp $usage;
    return $usage;
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error("Must specify exactly one target") if @{ $args } != 1;

    return 1;
}

#------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    $self->pinto->new_batch(%{$opts});
    $self->pinto->add_action('Import', %{$opts}, target => $args->[0]);
    my $result = $self->pinto->run_actions();
    return $result->is_success() ? 0 : 1;
}

#------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems norecurse

=head1 NAME

App::Pinto::Remote::Command::import - get selected distributions from a remote repository

=head1 VERSION

version 0.039

=head1 SYNOPSIS

  pinto-remote --root=URL import [OPTIONS] TARGET

=head1 DESCRIPTION

This command locates a package in your upstream repositories and then
imports the distribution providing that package into your repository.
Then it recursively locates and imports all the distributions that are
necessary to satisfy its prerequisites.  You can also request to
directly import a particular distribution.

When locating packages, Pinto first looks at the the packages that
already exist in the local repository, then Pinto looks at the
packages that are available available on the upstream repositories.
At present, Pinto takes the *first* package it can find that satisfies
the prerequisite.  In the future, you may be able to direct Pinto to
instead choose the *latest* package that satisfies the prerequisite.
(NOT SURE THOSE LAST TWO STATEMENTS ARE TRUE).

Imported distributions will be assigned to their original author
(compare this to the "add" command which makes you the author of the
distribution).  Also, packages provided by imported distributions are
still considered foreign, so locally added packages will always
override ones that you imported, even if the imported package has a
higher version.

=head1 COMMAND ARGUMENTS

The argument is the target that you want to import.  A target can be
specified as a package name (with or without a minimum version number)
or as a particular distribution.  For example:

  Foo::Bar                                 # Imports any version of Foo::Bar
  Foo::Bar−1.2                             # Imports Foo::Bar 1.2 or higher
  SHAKESPEARE/King−Lear−1.2.tar.gz         # Imports a specific distribuion
  SHAKESPEARE/tragedies/Hamlet−4.2.tar.gz  # Ditto, but from a subdirectory

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

=item --norecurse

Prevents L<Pinto> from recursively importing any distributions
required to satisfy prerequisites.

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
