package App::Pinto::Remote::Command::pin;

# ABSTRACT: force a package into the index

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.034'; # VERSION

#-------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'message|m=s' => 'Prepend a message to the VCS log' ],
        [ 'tag=s'       => 'Specify a VCS tag name' ],
    );
}

#-------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    return "%c --root=URL $command [OPTIONS] PACKAGE";
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error("Must specify exactly one package") if @{ $args } != 1;

    return 1;
}

#-------------------------------------------------------------------------------

sub execute {
    my ( $self, $opts, $args ) = @_;

    my ($name, $version) = split m/ - /mx, $args->[0], 2;

    $self->pinto->new_batch( %{$opts} );

    $self->pinto->add_action('Pin', %{$opts}, package => $name,
                                              version => $version || 0);
    my $result = $self->pinto->run_actions();
    print $result->to_string();

    return $result->is_success() ? 0 : 1;
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::pin - force a package into the index

=head1 VERSION

version 0.034

=head1 SYNOPSIS

  pinto-remote --root=URL pin [OPTIONS] PACKAGE

=head1 DESCRIPTION

This command pins a package so that it will always appear in the index
even if it is not the latest version, or a newer version is
subsequently mirrored or imported.  You can pin the latest version of
the package, or any arbitrary version of the package.

Only one version of a package can be pinned at any one time.  If you
pin C<Foo::Bar−1.0>, and then later pin C<Foo::Bar−2.0>, then
C<Foo::Bar−1.0> immediately becomes unpinned.

To directly unpin a package, so that the latest version appears in the
index, please see the C<unpin> command.

=head1 COMMAND ARGUMENTS

To pin the latest version of a particular package, just give the name
of the package.  For example:

  Foo::Bar

To pin a particular version of a package, append ’−’ and the version
number to the name.  For example:

  Foo::Bar−1.2

=head1 COMMAND OPTIONS

=over 4

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

