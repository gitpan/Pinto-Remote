# ABSTRACT: Report statistics about a remote repository

package Pinto::Remote::Action::Statistics;

use Moose;

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.037'; # VERSION

#------------------------------------------------------------------------------

extends qw( Pinto::Remote::Action );

#------------------------------------------------------------------------------

with qw( Pinto::Interface::Action::Statistics );

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::Statistics - Report statistics about a remote repository

=head1 VERSION

version 0.037

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

