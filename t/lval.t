#!perl -w
use strict;
use Test::More tests => 5;

BEGIN { require_ok( 'Class::Accessor::Lvalue' ) }

package Foo;
use base qw( Class::Accessor::Lvalue );
__PACKAGE__->mk_accessors(qw( bar ));
__PACKAGE__->mk_ro_accessors(qw( baz ));
package main;

my $foo = Foo->new;

isa_ok( $foo, 'Foo' );
eval { $foo->bar = "test" };
is( $@, '', "assigned without errors" );
is( $foo->bar, "test", "got what I expected back" );

eval { $foo->baz = "test" };
like( $@, qr/^Can't modify non-lvalue subroutine call/,
      "assigning to a readonly accessor fails" );
