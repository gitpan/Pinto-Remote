package App::Pinto::Remote::Command;

# ABSTRACT: Base class for pinto-remote commands

use strict;
use warnings;

#-----------------------------------------------------------------------------

use App::Cmd::Setup -command;

#-----------------------------------------------------------------------------

our $VERSION = '0.017'; # VERSION

#-----------------------------------------------------------------------------


sub pinto_remote {
  my ($self, $options) = @_;
  return $self->app()->pinto_remote($options);
}

#-----------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command - Base class for pinto-remote commands

=head1 VERSION

version 0.017

=head1 METHODS

=head2 pinto_remote( $options )

Returns a reference to a L<Pinto::Remote> object that has been
constructed for this command.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
