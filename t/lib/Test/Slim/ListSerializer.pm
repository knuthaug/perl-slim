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
    is( $serializer->serialize(["hello"]), "[000001:000005:hello:]", 
        "one item array array gives string list with length encoding" );
}


sub can_serialize_two_item_list : Test(1) {
    is( $serializer->serialize(["hello", "world"]), "[000002:000005:hello:000005:world:]", 
        "two item array encodes both with length" );
}


sub can_serialize_nested_list : Test(1) {
    is( $serializer->serialize( [["element"]]), "[000001:000024:[000001:000007:element:]:]", 
      "nested arrays creates nested response");
}


sub can_serialize_a_nonstring_element_list : Test(1) {
    is( $serializer->serialize([1]), "[000001:000001:1:]", 
        "non-strings are not processed");
}


sub can_serialize_null_element : Test(1) {
    is( $serializer->serialize([undef]), "[000001:000004:null:]", 
        "undef/null element is translated to string 'null'");
}


sub can_serialize_string_with_multibyte : Test(1) {
    is( $serializer->serialize(["Köln"]), "[000001:000004:Köln:]", 
      "multibyte strings are encoded as length in characters, not bytes");
}


sub can_serialize_string_with_utf8 : Test(1) {
    is( $serializer->serialize(["Español"]), "[000001:000007:Español:]", 
      "UTF-8 strings are encoded as length in characters, not bytes");
}

1;
