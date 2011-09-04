package App::Pinto::Remote::Command::add;

# ABSTRACT: add a distribution to a remote Pinto repository

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.021'; # VERSION

#-------------------------------------------------------------------------------

sub command_names { return qw( add inject ) }

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

    return "%c --repos=URL $command [OPTIONS] DISTRIBUTION_FILE";
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error("Must specify exactly one distribution file") if @{ $args } != 1;

    return 1;
}

#-------------------------------------------------------------------------------

sub execute {
    my ( $self, $opts, $args ) = @_;

    $self->pinto->new_action_batch( %{$opts} );
    $self->pinto->add_action('Add', %{$opts}, dist_file => $args->[0]);
    my $result = $self->pinto->run_actions();
    print $result->to_string();

    return $result->is_success() ? 0 : 1;
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::add - add a distribution to a remote Pinto repository

=head1 VERSION

version 0.021

=head1 SYNOPSIS

  pinto-remote --repos=URL add [OPTIONS] DISTRIBUTION_FILE

=head1 DESCRIPTION

This command adds a local distribution to the repository.  Packages in
local distributions always mask packages in foreign distributions.
When a distribution is first added to the repository, the author
becomes the owner of the distribution Thereafter, only the same author
can add a new version of that distribution. [Technically speaking, the
author really owns the *packages* in the distribution, not the
distribution itself.]

=head1 COMMAND ARGUMENTS

The argument to this command is the path to the distribution files that you
wish to add.  This files must exist and must be readable.

=head1 COMMAND OPTIONS

=over 4

=item --author=NAME

Sets your identity as a distribution author.  The C<NAME> can only be
alphanumeric characters only (no spaces) and will be forced to
uppercase.  The default is your username.

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

