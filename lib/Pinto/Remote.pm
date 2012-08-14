# ABSTRACT:  Interact with a remote Pinto repository

package Pinto::Remote;

use Moose;
use MooseX::Types::Moose qw(Str);

use LWP::UserAgent;

use Pinto::Remote::Config;
use Pinto::Remote::Logger;
use Pinto::Remote::Action;

use namespace::autoclean;

#-------------------------------------------------------------------------------

our $VERSION = '0.046'; # VERSION

#------------------------------------------------------------------------------

has ua    => (
    is        => 'ro',
    isa       => 'LWP::UserAgent',
    default   => sub { LWP::UserAgent->new( agent => $_[0]->ua_name) },
    lazy      => 1,
);


has ua_name => (
    is      => 'ro',
    isa     => Str,
    default => sub { sprintf '%s/%s', ref $_[0], $_[0]->VERSION || '??' },
    lazy    => 1,
);


has config    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Config',
    handles   => [ qw(root) ],
    required  => 1,
);


has logger    => (
    is        => 'ro',
    isa       => 'Pinto::Remote::Logger',
    handles   => [ qw(debug info notice warning fatal) ],
    required  => 1,
);


#------------------------------------------------------------------------------

sub BUILDARGS {
    my ($class, %args) = @_;

    $args{config} ||= Pinto::Remote::Config->new( %args );
    $args{logger} ||= Pinto::Remote::Logger->new( %args );

    return \%args;
}

#------------------------------------------------------------------------------


sub run {
    my ($self, $action_name, @args) = @_;

    my $action_baseclass = __PACKAGE__ . '::Action';
    my $action_subclass  = __PACKAGE__ . '::Action::' . $action_name;

    my $subclass_did_load = Class::Load::try_load_class($action_subclass);
    my $action_class = $subclass_did_load ? $action_subclass : $action_baseclass;

    my $action_args = (@args == 1 and ref $args[0] eq 'HASH') ? $args[0] : {@args};

    my $action = $action_class->new( name   => $action_name,
                                     args   => $action_args,
                                     config => $self->config,
                                     logger => $self->logger,
                                     ua     => $self->ua );

    return $action->execute;
}

#------------------------------------------------------------------------------


sub add_logger {
    my ($self, @args) = @_;

    $self->logger->add_output(@args);

    return $self;
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

#-------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems cpan testmatrix url
annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata
placeholders metacpan

=head1 NAME

Pinto::Remote - Interact with a remote Pinto repository

=head1 VERSION

version 0.046

=head1 SYNOPSIS

See L<pinto> to create and manage a Pinto repository.

See L<pintod> to allow remote access to your Pinto repository.

See L<Pinto::Manual> for more information about the Pinto tools.

=head1 DESCRIPTION

Pinto::Remote is the cousin of L<Pinto>.  It provides the same API,
but instead of running Actions against a local repository, it just
sends the Action parameters to a L<pintod> server that invokes Pinto
on the remote host.

If you are using the L<pinto> application, it will automatically load
either Pinto or Pinto::Remote depending on whether your repository
root looks like a local directory path or a remote URL.

=head1 METHODS

=head2 run( $action_name => %action_args )

Loads the Action subclass for the given C<$action_name> and constructs
an object using the given C<$action_args>.  If the subclass
C<Pinto::Remote::Action::$action_name> does not exist, then it falls
back to the L<Pinto::Remote::Action> base class.

=head2 add_logger( $obj )

Convenience method for installing additional logging endpoints.
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

