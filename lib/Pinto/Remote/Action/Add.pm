# ABSTRACT: Add a distribution to a the repository

package Pinto::Remote::Action::Add;

use Moose;

use JSON;
use Pinto::Exception qw(throw);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.046'; # VERSION

#------------------------------------------------------------------------------

extends qw( Pinto::Remote::Action );

#------------------------------------------------------------------------------

sub BUILD {
    my ($self) = @_;

    throw 'Only one archive can be remotely added at a time'
      if @{ $self->args->{archives} || [] } > 1;

    return $self;
}

#------------------------------------------------------------------------------

override _as_post_data => sub {
    my ($self) = @_;

    my $form_data = super;
    my $archive = (delete $self->args->{archives})->[0];
    push @{ $form_data }, (archives => [$archive]);

    return $form_data;
};

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

#------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::Add - Add a distribution to a the repository

=head1 VERSION

version 0.046

=for Pod::Coverage BUILD

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__


