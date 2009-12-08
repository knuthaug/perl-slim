#!perl

use Module::Build;

my $build = Module::Build->new(
                               dist_version => '0.1',
                               module_name  => "Slim", 
                               license      => "perl",
                               build_requires => { 
                                                  'Test::More'    => '>= 0.90', 
                                                  'Test::Class'   => '>= 0.30',
                                                  'Pod::Coverage' => '>= 0.20', 
                                                  'Devel::Cover'  => '>= 0.65', 
                                                 },
                               requires => { 
                                            'Net::Server'          => '>= 0.01',
                                            'Moose'                => ">= 0.90",
                                            'namespace::autoclean' => '>= 0.09', 
                                            'Text::CharWidth'      => '>= 0.04',
                                           },
                               
                              );

$build->create_build_script();
