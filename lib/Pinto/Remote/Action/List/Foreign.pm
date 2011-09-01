package Pinto::Remote::Action::List::Foreign;

# ABSTRACT: List the foreign contents of a remote Pinto repository

use Moose;

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.020'; # VERSION

#------------------------------------------------------------------------------

extends qw(Pinto::Remote::Action::List);

#------------------------------------------------------------------------------

has '+type' => (
    default => 'Foreign',
);

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::List::Foreign - List the foreign contents of a remote Pinto repository

=head1 VERSION

version 0.020

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

