package Test::Slim::Errors;

use base qw(Test::Class);
use Test::More;
use Test::Exception;

use Slim::ListDeserializer;
use Slim::ListSerializer;

my $deserializer;

sub setup_fixture : Test(setup) {
    $deserializer = new Slim::ListDeserializer();
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

1;
