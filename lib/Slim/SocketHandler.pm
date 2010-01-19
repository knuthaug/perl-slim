package Slim::SocketHandler;

use Moose;
use threads;
use threads::shared;
use namespace::autoclean;
use Error;
use Time::HiRes qw(alarm);
use IO::Socket;


has 'port' => (
               is => 'rw', 
               default => 12345,
               isa => 'Int',
              );

has 'action' => (
               is => 'rw', 
               isa => 'CodeRef',
              );

has 'listener_thread' => (
               is => 'rw', 
               isa => 'Object',
              );

has 'socket' => (
               is => 'rw', 
               isa => 'IO::Socket',
              );


=pod

=head1 NAME 

Slim::SocketHandler - low level socket handler

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

=head1 Public API

=over 4

=item handle ()

Run a socket listening on the port given in the constructor

=cut

sub handle { 
    my($self, $action) = @_;
    
    $self->action($action);
    $self->socket($self->open_socket() ); 
    $self->listener_thread(threads->create( 'listen', $self));
}


sub close_all {
    my($self) = @_;
    
    shutdown($self->socket, 2);
    foreach my $thread (threads->list()) {
        $thread->join();
    }
}


=back

=cut



sub listen {
    my($self) = @_;

    while ( my $connection = $self->socket()->accept() ) {
        threads->create('handle_connection', $self, $connection);
    }
    
}

sub handle_connection {
    my($self, $connection) = @_;
    my $return = $self->action->($connection);

    #while (<$connection>) {
    #    print STDERR "got: " . $_;
    #}
    close($connection);
    return $return;
    
}

sub open_socket { 
    my($self) = @_;
    my $socket = IO::Socket::INET->new(LocalPort => $self->port,
                                       LocalHost => 'localhost',
                                       Reuse     => 1,
                                       Listen    => 1,
                                       Type      => SOCK_STREAM,
                                       Proto     => 'tcp', 
                                      Blocking => 1)
      or confess "Couldn't create a tcp server on port " . $self->port() . " : $@\n";
    return $socket;
    
}



no Moose;

__PACKAGE__->meta->make_immutable();

1;

