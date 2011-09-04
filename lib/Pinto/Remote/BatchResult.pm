package Pinto::Remote::BatchResult;

# ABSTRACT: Accumulates exceptions and status from a batch of actions

use Moose;

use MooseX::Types::Moose qw(Bool ArrayRef);

use overload ('""' => 'to_string');

#-----------------------------------------------------------------------------

our $VERSION = '0.021'; # VERSION

#------------------------------------------------------------------------------
# Moose attributes

has exceptions => (
    is         => 'ro',
    isa        => ArrayRef,
    traits     => [ 'Array' ],
    default    => sub { [] },
    handles    => {add_exception => 'push'},
    init_arg   => undef,
    auto_deref => 1,
);

#-----------------------------------------------------------------------------
# TODO: Should we have an "ActionResult" to go with our "BatchResult" too?

sub is_success {
    my ($self) = @_;

    return @{ $self->exceptions } == 0;
}

#-----------------------------------------------------------------------------

sub to_string {
    my ($self) = @_;

    my $string = join "\n", map { "$_" } $self->exceptions();
    $string .= "\n" unless $string =~ m/\n $/x;

    return $string;
}

#-----------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-----------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::BatchResult - Accumulates exceptions and status from a batch of actions

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