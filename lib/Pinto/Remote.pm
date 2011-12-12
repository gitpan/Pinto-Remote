package Pinto::Remote;

# ABSTRACT:  Interact with a remote Pinto repository

use Moose;

use Carp;
use Class::Load;

use Pinto::Remote::Config;
use Pinto::Remote::Batch;

use namespace::autoclean;

#-------------------------------------------------------------------------------

our $VERSION = '0.028'; # VERSION

#------------------------------------------------------------------------------
# Moose attributes

has config    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Config',
    required  => 1,
);


has _batch => (
    is         => 'ro',
    isa        => 'Pinto::Remote::Batch',
    writer     => '_set_batch',
    init_arg   => undef,
);

#------------------------------------------------------------------------------

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{config} ||= Pinto::Remote::Config->new( %args );

    return \%args;
}

#------------------------------------------------------------------------------

sub new_batch {
    my ($self, %args) = @_;

    my $batch = Pinto::Remote::Batch->new( config => $self->config(),
                                           %args );
    $self->_set_batch( $batch );

    return $self;
}

#------------------------------------------------------------------------------

sub add_action {
    my ($self, $action_name, %args) = @_;

    my $action_class = "Pinto::Remote::Action::$action_name";

    eval { Class::Load::load_class($action_class); 1 }
        or croak "Unable to load action class $action_class: $@";

    my $action = $action_class->new( config => $self->config(),
                                     %args );

    $self->_batch->enqueue($action);

    return $self;
}

#------------------------------------------------------------------------------

sub run_actions {
    my ($self) = @_;

    $self->_batch() or croak 'You must create a batch first';

    return $self->_batch->run();
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems cpan testmatrix url
annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata
placeholders

=head1 NAME

Pinto::Remote - Interact with a remote Pinto repository

=head1 VERSION

version 0.028

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Pinto::Remote

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/Pinto-Remote>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/Pinto-Remote>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/P/Pinto-Remote>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual way to determine what Perls/platforms PASSed for a distribution.

L<http://matrix.cpantesters.org/?dist=Pinto-Remote>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=Pinto::Remote>

=back

=head2 Bugs / Feature Requests

L<https://github.com/thaljef/Pinto-Remote/issues>

=head2 Source Code


L<https://github.com/thaljef/Pinto-Remote>

  git clone git://github.com/thaljef/Pinto-Remote.git

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
