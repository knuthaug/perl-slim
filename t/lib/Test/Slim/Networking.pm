package Test::Slim::Networking;

use strict;
use warnings;
use base qw(Test::Class);

use Test::More;
#use Test::Exception;
use Time::HiRes qw(sleep);
use Carp;
use IO::Socket;

#use Slim::Server;
use Slim::SocketHandler;
use threads;
use threads::shared;

#my $server;
my $socket_handler;
my $connections :shared;

my $port = 12345;

sub setup_fixture : Test(setup) {
    $socket_handler = new Slim::SocketHandler({ port => $port });
    $connections = 0;
}

#sub can_run_the_server : Test(1) {
    #is(1, $server->run, "Run returns (fake) 1")
#}


#socket tests

sub can_handle_one_connection : Test(1) {
    $socket_handler->handle( sub { $connections += 1;  } );
    connect_socket();
    $socket_handler->close_all;

    is($connections, 1, "1 connection after close");
}


sub can_handle_many_connections : Test(1) {
    $socket_handler->handle( sub { $connections += 1;  } );

    foreach (1..10) {
        connect_socket();
    }

    $socket_handler->close_all;

    is($connections, 10, "10 connections after close");
    
}

sub connect_socket {

    my $socket = IO::Socket::INET->new(PeerAddr => 'localhost',
                                       PeerPort => $port,
                                       Proto    => "tcp")
      or confess "Couldn't connect to $port : $@\n";
    sleep(0.1);
    close($socket);
}


1;
