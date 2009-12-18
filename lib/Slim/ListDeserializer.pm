package Slim::ListDeserializer;

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

    if (!$string || $string !~ /^\[/ || $string !~ /\]$/) {
        throw Slim::SyntaxError("null not allowed");
    } 
    return $self->deserialize_string(split(//, $string));    
}


=back

=cut


sub deserialize_string {
    my($self, @chars) = @_;

    my $num_elements = $self->get_length(@chars);

    foreach (0..$num_elements) {
        
    }

    if ( $num_elements > 0) {
        return ["foo"];
    }
    return [];
      
}


sub get_length {
    my($self, @chars) = @_;
    my $value = join("", @chars[$self->current_position..$self->current_position + ($ENC_LENGTH - 1)]);
    $self->current_position( $self->current_position + ($ENC_LENGTH + 1));
    return $value + 0;
}

no Moose;

__PACKAGE__->meta->make_immutable();

1;
