#!perl -w
use strict;
use Test::More tests => 8;

BEGIN { require_ok( 'Class::Accessor::Lvalue::Fast' ) }

package Foo;
use base qw( Class::Accessor::Lvalue::Fast );
__PACKAGE__->mk_accessors(qw( bar ));
__PACKAGE__->mk_ro_accessors(qw( baz ));
__PACKAGE__->mk_wo_accessors(qw( quux ));
package main;

my $foo = Foo->new;

isa_ok( $foo, 'Foo' );
eval { $foo->bar = "test" };
is( $@, '', "assigned without errors" );
is( $foo->bar, "test", "got what I expected back" );

eval { $foo->baz = "test" };
like( $@, qr/^'main' cannot alter the value of 'baz' on objects of class 'Foo'/,
      "assigning to a readonly accessor fails" );

eval { $foo->quux = "test" };
is( $@, "", "wo: assign to an lvalue" );
is( $foo->{quux}, "test", "wo: really set it" );

eval { $foo->quux };
like( $@, qr/^'main' cannot access the value of 'quux' on objects of class 'Foo'/,
      "wo: read fails" );
