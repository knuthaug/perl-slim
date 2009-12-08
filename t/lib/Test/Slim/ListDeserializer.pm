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
    $serializer = new Slim::ListSerializer();
    $deserializer = new Slim::ListDeserializer();
    @list = ();
}



sub cannot_deserialize_undef_string : Test(1) {
    throws_ok { $deserializer->deserialize(undef) } 'Slim::SyntaxError', 
      "undef string throws syntax error";
}


sub cannot_deserialize_empty_string : Test(1) {
    throws_ok { $deserializer->deserialize("") } 'Slim::SyntaxError',
      "empty string throws syntax error";
}


sub cannot_deserialize_string_that_doesnt_start_with_open_bracket : Test(1) {
    throws_ok { $deserializer->deserialize("foo") } 'Slim::SyntaxError', 
      "string not starting in open bracket";
}


sub cannot_deserialize_string_that_doesnt_end_with_close_bracket : Test(1) {
    throws_ok { $deserializer->deserialize("[foo") } 'Slim::SyntaxError', 
      "string not starting in open bracket";
}


#positives
sub can_deserialize_an_empty_list : Test(1) {
    my $serialized = $serializer->serialize(\@list);
    is_deeply( $deserializer->deserialize($serialized), \@list);
}

sub can_deserialize_one_element_list : Test(1) {
    @list = qw(foo);
    my $serialized = $serializer->serialize(\@list);
    is_deeply( $deserializer->deserialize($serialized), \@list); 
}

1;
