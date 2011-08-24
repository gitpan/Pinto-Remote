package App::Pinto::Remote::Command::add;

# ABSTRACT: add a local distribution to a remote Pinto repository

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.017'; # VERSION

#-------------------------------------------------------------------------------

sub opt_spec {

    return (
        [ "author|a=s" => 'Your author ID (like a PAUSE ID)' ]
    );
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;
    $self->usage_error("Must specify exactly one distribution file") if @{ $args } != 1;
    return 1;
}

#-------------------------------------------------------------------------------

sub execute {
    my ( $self, $opts, $args ) = @_;
    my $result = $self->pinto_remote->add( %{$opts}, dist => $args->[0] );
    print $result->content(), "\n";
    return not $result->status();
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::add - add a local distribution to a remote Pinto repository

=head1 VERSION

version 0.017

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
