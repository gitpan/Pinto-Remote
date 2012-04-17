package Pinto::Remote::Config;

# ABSTRACT: Internal configuration for Pinto::Remote

use Moose;
use MooseX::Types::Moose qw(Maybe Str);

use URI;

use Pinto::Types qw(Uri);
use Pinto::Constants qw($PINTO_SERVER_DEFAULT_ROOT $PINTO_SERVER_DEFAULT_PORT);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.039'; # VERSION

#------------------------------------------------------------------------------

has root => (
    is       => 'ro',
    isa      => Uri,
    coerce   => 1,
    default  => sub { URI->new($PINTO_SERVER_DEFAULT_ROOT) },
);


has username => (
    is      => 'ro',
    isa     => Str,
    default => sub { $ENV{USER} },
);


has password => (
    is      => 'ro',
    isa     => Maybe[Str],
);

#------------------------------------------------------------------------------

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my $args = $class->$orig(@_);

    # Add scheme and default port, if the repository root URL doesn't
    # already have them.  Gosh, aren't we helpful :)

    $args->{root} = 'http://' . $args->{root}
        if defined $args->{root} && $args->{root} !~ m{^ https?:// }mx;

    $args->{root} = $args->{root} . ':' . $PINTO_SERVER_DEFAULT_PORT
        if defined $args->{root} && $args->{root} !~ m{ :\d+ $}mx;

    return $args;
};

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Config - Internal configuration for Pinto::Remote

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
