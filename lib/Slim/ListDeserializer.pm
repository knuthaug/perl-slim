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
    return [];
    
}


=back

=cut



no Moose;

__PACKAGE__->meta->make_immutable();

1;
