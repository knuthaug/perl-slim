package Test::Slim::ListDeserializer;

use base qw(Test::Class);
use Test::More;
use Test::Exception;

use Slim::ListDeserializer;
use Slim::ListSerializer;

my $serializer;
my $deserializer;
my @list;

sub setup_fixture : Test(setup) {
    $deserializer = new Slim::ListDeserializer();
    $serializer = new Slim::ListSerializer();
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


1;
