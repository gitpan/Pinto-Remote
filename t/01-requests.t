#!perl

use strict;
use warnings;

use Test::More;
use Test::Mock::LWP::Dispatch;

use HTTP::Response;
use HTTP::Body;

use Pinto::Remote;

#-----------------------------------------------------------------------------

my $req;
my $res = HTTP::Response->new(200);
$mock_ua->map( sub{ return 1 }, sub { $req = shift; HTTP::Response->new(200) } );

#-----------------------------------------------------------------------------
# Test a typical action...

{

  my %params = (packages => 'P', distributions => 'D', index => '1', pinned => '1');
  my $pinto = Pinto::Remote->new(root => 'myhost', ua => $mock_ua);
  $pinto->new_batch->add_action('List', %params);
  $pinto->run_actions;

  is $req->method,  'POST',
      'Correct HTTP method in request';

  is $req->uri,     'http://myhost:3111/action/list',
      'Correct uri in request';

  is_deeply parse_req_params($req), \%params,
      'Correct params in request';

}


#-----------------------------------------------------------------------------
# Test a committable action...

{

  my %params = (message => 'M', tag => 'T');
  my $pinto = Pinto::Remote->new(root => 'myhost', ua => $mock_ua);
  $pinto->new_batch->add_action('Clean', %params);
  $pinto->run_actions;

  is $req->method,  'POST',
      'Correct HTTP method in request';

  is $req->uri,     'http://myhost:3111/action/clean',
      'Correct uri in request';

  is_deeply parse_req_params($req), \%params,
      'Correct params in request';

}

#-----------------------------------------------------------------------------

sub parse_req_params {
    my ($req) = @_;
    my $type = $req->headers->header('Content-Type');
    my $length = $req->headers->header('Content-Length');
    my $hb = HTTP::Body->new($type, $length);
    $hb->add($req->content);
    return $hb->param;
}

#-----------------------------------------------------------------------------

done_testing();
