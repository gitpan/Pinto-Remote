package Pinto::Remote::Action::Statistics;

# ABSTRACT: Report statistics about a remote repository

use Moose;
use MooseX::Types::Moose qw(Str);

use Carp;

use Pinto::Types qw(IO);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.033'; # VERSION

#------------------------------------------------------------------------------

extends qw(Pinto::Remote::Action);

#------------------------------------------------------------------------------

has out => (
    is      => 'ro',
    isa     => IO,
    coerce  => 1,
    default => sub { [fileno(STDOUT), '>'] },
);


has format => (
    is       => 'ro',
    isa      => Str,
    default  => '',
);

#------------------------------------------------------------------------------

override execute => sub {
    my ($self) = @_;

    my @format = $self->format() ? ( format => $self->format() ) : ();

    my %ua_args = (

        Content_Type => 'form-data',

        Content => [

            format        => $self->format(),
        ],
   );

    my $response = $self->post('statistics', %ua_args);
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

Pinto::Remote::Action::Statistics - Report statistics about a remote repository

=head1 VERSION

version 0.033

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

