
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "HTTP::Body" => 0,
    "HTTP::Response" => 0,
    "IO::String" => 0,
    "Module::Build" => "0.3601",
    "Test::Mock::LWP::Dispatch" => 0,
    "Test::More" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Interact with a remote Pinto repository",
  "dist_author" => [
    "Jeffrey Ryan Thalhammer <jeff\@imaginative-software.com>"
  ],
  "dist_name" => "Pinto-Remote",
  "dist_version" => "0.047",
  "license" => "perl",
  "module_name" => "Pinto::Remote",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "File::Temp" => 0,
    "File::Which" => 0,
    "HTTP::Request::Common" => 0,
    "JSON" => 0,
    "LWP::UserAgent" => 0,
    "Log::Dispatch" => 0,
    "Moose" => 0,
    "MooseX::Types::Moose" => 0,
    "Pinto::Constants" => 0,
    "Pinto::Exception" => 0,
    "Pinto::Types" => 0,
    "URI" => 0,
    "namespace::autoclean" => 0,
    "perl" => "5.006"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
