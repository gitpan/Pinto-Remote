package App::Pinto::Remote::Command::list;

# ABSTRACT: list the contents of a remote Pinto repository

use strict;
use warnings;

use Readonly;
use List::MoreUtils qw(none);

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.017'; # VERSION

#-------------------------------------------------------------------------------
# TODO: refactor constants to the Common dist.

Readonly my @LIST_TYPES => qw(local foreign conflicts all);
Readonly my $LIST_TYPES_STRING => join ' | ', sort @LIST_TYPES;
Readonly my $DEFAULT_LIST_TYPE => 'all';

#-------------------------------------------------------------------------------

sub opt_spec {

    return (
        [ 'type=s'  => "One of: ( $LIST_TYPES_STRING )"],
    );
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed') if @{ $args };

    $opts->{type} ||= $DEFAULT_LIST_TYPE;
    $self->usage_error('Invalid type') if none { $opts->{type} eq $_ } @LIST_TYPES;

    return 1;
}

#-------------------------------------------------------------------------------

sub execute {
    my ( $self, $opts, $args ) = @_;
    my $result = $self->pinto_remote()->list( %{$opts} );
    print $result->content(), "\n";
    return not $result->status();
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::list - list the contents of a remote Pinto repository

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
