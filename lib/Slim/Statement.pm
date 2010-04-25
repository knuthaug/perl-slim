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
    my @parts = split /\.|\:\:/, $class_string;
    join "::", map { ucfirst $_ } @parts;
 
}

sub slim_to_perl_method {
    my($self, $method_string) = @_;
    $method_string =~ s|([A-Z])|"_" . lc($1)|eg;
    $method_string;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
