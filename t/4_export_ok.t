
use strict;
use Test;

# use a BEGIN block so we print our plan before module is loaded
BEGIN { use OOorNO }
BEGIN { plan tests => scalar(@OOorNO::EXPORT_OK), todo => [] }
BEGIN { $| = 1 }

# load your module...
use lib './';

# we gonna see if'n it cun export wut itz 'pose ta. this checks the
# @EXPORT_OK of all packages in the inheritance cascade, which is the
# only reason we're doing this.  we already know that it UNIVERSAL::can do
# all its own methods if this test is being run.  test 3 ensures that.
# this is just an automated non-empty superclass test
use OOorNO @OOorNO::EXPORT_OK;

map {

   ok ref(UNIVERSAL::can('OOorNO', $_)) eq 'CODE'

} @OOorNO::EXPORT_OK;

exit;
