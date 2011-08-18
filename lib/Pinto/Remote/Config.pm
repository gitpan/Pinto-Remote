package Pinto::Remote::Config;

# ABSTRACT: Configuration for Pinto::Remote

use Moose;

use Pinto::Types qw(URI);

extends qw(Pinto::Config);

use namespace::autoclean;

#-------------------------------------------------------------------------------

our $VERSION = '0.001'; # VERSION

#-------------------------------------------------------------------------------

has 'host'  => (
    is        => 'ro',
    isa       => URI,
    key       => 'host',
    #section  => 'Pinto::Remote', ??
    required  => 1,
    coerce    => 1,
);

#-------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Config - Configuration for Pinto::Remote

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

