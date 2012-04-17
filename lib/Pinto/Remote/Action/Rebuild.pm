# ABSTRACT: Rebuild the index file for the repository

package Pinto::Remote::Action::Rebuild;

use Moose;

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.039'; # VERSION

#------------------------------------------------------------------------------

extends qw( Pinto::Remote::Action );

#------------------------------------------------------------------------------

with qw( Pinto::Role::Interface::Action::Rebuild
         Pinto::Remote::Role::Interface::CommittableAction );

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::Rebuild - Rebuild the index file for the repository

=head1 VERSION

version 0.039

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
