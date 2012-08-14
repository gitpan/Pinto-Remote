#!perl

use strict;
use warnings;

use Test::More;
use Test::Mock::LWP::Dispatch;

use JSON;
use HTTP::Body;
use HTTP::Response;
use LWP::UserAgent;
use File::Temp;

use Pinto::Remote;

#-----------------------------------------------------------------------------

my $req;
my $res = HTTP::Response->new(200);
my $ua = LWP::UserAgent->new; # will be mocked
$ua->map( sub{ return 1 }, sub { $req = shift; HTTP::Response->new(200) } );

#-----------------------------------------------------------------------------

{
  my $action = 'List';
  my %given_action_args = (packages => 'P', distributions => 'D', index => '1', pinned => '1');
  my $pinto = Pinto::Remote->new(root => 'myhost', ua => $ua);
  $pinto->run($action, %given_action_args);

  is $req->method, 'POST',
      "Correct HTTP method in request for action $action";

  is $req->uri, 'http://myhost:3111/action/list',
      "Correct uri in request for action $action";

  my $req_params = parse_req_params($req);
  my $got_action_args = decode_json($req_params->{action_args});

  is_deeply $got_action_args, \%given_action_args,
      "Correct action args in request for action $action";

  my $got_pinto_args  = decode_json($req_params->{pinto_args});
  my $expected_default_pinto_args = {username => $ENV{USER}, log_level => 'warning'};

  is_deeply $got_pinto_args, $expected_default_pinto_args,
      "Correct default pinto args in request for action $action";
}

#-----------------------------------------------------------------------------

{

  my $action = 'Add';
  my $temp = File::Temp->new;
  my %given_pinto_args  = (username => 'myname', log_level => 'debug');
  my %given_action_args = (archives => [$temp->filename], author => 'ME', stack => 'mystack');
  my $pinto = Pinto::Remote->new(root => 'myhost', ua => $ua, %given_pinto_args);
  $pinto->run($action, %given_action_args);

  is $req->method, 'POST',
      "Correct HTTP method in request for action $action";

  is $req->uri, 'http://myhost:3111/action/add',
      "Correct uri in request for action $action";

  my $req_params = parse_req_params($req);
  my $got_action_args = decode_json($req_params->{action_args});
  my $got_pinto_args  = decode_json($req_params->{pinto_args});

  is_deeply $got_action_args, \%given_action_args,
      "Correct action args in request for action $action";

  is_deeply $got_pinto_args, \%given_pinto_args,
      "Correct pinto args in request for action $action";
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

done_testing;
