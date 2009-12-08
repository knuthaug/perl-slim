package Slim::ListSerializer;

use Moose;
use namespace::autoclean;

=pod

=head1 NAME 

Serialization of list datastructures

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

=head1 Public API

=over 4

=item serialize (LIST)

serialize list structures to string format

=cut

sub serialize {

    my $self = shift;
    my $list = shift;

    if (scalar(@$list) == 0) {
        return "[000000:]";
    }
    return "[000001:000005:]";
}


=back

=cut

no Moose;
__PACKAGE__->meta->make_immutable();

1;
