use strict;
package Class::Accessor::Lvalue;
use base qw(Class::Accessor::Fast);
our $VERSION = '0.01';

=head1 NOTE

This only comes in a ::Fast variant, which is to say, doesn't go via
->get and ->set

=cut

sub make_accessor {
    my ($class, $field) = @_;

    return sub :lvalue {
        my $self = shift;
        $self->{$field};
    };
}

# ro is easy - return a regular accessor and perl will bitch that it's
# not lvalueable
#
# XXX maybe use Want to make a nicer error message.

sub make_ro_accessor {
    my($class, $field) = @_;

    return sub {
        my $self = shift;
        return $self->{$field};
    };
}

# wo will probably need Want




1;
__END__

