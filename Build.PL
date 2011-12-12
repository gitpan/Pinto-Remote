
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Interact with a remote Pinto repository",
  "dist_author" => [
    "Jeffrey Ryan Thalhammer <jeff\@imaginative-software.com>"
  ],
  "dist_name" => "Pinto-Remote",
  "dist_version" => "0.028",
  "license" => "perl",
  "module_name" => "Pinto::Remote",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "App::Cmd::Setup" => 0,
    "Carp" => 0,
    "Class::Load" => 0,
    "LWP::UserAgent" => 0,
    "Moose" => 0,
    "MooseX::Types::Moose" => 0,
    "Pinto::Interface::Authorable" => 0,
    "Pinto::Types" => 0,
    "Pod::Usage" => 0,
    "base" => 0,
    "namespace::autoclean" => 0,
    "overload" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "version" => 0,
    "warnings" => 0
  },
  "script_files" => [
    "bin/pinto-remote"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
