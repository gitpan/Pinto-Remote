package Pinto::Remote::Response;

# ABSTRACT: Represents the response received from a Pinto::Server

use Moose;

use MooseX::Types::Moose qw(Bool Str);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.001'; # VERSION

#------------------------------------------------------------------------------
# Moose attributes

has status => (
    is       => 'ro',
    isa      => Bool,
    required => 1,
);

has message => (
    is      => 'ro',
    isa     => Str,
);

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Response - Represents the response received from a Pinto::Server

=head1 VERSION

version 0.001

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
