package App::Pinto::Remote::Command::nop;

# ABSTRACT: check if a remote Pinto repository is alive

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.038'; # VERSION

#-------------------------------------------------------------------------------

sub command_names { return qw(nop ping) }

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed') if @{ $args };

    return 1;
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::nop - check if a remote Pinto repository is alive

=head1 VERSION

version 0.038

=head1 SYNOPSIS

  pinto-remote --root=URL nop

=head1 DESCRIPTION

This command checks that a remote L<Pinto::Server> is alive and
currently able to get a lock on the repository.

=head1 COMMAND ARGUMENTS

None.

=head1 COMMAND OPTIONS

None.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

