package App::Pinto::Remote;

# ABSTRACT: Command line driver for Pinto::Remote

use strict;
use warnings;

use Class::Load qw();
use App::Cmd::Setup -app;

#-------------------------------------------------------------------------------

our $VERSION = '0.026'; # VERSION

#-------------------------------------------------------------------------------

sub global_opt_spec {

  return (
      [ "repos|r=s"   => "URL of your Pinto repository server" ],
  );
}

#-------------------------------------------------------------------------------


sub pinto {
    my ($self) = @_;

    return $self->{pinto} ||= do {
        my %global_options = %{ $self->global_options() };

        $global_options{repos}  ||= $ENV{PINTO_REPOSITORY}
            || $self->usage_error('Must specify a repository server');

        my $pinto_class = $self->pinto_class();
        Class::Load::load_class($pinto_class);
        my $pinto = $pinto_class->new(%global_options);
    };
}

#-------------------------------------------------------------------------------

sub pinto_class {  return 'Pinto::Remote' }

#-------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote - Command line driver for Pinto::Remote

=head1 VERSION

version 0.026

=head1 METHODS

=head2 pinto()

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
