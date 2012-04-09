#!perl

use strict;
use warnings;

use Test::More;
use Test::Mock::LWP::Dispatch;

use IO::String;
use HTTP::Response;

use Pinto::Remote;
use Pinto::Constants qw(:all);


#-----------------------------------------------------------------------------
# Shorthand...

my $PROLOGUE = "$PINTO_SERVER_RESPONSE_PROLOGUE\n";
my $EPILOGUE = "$PINTO_SERVER_RESPONSE_EPILOGUE\n";

#-----------------------------------------------------------------------------

my $res;
$mock_ua->map( sub{ return 1 }, sub { return $res } );

#-----------------------------------------------------------------------------
# Test a typical action response

{

  local $TODO = 'Make these tests work with a mock UA';

  $res = HTTP::Response->new(200);
  $res->content( "$PROLOGUE\nDATA-GOES-HERE\n$EPILOGUE" );

  my $buffer = '';
  my $out    = IO::String->new(\$buffer);
  my $pinto  = Pinto::Remote->new(root => 'localhost');
  my $result = $pinto->new_batch->add_action('List', out => $out)->run_actions;

  is $result->is_success, 1,
      'Got successful result' or diag $buffer;

  is $buffer, "DATA-GOES-HERE\n",
      'Got correct output, without EPILOGUE and PROLOGUE';
}

#-----------------------------------------------------------------------------
done_testing();
