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

    my ($self, $list) = @_;

    my @out = ("[");
    push( @out, $self->length_as_string(scalar(@$list)));

    foreach my $element ( @$list ) {
        
        if (ref $element eq 'ARRAY') {
            $element = $self->serialize($element);
        }

        push( @out, $self->length_as_string(length($element)));
        push( @out, "$element:");
    }
   
    push(@out, "]");
    return join("", @out);
}


=back

=cut

sub length_as_string{
    my($self, $length) = @_;
    return sprintf("%06d:", $length);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
