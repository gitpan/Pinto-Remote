package Pinto::Remote;

# ABSTRACT:  Interact with a remote Pinto repository

use Moose;
use MooseX::Types::Moose qw(Str);

use Carp;
use Class::Load;
use LWP::UserAgent;

use Pinto::Remote::Config;
use Pinto::Remote::Logger;
use Pinto::Remote::Batch;

use namespace::autoclean;

#-------------------------------------------------------------------------------

our $VERSION = '0.038'; # VERSION

#------------------------------------------------------------------------------
# Moose attributes

has config    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Config',
    handles   => [ qw(root) ],
    required  => 1,
);


has logger    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Logger',
    handles   => [ qw(debug note info whine fatal) ],
    required  => 1,
);


has ua        => (
    is        => 'ro',
    isa       => 'LWP::UserAgent',
    default   => sub { LWP::UserAgent->new(timeout => 600) },
);


has _batch => (
    is         => 'ro',
    isa        => 'Pinto::Remote::Batch',
    writer     => '_set_batch',
    init_arg   => undef,
);


has _action_base_class => (
    is         => 'ro',
    isa        => Str,
    default    => 'Pinto::Remote::Action',
    init_arg   => undef,
);

#------------------------------------------------------------------------------

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{config} ||= Pinto::Remote::Config->new( %args );
    $args{logger} ||= Pinto::Remote::Logger->new( %args );

    return \%args;
}

#------------------------------------------------------------------------------


sub new_batch {
    my ($self, %args) = @_;

    my $batch = Pinto::Remote::Batch->new( config => $self->config(),
                                           logger => $self->logger(),
                                           %args );
    $self->_set_batch( $batch );

    return $self;
}

#------------------------------------------------------------------------------


sub add_action {
    my ($self, $action_name, %args) = @_;

    my $batch = $self->_batch()
        or confess 'You must create a batch first';

    my $action_class = $self->_action_base_class . "::$action_name";
    Class::Load::load_class($action_class);

    my $action = $action_class->new( config => $self->config(),
                                     logger => $self->logger(),
                                     %args );

    $batch->enqueue($action);

    return $self;
}

#------------------------------------------------------------------------------


sub run_actions {
    my ($self) = @_;

    $self->_batch()
        or confess 'You must create a batch first';

    my $result = $self->_batch->run();

    return $result;
}

#------------------------------------------------------------------------------


sub add_logger {
    my ($self, @args) = @_;

    $self->logger->add_output(@args);

    return $self;
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable();

#-------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems cpan testmatrix url
annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata
placeholders metacpan

=head1 NAME

Pinto::Remote - Interact with a remote Pinto repository

=head1 VERSION

version 0.038

=head1 METHODS

=head2 new_batch( %batch_args )

Prepares this Pinto::Remote to run a new batch of Actions.  Any prior
batch will be discarded.

=head2 add_action( $action_name, %action_args )

Constructs the action with the given names and arguments, and adds it
to the current batch.  You must first call C<new_batch> before you can
add any actions.  The precise class of the Action will be formed by
prepending 'Pinto::Remote::Action::' to the action name.  See the
documentation for the corresponding Action class for a details about
the arguments it supports.

=head2 run_actions()

Executes all the actions that are currently in the batch for this
Pinto::Remote.  Returns a L<Pinto::Remote::Result> object that
indicates whether the batch was successful and contains any warning or
error messages that might have occurred along the way.

=head2 add_logger( $obj )

Convenience method for installing additional endpoints for logging.
The object must be an instance of a L<Log::Dispatch::Output> subclass.

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

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

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
