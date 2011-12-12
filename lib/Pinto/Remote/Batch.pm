package Pinto::Remote::Batch;

# ABSTRACT: Runs a series of remote actions

use Moose;

use Pinto::Remote::Result;

#-----------------------------------------------------------------------------

our $VERSION = '0.028'; # VERSION

#------------------------------------------------------------------------------
# Moose attributes

has config    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Config',
    required  => 1,
);


has _actions => (
    is       => 'ro',
    isa      => 'ArrayRef[Pinto::Remote::Action]',
    traits   => [ 'Array' ],
    default  => sub { [] },
    handles  => {enqueue => 'push', dequeue => 'shift'},
);


#------------------------------------------------------------------------------

sub run {
    my ($self) = @_;

    my $result = Pinto::Remote::Result->new();

    while ( my $action = $self->dequeue() ) {
        my $response = $action->execute();
        $result->add_exception( $response->content() )
          if not $response->is_success();
    }

    return $result;
}

#-----------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-----------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Batch - Runs a series of remote actions

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
