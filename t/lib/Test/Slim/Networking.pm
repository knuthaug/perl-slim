package Test::Slim::Networking;

use base qw(Test::Class);
use Test::More;
#use Test::Exception;
use strict;
use warnings;

use Slim::Server;
use Slim::SocketHandler;

my $server;
my $socket_handler;
my $connections;

my $port = 12345;

sub setup_fixture : Test(setup) {
    $server = new Slim::Server({port =>$port});
    $socket_handler = new Slim::SocketHandler({port => $port});
    $connections = 0;
}

sub can_run_the_server : Test(1) {
    is(1, $server->run, "Run returns (fake) 1")
}


#socket tests

sub can_handle_one_connection: Test(1) {
    is(1, $connections, "1 alive connection after close");
}



1;
