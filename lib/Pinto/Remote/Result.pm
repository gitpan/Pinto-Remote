package Pinto::Remote::Result;

# ABSTRACT: The result from running a Batch of Actions

use Moose;

use MooseX::Types::Moose qw(Bool);

#use overload ('""' => 'to_string');

#-----------------------------------------------------------------------------

our $VERSION = '0.037'; # VERSION

#------------------------------------------------------------------------------
# Moose attributes

has is_success => (
    is         => 'ro',
    isa        => Bool,
    default    => 0,
);

#-----------------------------------------------------------------------------
# TODO: Not sure if Pinto::Remote::Result needs to accumulate exception
# messages the way Pinto::Result does.  I'm not happy with the whole *Result
# thing anyway.

#sub to_string {
#    my ($self) = @_;
#
#    my $string = join "\n", map { "$_" } $self->exceptions();
#    $string .= "\n" unless $string =~ m/\n $/x;
#
#    return 'EXCEPTIONS';
#}

#-----------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-----------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Result - The result from running a Batch of Actions

=head1 VERSION

version 0.037

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
