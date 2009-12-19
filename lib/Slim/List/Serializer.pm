package Slim::List::Serializer;

use Moose;
use namespace::autoclean;
use Text::CharWidth qw(mbswidth);
use Encode;

=pod

=head1 NAME 

Slim::ListSerializer - Serialization of list datastructures

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

has 'start_str' => (
                    is => 'ro', 
                    default => '[',
                    isa => 'Str',
                   );

has 'end_str' => (
                  is => 'ro', 
                  default => ']',
                  isa => 'Str',
                 );

=head1 Public API

=over 4

=item serialize (LIST)

serialize list structures to string format

=cut

sub serialize {

    my ($self, @list) = @_;
    my @out = ($self->start_str());
    
    push(@out, $self->encode_length( scalar(@list)) );
    push(@out, $self->process_elements(@list));
    push(@out, $self->end_str());

    return join("", @out);

}

=back

=cut

sub process_elements {
    my($self, @list) = @_;

    my @out;
    foreach my $element ( @list ) {
        $element = 'null' unless defined $element;
        $element = $self->serialize(@$element) if ref $element eq 'ARRAY';
        push(@out, $self->encode_length( mbswidth($element)));
        push(@out, "$element:");
    }
    return join("", @out);
   
}

sub encode_length {
    my($self, $length) = @_;
    return sprintf("%06d:", $length);
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
