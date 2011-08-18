package Pinto::Remote;

# ABSTRACT:  Interact with a remote Pinto repository

use Moose;

use LWP::UserAgent;

use MooseX::Types::Moose qw(Str);
use Pinto::Types qw(URI AuthorID);

use Pinto::Remote::Response;

use namespace::autoclean;

#-------------------------------------------------------------------------------

our $VERSION = '0.001'; # VERSION

#-------------------------------------------------------------------------------

with qw(Pinto::Role::Configurable);

#-------------------------------------------------------------------------------


sub add {
  my ($self, %args) = @_;
  my $dist   = $args{dist};
  my $author = $args{author} || $self->config->author();

  my %ua_args = (
           Content_Type => 'form-data',
           Content      => [ author => $author, dist => [$dist], ],
  );

  return $self->_post('add', %ua_args);

}

#-------------------------------------------------------------------------------


sub remove {
  my ($self, %args) = @_;
  my $pkg    = $args{package};
  my $author = $args{author} || $self->config->author();

  my %ua_args = (
           Content => [ author => $author, package => $pkg, ],
  );

  return $self->_post('remove', %ua_args);
}

#-------------------------------------------------------------------------------



sub list {
  my ($self, %args) = @_;
  return $self->_post('list', ());
}

#-------------------------------------------------------------------------------

sub _post {
  my ($self, $action, %args) = @_;
  my $ua = LWP::UserAgent->new();
  my $url = $self->config->host() . "/$action";
  my $response = $ua->post($url, %args);

  return Pinto::Remote::Response->new( status  => $response->is_success(),
                                       message => $response->content() );
}

#-------------------------------------------------------------------------------

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

version 0.001

=head1 METHODS

=head2 add( dist => 'SomeDist-1.2.tar.gz' )

Adds the specified distribution to the remote Pinto repository.  Returns
a L<Pinto::Remote::Response> that contains the status and diagnostic
messages from the server.

=head2 remove( package => 'Some::Package' )

Removes the specified package from the remote Pinto repository.  Returns
a L<Pinto::Remote::Response> that contains the status and diagnostic
messages from the server.

=head2 list()

Returns a L<Pinto::Remote::Response> that contains a list of all the
packages and distributions that are currently indexed in the remote
repository.

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

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Pinto-Remote>

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

Please report any bugs or feature requests by email to C<bug-pinto-remote at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Pinto-Remote>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code


L<https://github.com/thaljef/Pinto-Remote>

  git clone https://github.com/thaljef/Pinto-Remote

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
