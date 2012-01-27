package Pinto::Remote::Action::Pin;

# ABSTRACT: Force a package into the index

use Moose;

use MooseX::Types::Moose qw(Str);
use Pinto::Types qw(Vers);

use version;
use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.030'; # VERSION

#------------------------------------------------------------------------------

extends qw(Pinto::Remote::Action);

#------------------------------------------------------------------------------

has package  => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);


has version  => (
    is       => 'ro',
    isa      => Vers,
    default  => 0,
    coerce   => 1,
);


has message => (
    is      => 'ro',
    isa     => Str,
);


has tag => (
    is      => 'ro',
    isa     => Str,
);

#------------------------------------------------------------------------------

override execute => sub {
    my ($self) = @_;

    my %ua_args = (

        Content_Type => 'form-data',

        Content => [

            package   => $self->package(),
            version   => $self->version->stringify(),
            message   => $self->message(),
            tag       => $self->tag(),
        ],
    );

    return $self->post('pin', %ua_args);
};

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::Pin - Force a package into the index

=head1 VERSION

version 0.030

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
