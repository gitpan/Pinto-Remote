package App::Pinto::Remote;

# ABSTRACT: Command line driver for Pinto::Remote

use strict;
use warnings;

use Encode;
use Term::Prompt;

use Class::Load;

use List::Util qw(max);
use Log::Dispatch::Screen;
use Log::Dispatch::Screen::Color;

use Pinto::Constants qw(:all);

use App::Cmd::Setup -app;

#-------------------------------------------------------------------------------

our $VERSION = '0.039'; # VERSION

#-------------------------------------------------------------------------------

sub global_opt_spec {

  return (
      [ 'root|r=s'            => 'Root URL of your Pinto repository'         ],
      [ 'username|user|u=s'   => 'Username to use for server authentication' ],
      [ 'password|passwd|p=s' => 'Password to use for server authentication' ],
      [ 'nocolor'             => 'Do not colorize diagnostic messages'       ],
      [ 'quiet|q'             => 'Only report fatal errors'                  ],
      [ 'verbose|v+'          => 'More diagnostic output (repeatable)'       ],

  );
}

#-------------------------------------------------------------------------------


sub pinto {
    my ($self) = @_;

    return $self->{pinto} ||= do {
        my %global_options = %{ $self->global_options() };

        $global_options{root} ||= $ENV{PINTO_REPOSITORY_ROOT}
                                  || $PINTO_SERVER_DEFAULT_ROOT;

        $global_options{password} = $self->_prompt_for_password()
            if defined $global_options{password} and $global_options{password} eq '-';


        my $verbose = delete $global_options{verbose} || 0;
        $global_options{log_level} = max(2 - $verbose, 0);
        $global_options{log_level} = 4 if delete $global_options{quiet};

        my $pinto_class = $self->pinto_class();
        Class::Load::load_class($pinto_class);

        my $pinto = $pinto_class->new(%global_options, log_level=>'debug');
        $pinto->add_logger($self->_make_logger(%global_options));

        $pinto;
    };
}


#-------------------------------------------------------------------------------

sub _make_logger {
    my ($self, %options) = @_;

    my $log_level = $options{log_level};
    my $nocolor   = $options{nocolor};
    my $colors    = $nocolor ? {} : ($self->_log_colors);
    my $log_class = 'Log::Dispatch::Screen';
    $log_class   .= '::Color' unless $nocolor;

    return $log_class->new( min_level => $log_level,
                            color     => $colors,
                            stderr    => 1,
                            newline   => 1 );
}

#-------------------------------------------------------------------------------

sub _prompt_for_password {
   my ($self) = @_;

   my $input    = Term::Prompt::prompt('p', 'Password:', '', '');
   my $password = Encode::decode_utf8($input);
   print "\n"; # Get on a new line

   return $password;
}

#------------------------------------------------------------------------------

sub _log_colors {
    my ($self) = @_;

    # TODO: Create command line options for controlling colors and
    # process them here.

    return $self->_default_log_colors;
}

#------------------------------------------------------------------------------

sub _default_log_colors { return $PINTO_DEFAULT_LOG_COLORS }

#-------------------------------------------------------------------------------


sub pinto_class { return 'Pinto::Remote' }

#-------------------------------------------------------------------------------

1;



=pod

=for :stopwords Jeffrey Ryan Thalhammer Imaginative Software Systems

=head1 NAME

App::Pinto::Remote - Command line driver for Pinto::Remote

=head1 VERSION

version 0.039

=head1 METHODS

=head2 pinto()

Returns a reference to a L<Pinto::Remote> object that has been
constructed for this application.

=head2 pinto_class()

Returns the name of the underlying Pinto engine that is being used for
this application.

=head1 AUTHOR

Jeffrey Ryan Thalhammer <jeff@imaginative-software.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Imaginative Software Systems.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
