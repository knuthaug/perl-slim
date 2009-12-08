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
    is( $serializer->serialize(["hello"]), "[000001:000005:hello:]", "one item array array gives string list with length encoding" );
}


sub can_serialize_two_item_list : Test(1) {
    is( $serializer->serialize(["hello", "world"]), "[000002:000005:hello:000005:world:]", "two item array encodes both with length" );
}


sub can_serialize_nested_list : Test(1) {
    is( $serializer->serialize( [["element"]]), "[000001:000024:[000001:000007:element:]:]", 
      "nested arrays creates nested response");
}

1;
