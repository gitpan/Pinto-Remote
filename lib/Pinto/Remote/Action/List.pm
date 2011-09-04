package Pinto::Remote::Action::List;

# ABSTRACT: List the contents of a remote repository

use Moose;

use Carp;
use MooseX::Types::Moose qw(Str);
use Pinto::Types 0.017 qw(IO);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.021'; # VERSION

#------------------------------------------------------------------------------

extends qw(Pinto::Remote::Action);

#------------------------------------------------------------------------------

has out => (
    is      => 'ro',
    isa     => IO,
    coerce  => 1,
    default => sub { [fileno(STDOUT), '>'] },
);


has type => (
    is       => 'ro',
    isa      => Str,
    init_arg => undef,
    default  => sub { croak 'Abstract attribute' },
    lazy     => 1,
);

#------------------------------------------------------------------------------

override execute => sub {
    my ($self) = @_;

    my %ua_args = ( Content => [ type => $self->type() ] );
    my $response = $self->post('list', %ua_args);
    print { $self->out() } $response->content();

    return $response;
};

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::List - List the contents of a remote repository

=head1 VERSION

version 0.021

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

