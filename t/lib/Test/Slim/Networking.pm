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

#socket tests

sub can_handle_one_connection : Test(1) {
    $socket_handler->handle( sub { $connections += 1;  } );
    test_socket();
    $socket_handler->close_all;

    is($connections, 1, "1 connection after close");
}


sub can_handle_many_connections : Test(2) {
    $socket_handler->handle( sub { $connections += 1;  } );

    foreach (1..10) {
        test_socket();
    }

    $socket_handler->close_all;

    is($connections, 10, "10 connections after close");
    is($socket_handler->pending_sessions, 0, "no pending sessions");
}


sub can_read_via_socket : Test(1) {
    $socket_handler->handle( sub { my ($self,$conn) = @_; print $conn "hello";  } );

    my $socket = get_socket();
    my $reply = <$socket>;

    is($reply, "hello", "get reply from socket server");

    close($socket);
    $socket_handler->close_all;

}


sub server_keeps_record_of_sessions : Test(2) {
    


    $socket_handler->handle( sub { my $self = shift; 
                                   my $sock = $self->socket;
                                   my $message = "foo";

                                   sleep 1;

                                   while (<$sock>) {
                                       $message = $_;
                                   }

                                   print STDERR $message;

                                   } );

    my $thread1 = threads->create( sub { my $socket = get_socket();
                                         print $socket "test";
                                         close($socket);
                                         return;

                                     });
    is($socket_handler->pending_sessions, 3);

    $thread1->join();
    $socket_handler->close_all;
    is($socket_handler->pending_sessions, 0);

}

sub test_socket {
    my $socket = get_socket();
    sleep(0.15);
    close($socket);
}


sub get_socket {
    my $socket = IO::Socket::INET->new(PeerAddr => 'localhost',
                                       PeerPort => $port,
                                       Proto    => "tcp")
      or confess "Couldn't connect to $port : $@\n";
    return $socket;
}


1;
