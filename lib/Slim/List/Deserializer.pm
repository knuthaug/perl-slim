package Slim::List::Deserializer;

use Moose;
use namespace::autoclean;
use Error;
use Slim::SyntaxError;

=pod

=head1 NAME 

Slim::ListDeserializer - Deserialization of strings

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

has 'current_position' => (
                           is => 'rw', 
                           default => 1,
                           isa => 'Int',
                   );

our $ENC_LENGTH = 6;

=head1 Public API

=over 4

=item deserialize (STRING)

deserialize string representation to list structure.

=cut

sub deserialize {
    my($self, $string) = @_;

    #REFACTOR
    if (!$string || $string !~ /^\[/ || $string !~ /\]$/) {
        throw Slim::SyntaxError("null not allowed");
    } 

    $self->{'chars'} = [split(//, $string)];
    return $self->deserialize_string();    
}


=back

=cut


sub deserialize_string {
    my($self) = @_;

    $self->current_position(1);

    my $num_elements = $self->get_length;
    my @return_list = ();

    if ($num_elements == 0) {
        return @return_list;
    }


    foreach (1..$num_elements) {
        my $element_length = $self->get_length;
        my $element = join("", @{$self->{'chars'}}[$self->current_position()..($self->current_position() + $element_length) - 1]);
        $self->current_position($self->current_position + $element_length + 1);

        if ($element =~ /^\[/) {
            $self->current_position($self->current_position() + 1);
            my @nested_elements = new Slim::List::Deserializer->deserialize($element); 
            push(@return_list, \@nested_elements);
            $self->current_position($self->current_position() - 1);
        }
        else {
            push(@return_list, $element);    
        }
    }
    return @return_list;
      
}


sub get_length {
    my($self) = @_;
    my $value = join("", @{$self->{'chars'}}[$self->current_position()..$self->current_position() + ($ENC_LENGTH - 1)]);
    $self->current_position( $self->current_position() + ($ENC_LENGTH + 1));
    return $value + 0;
}

no Moose;

__PACKAGE__->meta->make_immutable();

1;
