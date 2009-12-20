package Slim::List::Deserializer;

use Moose;
use namespace::autoclean;
use Error;
use Slim::SyntaxError;
use Text::CharWidth qw(mbswidth);

=pod

=head1 NAME 

Slim::ListDeserializer - Deserialization of strings

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

has 'position' => (
                           is => 'rw', 
                           default => 1,
                           isa => 'Int',
                   );


has 'chars' => (
                is => 'rw',
                isa => 'ArrayRef[Str]',
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
    throw Slim::SyntaxError("null strings not allowed") if !$string;
    throw Slim::SyntaxError("String is not started with [ character") if $string !~ /^\[/;
    throw Slim::SyntaxError("String does not end in ] character") if $string !~ /\]$/;

    $self->chars( [split(//, $string) ] );
    return $self->deserialize_string;    
}


=back

=cut


sub deserialize_string {
    my($self) = @_;

    $self->position(1);

    my $num_elements = $self->get_length;

    if ($num_elements == 0) {
        return ();
    }

    return $self->serialize_elements($num_elements);
}


sub serialize_elements{
    my($self, $num_elements) = @_;
    my @return_list = ();

    foreach (1..$num_elements) {
        my $element_length = $self->get_length;
        my $element = $self->fetch_multibyte_element($element_length);

        if ($element =~ /^\[/) {
            #refactor
            $self->position($self->position + 1);
            my @nested_elements = new Slim::List::Deserializer->deserialize($element); 
            push(@return_list, \@nested_elements);
            $self->position($self->position - 1);
        }
        else {
            push(@return_list, $element);    
        }
    }
    return @return_list;
    
}


sub fetch_multibyte_element{
    my($self, $element_length) = @_;
    my $length_in_bytes = $element_length;
    my $element = join("", @{$self->chars}[$self->position .. ($self->position + $length_in_bytes) - 1]);        

    do {
        $length_in_bytes++;
        $element = join("", @{$self->chars()}[$self->position .. ($self->position + $length_in_bytes) - 1]);
    } until (mbswidth($element) > $element_length);
    
    $length_in_bytes--;
    $element = join("", @{$self->chars()}[$self->position..($self->position + $length_in_bytes) - 1]);   
    
    $self->position($self->position + $element_length + 1);
    return $element;
}

sub get_length {
    my($self) = @_;
    my $value = join("", @{$self->chars}[$self->position .. $self->position + ($ENC_LENGTH - 1)]);
    $self->position( $self->position + ($ENC_LENGTH + 1));
    return $value + 0;
}

no Moose;

__PACKAGE__->meta->make_immutable();

1;
