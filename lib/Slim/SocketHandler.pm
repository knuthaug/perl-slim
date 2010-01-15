package Slim::SocketHandler;

use Moose;
use namespace::autoclean;
use Error;
use Time::HiRes qw(alarm);


has 'port' => (
               is => 'rw', 
               default => 12345,
               isa => 'Int',
              );


=pod

=head1 NAME 

Slim::SocketHandler - low level socket handler

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

=head1 Public API

=over 4

=item run ()

Run a server on the port given in the constructor

=cut



=back

=cut


no Moose;

__PACKAGE__->meta->make_immutable();

1;

