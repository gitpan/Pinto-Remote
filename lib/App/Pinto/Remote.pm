package App::Pinto::Remote;

# ABSTRACT: Command line driver for Pinto::Remote

use strict;
use warnings;

use App::Cmd::Setup -app;

#-------------------------------------------------------------------------------

our $VERSION = '0.001'; # VERSION

#-------------------------------------------------------------------------------

sub global_opt_spec {

  return (
      [ "host|H=s"   => "URL of your Pinto server (including port)" ],
  );
}

#-------------------------------------------------------------------------------


sub pinto_remote {
    my ($self, $command_options) = @_;

    require Pinto::Remote;
    require Pinto::Remote::Config;

    return $self->{pinto_remote} ||= do {
        my %global_options = %{ $self->global_options() };
        my $config = Pinto::Remote::Config->new(%global_options, %{$command_options});
        my $pinto_remote = Pinto::Remote->new(config => $config);
    };
}


1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote - Command line driver for Pinto::Remote

=head1 VERSION

version 0.001

=head1 METHODS

=head2 pinto_remote( $options )

Returns a reference to a L<Pinto::Remote> object that has been
constructed for this application.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
