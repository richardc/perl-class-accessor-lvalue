use strict;
package Class::Accessor::Lvalue::Fast;
use base qw(Class::Accessor::Fast);
use Want;

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


=head1 NAME

Class::Accessor::Lvalue::Fast - create simplified Lvalue accessors

=head1 SYNOPSIS

 package Foo;
 use base qw( Class::Accessor::Lvalue::Fast );
 __PACKAGE__->mk_accessors(qw( bar ))

 my $foo = Foo->new;
 $foo->bar = 42;
 print $foo->bar; # prints 42


=head1 DESCRIPTION

This module subclassess L<Class::Accessor::Fast> in order to provide
lvalue accessors.

=head1 IMPLEMENTATION NOTES

You may have noted that this accessor-maker only comes in a ::Fast
variant.  This is because the non-fast variant would use an
indirection through ->get and ->set methods - I couldn't at the time
of writing see a way to make that lvaluable.

If you have a suggestion for that, I'd like to hear from you.

=head1 AUTHOR

Richard Clamp <richardc@unixbeard.net>

=head1 COPYRIGHT

Copyright (C) 2003 Richard Clamp.  All Rights Reserved.
This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::Accessor::Fast>, L<Want>

=cut
