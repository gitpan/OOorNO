
use strict;
use Test;

# use a BEGIN block so we print our plan before MyModule is loaded
BEGIN { plan tests => 1, todo => [] }
BEGIN { $| = 1 }

# load your module...
use lib './';
use OOorNO;

my($f) = OOorNO->new();

# check to see if OOorNO ISA [foo, etc.]
ok(UNIVERSAL::isa($f,'OOorNO'));

exit;