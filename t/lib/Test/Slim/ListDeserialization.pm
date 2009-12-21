package Test::Slim::ListDeserialization;

use base qw(Test::Class);
use Test::More;
use Test::Exception;

use Slim::List::Deserializer;
use Slim::List::Serializer;

my $serializer;
my $deserializer;
my @list;

sub setup_fixture : Test(setup) {
    $deserializer = new Slim::List::Deserializer();
    $serializer = new Slim::List::Serializer();
    @list = qw();
}


sub compare_lists{
    my @original_list = @_;
    my @deserialized = $deserializer->deserialize($serializer->serialize(@original_list));
    is_deeply(\@deserialized, \@original_list, "comparing lists"); 
}


sub can_deserialize_an_empty_list : Test(1) {
    my @deserialized = $deserializer->deserialize($serializer->serialize(@list));
    is_deeply( \@deserialized, \@list, "comparing lists");
}


sub can_deserialize_one_element_list : Test(1) {
    compare_lists(qw(foo));
}

sub can_deserialize_a_two_element_list : Test(1) {
   compare_lists(qw(foo bar));
}

sub can_deserialize_a_nested_lists : Test(1) {
    my @list = ("foo", ["bar", "zoot"], "test");
      compare_lists(@list);
}

sub can_deserialize_lists_with_multibyte_strings : Test(1) {
    my @list = ("Köln");
    compare_lists(@list);
}

sub can_deserialize_list_with_element_ending_in_multibyte_char : Test(1) {
    my @list = ("Kö");
    compare_lists(@list);
}

sub can_deserialize_lists_with_utf8_strings : Test(1) {
    my @list = ("123456789012345", "Español");
    compare_lists(@list);
}


1;
