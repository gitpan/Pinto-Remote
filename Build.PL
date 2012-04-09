
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "File::Temp" => 0,
    "HTTP::Body" => 0,
    "HTTP::Response" => 0,
    "IO::String" => 0,
    "Module::Build" => "0.3601",
    "Test::Mock::LWP::Dispatch" => 0,
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
  "dist_version" => "0.037",
  "license" => "perl",
  "module_name" => "Pinto::Remote",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "App::Cmd::Setup" => 0,
    "Carp" => 0,
    "Class::Load" => 0,
    "Encode" => 0,
    "HTTP::Request::Common" => 0,
    "LWP::UserAgent" => 0,
    "List::Util" => 0,
    "Log::Dispatch" => 0,
    "Log::Dispatch::Screen" => 0,
    "Log::Dispatch::Screen::Color" => 0,
    "Moose" => 0,
    "Moose::Role" => 0,
    "MooseX::Types::Moose" => 0,
    "Pinto::Constants" => 0,
    "Pinto::Interface::Action::List" => 0,
    "Pinto::Interface::Action::Nop" => 0,
    "Pinto::Interface::Action::Statistics" => 0,
    "Pinto::Interface::Action::Verify" => 0,
    "Pinto::Meta::Attribute::Trait::Postable" => 0,
    "Pinto::Role::Interface::Action::Add" => 0,
    "Pinto::Role::Interface::Action::Clean" => 0,
    "Pinto::Role::Interface::Action::Import" => 0,
    "Pinto::Role::Interface::Action::Mirror" => 0,
    "Pinto::Role::Interface::Action::Pin" => 0,
    "Pinto::Role::Interface::Action::Rebuild" => 0,
    "Pinto::Role::Interface::Action::Remove" => 0,
    "Pinto::Role::Interface::Action::Unpin" => 0,
    "Pinto::Types" => 0,
    "Pinto::Util" => 0,
    "Pod::Usage" => 0,
    "Term::Prompt" => 0,
    "URI" => 0,
    "base" => 0,
    "namespace::autoclean" => 0,
    "perl" => "5.006",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => [
    "bin/pinto-remote"
  ]
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
