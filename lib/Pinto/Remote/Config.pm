package Pinto::Remote::Config;

# ABSTRACT: Internal configuration for Pinto::Remote

use Moose;

use Pinto::Types qw(Uri);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.028'; # VERSION

#------------------------------------------------------------------------------

has repos => (
    is       => 'ro',
    isa      => Uri,
    coerce   => 1,
    required => 1,
);

#------------------------------------------------------------------------------

sub BUILDARGS {
    my ($class, %args) = @_;

    # Add scheme and default port, if the repository URL doesn't
    # already have them.  Gosh, aren't we helpful :)

    $args{repos} = 'http://' . $args{repos}
        if $args{repos} !~ m{^ http:// }mx;

    $args{repos} = $args{repos} . ':3000'
        if $args{repos} !~ m{ :\d+ $}mx;

    return \%args;

}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Config - Internal configuration for Pinto::Remote

=head1 VERSION

version 0.028

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
