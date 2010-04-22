package Test::Slim::StatementTransformations;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::Statement;;

my $statement = undef;

sub setup_fixture : Test(setup) {
    $statement = new Slim::Statement();
}

sub can_translate_slim_classes_to_perl_class_names : Test(2) {
    is( $statement->slim_to_perl_class("package.Class"), "Package::Class", "Transforms . to ::");
    is( $statement->slim_to_perl_class("package.subPackage::class"), 
        "Package::SubPackage::Class", "Transforms . to :: and uppercases");
}



1;
