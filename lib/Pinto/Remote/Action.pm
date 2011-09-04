package Pinto::Remote::Action;

# ABSTRACT: Base class for remote Actions

use Moose;

use Carp;
use LWP::UserAgent;

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.021'; # VERSION

#------------------------------------------------------------------------------

has config    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Config',
    required  => 1,
);

#------------------------------------------------------------------------------

sub execute {
    my ($self) = @_;

    croak 'This is an absract method';
}

#------------------------------------------------------------------------------

sub post {
    my ($self, $name, %args) = @_;

    my $ua       = LWP::UserAgent->new();
    my $url      = $self->config->repos() . "/action/$name";
    my $response = $ua->post($url, %args);

    return $response;
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action - Base class for remote Actions

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
