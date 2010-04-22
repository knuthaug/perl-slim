package Slim::Statement;

use Moose;
use namespace::autoclean;

=pod

=head1 NAME 

Slim::Statement - A slim statement

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

sub slim_to_perl_class {
    my($self, $class_string) = @_;
    my @parts = split(/\.|\:\:/, $class_string);
    return join "::", map { ucfirst $_ } @parts;
 
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
