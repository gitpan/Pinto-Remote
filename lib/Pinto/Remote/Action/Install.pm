# ABSTRACT: Install packages from the repository

package Pinto::Remote::Action::Install;

use Moose;
use MooseX::Types::Moose qw(Undef Bool HashRef ArrayRef Maybe Str);

use File::Temp;
use File::Which qw(which);

use Pinto::Exception qw(throw);

use namespace::autoclean;

#------------------------------------------------------------------------------

our $VERSION = '0.046'; # VERSION

#------------------------------------------------------------------------------

extends qw( Pinto::Remote::Action );

#------------------------------------------------------------------------------

has cpanm_options => (
    is      => 'ro',
    isa     => HashRef[Maybe[Str]],
    default => sub { $_[0]->args->{cpanm_options} || {} },
    lazy    => 1,
);


has cpanm_exe => (
    is      => 'ro',
    isa     => Str,
    default => sub { which('cpanm') || throw 'Could not find cpanm in PATH' },
    lazy    => 1,
);


has targets => (
    isa      => ArrayRef[Str],
    traits   => [ 'Array' ],
    handles  => { targets => 'elements' },
    default  => sub { $_[0]->args->{targets} || [] },
);


has pull => (
    is       => 'ro',
    isa      => Bool,
    default  => sub { $_[0]->args->{pull} || 0 },
);

#------------------------------------------------------------------------------

sub BUILD {
    my ($self) = @_;

    my $cpanm_exe = $self->cpanm_exe;

    my $cpanm_version_cmd = "$cpanm_exe --version";
    my $cpanm_version_cmd_output = qx{$cpanm_version_cmd};  ## no critic qw(Backtick)
    throw "Could not learn version of cpanm: $!" if $?;

    my ($cpanm_version) = $cpanm_version_cmd_output =~ m{version \s+ ([\d.]+)}x
      or throw "Could not parse cpanm version number from $cpanm_version_cmd_output";

    my $min_cpanm_version = '1.5013';
    if ($cpanm_version < $min_cpanm_version) {
      throw "Your cpanm ($cpanm_version) is too old. Must have $min_cpanm_version or newer";
    }

    return $self;
}

#------------------------------------------------------------------------------

override execute => sub {
    my ($self) = @_;

    $self->_do_pull if $self->pull;
    my $index  = $self->_fetch_index;
    my $result = $self->_install($index);

    return $result;
 };

#------------------------------------------------------------------------------

sub _do_pull {
    my ($self) = @_;


    my $request = $self->_make_request(name => 'pull');
    my $result  = $self->_send_request(req => $request);

    throw 'Failed to pull packages' if not $result->was_successful;

    return $self;
}

#------------------------------------------------------------------------------

sub _fetch_index {
    my ($self) = @_;

    my $index   = File::Temp->new;
    my $request = $self->_make_request(name => 'index');
    my $result  = $self->_send_request(req => $request, out => $index);

    throw 'Failed to fetch the index' if not $result->was_successful;

    return $index;
}

#------------------------------------------------------------------------------

sub _install {
    my ($self, $index) = @_;

    # Wire cpanm to the index
    my $opts = $self->cpanm_options;
    $opts->{'mirror-index'} = $index->filename;
    $opts->{mirror}         = $self->config->root->as_string;

    # Process other cpanm options
    my @cpanm_opts;
    for my $opt ( keys %{ $opts } ){
        my $dashes = (length $opt == 1) ? '-' : '--';
        my $dashed_opt = $dashes . $opt;
        my $opt_value = $opts->{$opt};
        push @cpanm_opts, $dashed_opt;
        push @cpanm_opts, $opt_value if defined $opt_value && length $opt_value;
    }

    # Run cpanm
    $self->debug(join ' ', 'Running:', $self->cpanm_exe, @cpanm_opts);
    0 == system($self->cpanm_exe, @cpanm_opts, $self->targets)
      or throw "Installation failed.  See the cpanm build log for details";

    return Pinto::Remote::Result->new(was_successful => 1);
}

#------------------------------------------------------------------------------

__PACKAGE__->meta->make_immutable;

#-----------------------------------------------------------------------------
1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

Pinto::Remote::Action::Install - Install packages from the repository

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


