package Test::Slim::ListSerializer;

use base qw(Test::Class);
use Test::More;
use Slim::ListSerializer;

my $serializer = undef;

sub setup_fixture : Test(setup) {
    $serializer = new Slim::ListSerializer();
}

sub can_serialize_empty_list : Test(1) {
    is( $serializer->serialize([]), "[000000:]", "empty array gives string list of zero" );
}


sub can_serialize_one_item_list : Test(1) {
    is( $serializer->serialize(["hello"]), "[000001:000005:]", "one item array array gives string list with length encoding" );
}

1;
