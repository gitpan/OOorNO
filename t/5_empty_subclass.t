
use strict;
use Test;

# use a BEGIN block so we print our plan before module is loaded
BEGIN { use OOorNO }
BEGIN { plan tests => scalar(@OOorNO::EXPORT_OK), todo => [] }
BEGIN { $| = 1 }

# load your module...
use lib './';

# automated empty subclass test

# subclass OOorNO in package _Foo
package _Foo;
use strict;
use warnings;
use OOorNO qw( :all );
$Foo::VERSION = 0.00_0;
@_Foo::ISA = qw( OOorNO );
1;

# switch back to main package
package main;

# see if _Foo can do everything that OOorNO can do
map {

   ok ref(UNIVERSAL::can('_Foo', $_)) eq 'CODE'

} @OOorNO::EXPORT_OK;


exit;
