use strict;
package Class::Accessor::Lvalue::Fast;
use base qw(Class::Accessor::Fast);
use Want;
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

sub make_ro_accessor {
    my($class, $field) = @_;

    return sub :lvalue {
        my $self = shift;
        if (want 'LVALUE') {
            my $caller = caller;
            require Carp;
            Carp::croak("'$caller' cannot alter the value of '$field' on ".
                          "objects of class '$class'");
        }
        return $self->{$field};
    };
}

# wo will probably need Want

sub make_wo_accessor {
    my($class, $field) = @_;

    return sub :lvalue {
        my $self = shift;
        unless (want 'LVALUE') {
            my $caller = caller;
            require Carp;
            Carp::croak("'$caller' cannot access the value of '$field' on ".
                          "objects of class '$class'");
        }
        $self->{$field};
    };
}

1;
__END__

