package Slim;

use Moose;
use namespace::autoclean;

=pod

=head1 NAME 

Slim (perl-slim). Perl implementation of the slim protocol for Fitnesse (http://fitnesse.org)

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

our $VERSION = '0.1';
$VERSION = eval $VERSION;



no Moose;
__PACKAGE__->meta->make_immutable();

1;
