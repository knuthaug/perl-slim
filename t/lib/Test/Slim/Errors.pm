package Test::Slim::Errors;

use base qw(Test::Class);
use Test::More;
use Test::Exception;

use Slim::List::Deserializer;
use Slim::List::Serializer;

my $deserializer;

sub setup_fixture : Test(setup) {
    $deserializer = new Slim::List::Deserializer();
}


sub throws_excetption_deserializing_undef_string : Test(1) {
    throws_ok { $deserializer->deserialize(undef) } 'Slim::SyntaxError', 
      "undef string throws syntax error";
}


sub throws_exception_when_deserializing_empty_string : Test(1) {
    throws_ok { $deserializer->deserialize("") } 'Slim::SyntaxError',
      "empty string throws syntax error";
}


sub throws_exception_when_deserializing_string_that_doesnt_start_with_open_bracket : Test(1) {
    throws_ok { $deserializer->deserialize("foo") } 'Slim::SyntaxError', 
      "string not starting in open bracket";
}


sub throws_exception_when_deserializing_string_that_doesnt_end_with_close_bracket : Test(1) {
    throws_ok { $deserializer->deserialize("[foo") } 'Slim::SyntaxError', 
      "string not starting in open bracket";
}

sub must_throw_exception_when_string_contains_extended_ascii : Test(1) {

    {
        $Slim::List::Deserializer::TIMEOUT = 0.001;
        my $serialized = "[000002:000119:[000006:000015:scriptTable_3_0:000004:call:000016:scriptTableActor:000005:setTo:000015#:System\\Language:000007:Espa\361ol:]:000033:[000002:000005:hello:000003:bob:]:]";
        throws_ok { $deserializer->deserialize($serialized) } "Slim::SyntaxError", 
          "Extended ascii characters detected";
    }
}

1;
