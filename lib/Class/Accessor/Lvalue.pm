use strict;
package Class::Accessor::Lvalue;
use base qw( Class::Accessor );
use Scalar::Util qw(weaken);
use Want qw( want );
our $VERSION = '0.01';

tie my $rw, "Class::Accessor::Lvalue::Tied";

sub _tied_accessor :lvalue {
    $Class::Accessor::Lvalue::Tied::field = shift;
    $Class::Accessor::Lvalue::Tied::self  = shift;
    weaken $Class::Accessor::Lvalue::Tied::self;
    $rw;
}

sub make_accessor {
    my ($class, $field) = @_;

    return sub :lvalue {
        _tied_accessor( $field, @_ );
    };
}

sub make_ro_accessor {
    my ($class, $field) = @_;

    return sub :lvalue {
        my $self = shift;
        if (want 'LVALUE') {
            my $caller = caller;
            require Carp;
            Carp::croak("'$caller' cannot alter the value of '$field' on ".
                          "objects of class '$class'");
        }
        _tied_accessor( $field, $self, @_ );
    };
}


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
        _tied_accessor( $field, $self, @_ );
    };
}


package Class::Accessor::Lvalue::Tied;
sub TIESCALAR { bless {} }

sub STORE {
    shift;
    our ($self, $field);
    $self->set( $field, @_ );
}

sub FETCH {
    our ($self, $field);
    $self->get( $field );
}

1;
__END__

=head1 NAME

Class::Accessor::Lvalue - create Lvalue accessors

=head1 DESCRIPTION

This module is non-functional, see L<Class::Accessor::Lvalue::Fast>,
distributed with this one) for one that is and a discussion as to why
this is.

=head1 AUTHOR

Richard Clamp <richardc@unixbeard.net>

=head1 COPYRIGHT

Copyright (C) 2003 Richard Clamp.  All Rights Reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::Accessor>, L<Class::Accessor::Lvalue::Fast>

=cut
