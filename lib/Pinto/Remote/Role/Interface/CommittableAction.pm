# ABSTRACT: Interface for Actions that make committable changes

package Pinto::Remote::Role::Interface::CommittableAction;

use Moose::Role;

use MooseX::Types::Moose qw(Str);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.038'; # VERSION

#------------------------------------------------------------------------------

with qw( Pinto::Meta::Attribute::Trait::Postable );

#------------------------------------------------------------------------------

has message => (
    is      => 'ro',
    isa     => Str,
    traits  => [ qw(Postable) ],
);


has tag => (
    is      => 'ro',
    isa     => Str,
    traits  => [ qw(Postable) ],
);

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Role::Interface::CommittableAction - Interface for Actions that make committable changes

=head1 VERSION

version 0.038

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
