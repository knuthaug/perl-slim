package Slim::List::Deserializer;

use Moose;
use namespace::autoclean;
use Error;
use Slim::SyntaxError;
use Text::CharWidth qw(mbswidth);
use Time::HiRes qw(alarm);

=pod

=head1 NAME 

Slim::List::Deserializer - Deserialization of strings

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
our $TIMEOUT = 1.0;

=head1 Public API

=over 4

=item deserialize (STRING)

deserialize string representation to list structure.

=cut

sub deserialize {
    my($self, $string) = @_;

    throw Slim::SyntaxError("null strings not allowed") if !$string;
    throw Slim::SyntaxError("String is not started with [ character") if $string !~ /^\[/;
    throw Slim::SyntaxError("String does not end in ] character") if $string !~ /\]$/;

    $self->chars([split //, $string ]);
    $self->deserialize_string;    
}


=back

=cut


sub deserialize_string {
    my($self) = @_;

    $self->position(1);
    my $num_elements = $self->get_length;

    return () if ($num_elements == 0);
    $self->serialize_elements($num_elements);
}


sub serialize_elements {
    my($self, $num_elements) = @_;
    my @return_list = ();

    foreach (1..$num_elements) {
        my $element_length = $self->get_length;
        my $element = $self->get_multibyte_element($element_length);
        push(@return_list, $self->handle_nested_lists($element));    
    }

    @return_list;
    
}


sub handle_nested_lists {
    my($self, $element) = @_;
    
    if ($element =~ /^\[/) {
        $self->position($self->position + 1);
        my @nested_elements = new Slim::List::Deserializer->deserialize($element); 
        $self->position($self->position - 1);
        return \@nested_elements;
    }
    
    $element;
}


sub timeout {
    die "Timeout in reading string";
}


sub get_multibyte_element{
    my($self, $element_length) = @_;
 
    (my $element, $element_length) = $self->read_element($element_length);
    
    my $check_pos = $self->position + $element_length;
    my $char = join("", @{$self->chars()}[ $check_pos .. $check_pos ]);

    unless ( $char eq ':') {
        throw Slim::SyntaxError("List Termination Character Not found in " . 
                                $self->get_char_slice($element_length+1));
    }

    $self->position($self->position + $element_length + 1);
    
    $element;
}


sub read_element {
    my($self, $element_length) = @_;
    
    my $length_in_bytes = 0;
    my $element = $self->get_char_slice($element_length);        
    
    ($length_in_bytes, $element) = $self->read_with_timeout($element_length);

    $length_in_bytes--;
    ($self->get_char_slice($length_in_bytes), $length_in_bytes);

}

sub read_with_timeout {

    my($self, $element_length) = @_;
    my $length_in_bytes = $element_length;
    my $element = "";
    $SIG{ALRM} = \&timeout;

    eval {
        alarm ($TIMEOUT);

        do {
            $length_in_bytes++;
            $element = $self->get_char_slice($length_in_bytes);
        } until (mbswidth($element) > $element_length);

        alarm(0);
    };

    if ($@ =~ /Timeout in reading string/) {
        throw Slim::SyntaxError("Multibyte characters detected in string");
    }

    ($length_in_bytes, $element);


}

sub get_char_slice{
    my($self, $length) = @_;
    return join("", @{$self->chars()}[$self->position .. ($self->position + $length) - 1]);
}


sub get_length {
    my($self) = @_;
    my $value = $self->get_char_slice($ENC_LENGTH);
    $self->position( $self->position + ($ENC_LENGTH + 1));

    $value + 0;
}

no Moose;

__PACKAGE__->meta->make_immutable();

1;
