package Test::Slim::ListSerialization;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::List::Serializer;

my $serializer = undef;
my @list = undef;

sub setup_fixture : Test(setup) {
    $serializer = new Slim::List::Serializer();
    @list = ();
}

sub can_serialize_empty_list : Test(1) {
    is( $serializer->serialize(qw()), "[000000:]", "empty array gives string list of zero" );
}


sub can_serialize_one_item_list : Test(1) {
    @list = qw(hello);
    is( $serializer->serialize(@list), "[000001:000005:hello:]", 
        "one item array array gives string list with length encoding" );
}


sub can_serialize_two_item_list : Test(1) {
    @list = qw(hello world);
    is( $serializer->serialize( @list), "[000002:000005:hello:000005:world:]", 
        "two item array encodes both with length" );
}


sub can_serialize_nested_list : Test(1) {
    @list = (["element"]);
    is( $serializer->serialize( @list), "[000001:000024:[000001:000007:element:]:]", 
      "nested arrays creates nested response");
}


sub can_serialize_a_nonstring_element_list : Test(1) {
    @list = (1);
    is( $serializer->serialize(@list), "[000001:000001:1:]", 
        "non-strings are not processed");
}


sub can_serialize_null_element : Test(1) {
    @list = (undef);
    is( $serializer->serialize(@list), "[000001:000004:null:]", 
        "undef/null element is translated to string 'null'");
}


sub can_serialize_string_with_multibyte : Test(1) {
    @list = qw(Köln);
    is( $serializer->serialize(@list), "[000001:000004:Köln:]", 
      "multibyte strings are encoded as length in characters, not bytes");
}


sub can_serialize_string_with_utf8 : Test(1) {
    @list = ("Español");
    is( $serializer->serialize(@list), "[000001:000007:Español:]", 
      "UTF-8 strings are encoded as length in characters, not bytes");
}

1;
