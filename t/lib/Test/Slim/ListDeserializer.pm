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


#positives
sub can_deserialize_an_empty_list : Test(1) {
    my $serialized = $serializer->serialize(\@list);
    is_deeply( $deserializer->deserialize($serialized), \@list);
}


sub can_get_length_from_encoded_string :Test(1) {
    my $count = $deserializer->get_length(split(//, "[000005:]"));
    is($count, 5, "fetches length from encoding");
}

sub can_get_length_from_encoded_string_with_value :Test(2) {
    my $test_string = "[000001:000005:hello:]";
    my $count = $deserializer->get_length(split(//, $test_string));
    is($count, 1, "fetches length from encoding");
    $count = $deserializer->get_length(split(//, $test_string));
    is($count, 5, "fetches length from encoding and checking state");
}


sub can_deserialize_one_element_list : Test(1) {
    @list = qw(foo);
    my $serialized = $serializer->serialize(\@list);
    is_deeply( $deserializer->deserialize($serialized), \@list); 
}


1;
