package Slim::Server;

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

Slim::Server - networking parts

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

=head1 Public API

=over 4

=item run ()

Run a server on the port given in the constructor

=cut

sub run {
    1;
}


=back

=cut


no Moose;

__PACKAGE__->meta->make_immutable();

1;

