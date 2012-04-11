package App::Pinto::Remote::Command::list;

# ABSTRACT: list the contents of the remote repository

use strict;
use warnings;

use base qw(App::Pinto::Remote::Command);

#-------------------------------------------------------------------------------

our $VERSION = '0.038'; # VERSION

#-------------------------------------------------------------------------------

sub command_names { return qw( list ls ) }

#-------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'distributions|D=s'  => 'Limit to matching distribution paths'],
        [ 'format=s'           => 'Format specification (see documentation)'],
        [ 'packages|P=s'       => 'Limit to matching package names'],
        [ 'pinned'             => 'Limit to pinned packages'],
        [ 'index'              => 'Limit to packages in the index'],
    );
}

#-------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    $self->usage_error('Arguments are not allowed') if @{ $args };

    ## no critic qw(StringyEval)
    ## Double-interpolate, to expand \n, \t, etc.
    $opts->{format} = eval qq{"$opts->{format}"} if $opts->{format};

    return 1;
}

#-------------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote::Command::list - list the contents of the remote repository

=head1 VERSION

version 0.038

=head1 SYNOPSIS

  pinto-remote --root=URL list [OPTIONS]

=head1 DESCRIPTION

This command lists the distributions and packages that are in your
repository.  You also can customize the format and content of the
output.

Note this command never changes the state of your repository.

=head1 COMMAND ARGUMENTS

None.

=head1 COMMAND OPTIONS

=over 4

=item -D=PATTERN

=item --distributions=PATTERN

Limits the listing to records where the distributions path matches
"PATTERN".  Note that "PATTERN" is just a plain string, not a regular
expression.  The "PATTERN" will match if it appears anywhere in the
distribution path.

=item format

Sets the format of the output using C<printf>-style placeholders.
Valid placeholders are:

  Placeholder    Meaning
  -----------------------------------------------------------------------------
  %n             Package name
  %N             Package name-version
  %v             Package version
  %x             Index status:                   (@) = is latest
  %y             Pin status:                     (+) = is pinned
  %m             Distribution maturity:          (d) = developer, (r) = release
  %p             Distribution index path [1]
  %P             Distribution physical path [2]
  %s             Distribution origin:            (l) = local, (f) = foreign
  %S             Distribution source repository
  %a             Distribution author
  %d             Distribution name
  %D             Distribution name-version
  %w             Distribution version
  %u             Distribution url
  %%             A literal '%'


  [1]: The index path is always a Unix-style path fragment, as it
       appears in the 02packages.details.txt index file.

  [2]: The physical path is always in the native style for this OS,
       and is relative to the root directory of the repository.

You can also specify the minimum field widths and left or right
justification, using the usual notation.  For example, this is what
the default format looks like.

  %x%m%s %-38n %v %p\n

=item --index

Limits the listing to records for packages that are in currently in
the index.  In other words, packages that L<Pinto> thinks are the
"latest".

=item -P=PATTERN

=item --packages=PATTERN

Limits the listing to records where the package name matches
"PATTERN".  Note that "PATTERN" is just a plain string, not a regular
expression.  The "PATTERN" will match if it appears anywhere in the
package name.

=item --pinned

Limits the listing to records where the package has been pinned.

=back

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

