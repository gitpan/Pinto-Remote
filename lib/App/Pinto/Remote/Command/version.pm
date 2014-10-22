package App::Pinto::Remote::Command::version;

# ABSTRACT: show version information

use strict;
use warnings;

use Class::Load qw();

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.039'; # VERSION

#-------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    return "%c $command"
}

#-------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $app_class = ref $self->app();
    my $app_version = $self->app->VERSION();
    printf "$app_class $app_version\n";

    my $pinto_class = $self->app->pinto_class();
    Class::Load::load_class( $pinto_class );
    my $pinto_version = $pinto_class->VERSION();
    printf "$pinto_class $pinto_version\n";

    return 0;
}

#-------------------------------------------------------------------------------


1;


__END__
=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::version - show version information

=head1 VERSION

version 0.039

=head1 DESCRIPTION

This command simply displays some version information about this application.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

