package OOorNO;
use strict;
use vars qw( $VERSION   @ISA   @EXPORT_OK   %EXPORT_TAGS );
use Exporter;
$VERSION     = 0.00_8; # 12/27/02, 5:50 pm
@ISA         = qw( Exporter );
@EXPORT_OK   = qw( shave_opts   coerce_array   OOorNO   myargs   myself );
%EXPORT_TAGS = ( 'all' => [ @EXPORT_OK ] );

# --------------------------------------------------------
# Constructor
# --------------------------------------------------------
sub new { bless({ }, shift(@_)) }


# --------------------------------------------------------
# OOorNO::OOorNO()
# --------------------------------------------------------
sub OOorNO { return($_[0]) if defined($_[0]) and UNIVERSAL::can($_[0],'can') }


# --------------------------------------------------------
# OOorNO::myargs()
# --------------------------------------------------------
sub myargs {

   if (OOorNO(@_)) {

      if (ref($_[0]) eq (caller(0))[0]) { shift(@_) }
   }

   @_
}


# --------------------------------------------------------
# OOorNO::myself()
# --------------------------------------------------------
sub myself { return(@{$_[0]}) if OOorNO( @{$_[0]} ) }


# --------------------------------------------------------
# OOorNO::shave_opts()
# --------------------------------------------------------
sub shave_opts {

   my($mamma) = myargs(@_);

   return(undef) unless ($mamma && UNIVERSAL::isa($mamma,'ARRAY'));

   my(@maid)   = @$mamma; @$mamma = ();
   my($opts)   = {};

   while (@maid) {

      my($o) = shift(@maid)||'';

      if (substr($o,0,2) eq '--') {

         $opts->{[split(/=/o,$o)]->[0]} = [split(/=/o,$o)]->[1] || $o;
      }
      else {

         push(@$mamma, $o);
      }
   }

   return($opts);
}


# --------------------------------------------------------
# OOorNO::coerce_array()
# --------------------------------------------------------
sub coerce_array {

   my($hashref)   = {};
   my($i)         = 0;
   my(@shadow)    = myargs(@_);

   while (@shadow) {

      my($name,$val) = splice(@shadow,0,2);

      if (defined($name)) {

         $hashref->{$name} = (defined($val)) ? $val : '';
      }
      else {

         ++$i;

         $hashref->{qq[un-named key no. $i]} = (defined($val)) ? $val : '';
      }
   }

   return($hashref);
}


# --------------------------------------------------------
# OOorNO::DESTROY(), OOorNO::AUTOLOAD()
# --------------------------------------------------------
sub DESTROY { } sub AUTOLOAD { }
1;


=pod

=head1 NAME

OOorNO - Handles "@_" for your own class methods.

=head1 DESCRIPTION

OOorNO exists for the sole purpose of helping another module handle the input
for its internal routines, and is not intended for direct use in your Perl
programs, though it can.

For heftier, more robust support for parsing input to your programs, take a
look at Getopt::Long.pm for parsing commandline arguments and CGI.pm for
parsing STDIN in programs that operate over the common gateway interface.

=head1 VERSION

0.00_7

=head1 ISA

=over

=item Exporter

=back

=head1 EXPORT

None by default.

=head1 EXPORT_OK

All available methods.  (see section "METHODS" below)

=head1 EXPORT_TAGS

   :all (exports all of @EXPORT_OK)

=head1 METHODS

=head2 coerce_array(@array/(list))

This method retrieves input sent to your class methods when called with
name-value pairs and returns an anonymous hash reference whose keys and values
correspond to the input argument names and their respective values.  If nothing
is passed to it, an empty hash reference will be returned, eg- C<{ }>

=head3 Syntax

   package Your::Class;
   use OOorNO qw( coerce_array );

   sub bar {

      my($args) = coerce_array(@_);
   ...

B<-OR->

   package Your::Class;
   use OOorNO;
   our($onobj) = OOorNO->new();

   sub foo {

      my($self) = shift(@_);
      my($args) = $onobj->coerce_array(@_);
   ...

B<-OR->

   package Your::Class;
   use OOorNO;
   use vars qw( @ISA );

   @ISA = qw( OOorNO );

   sub foo {

      my($self) = shift(@_);
      my($args) = $self->coerce_array(@_);
   ...

=head3 What This Method is For

It's common practice for Perl modules to accept name-value pairs for their
methods, and because @_ is an array it is easy to encounter warnings and errors
when this isn't handled correctly.  An example of what this kind of call would
look like is shown below in the imaginary subroutine I<"Your::Class::method()">

   Your::Class->method
      (
         -name => 'Joe',
         -rank => 'Private, First-Class',
         -SN   => '87D91-35-713FOO',
      );

=head4 Pitfalls

Quite often a class method will use code such as this to handle name-value
paired input:

   sub foo {

      my($class)  = shift;
      my(%args)   = @_; ...

B<-and/or->

   sub bar {

      my($args)   = { @_ }; ...

=head4 What's Wrong With That?

While this practice is not evil, it can be error-prone in situations where:

=over

=item *

Your class method is called in procedural style and expects that the
first element in @_ is a blessed object reference.

=item *

Your class method is errantly called with an unbalanced set of name-value
pairs, or one or more named arguments get passed with undefined values.

=item *

You want to give your module the ability to export any or all of its methods
by using the L<Exporter|Exporter> module, but still want to maintain an
object-oriented interface to your module as well.  An example of a well known
module which does this is L<CGI.pm|CGI>.  It is written to provide both a
standard procedural interface as well as an object-oriented one.  You can
call its methods either way:

   # object-oriented style
   use CGI;
   my($cgi_object) = CGI->new();
   my($visitor) = $cgi_object->param('visitor name');

B<-OR->

   # procedural style
   use CGI qw( param );
   my($visitor) = param('visitor name');

=back

=head4 Don't say I didn't I<warn> you B< ;o) >

When these situations occur, class methods sorting out name-value paired input
using the common problematic technique I<(demonstrated above in
"L<Pitfalls|/Pitfalls>)>" encounter problems such as undesired program behavior,
general errors, and warnings -both fatal and non-fatal. Problems include:

=over

=item *

Argument sets that get reversed; the argument names become the hash values
and the argument values become the hash keys which is exactly the opposite of
the desired behavior.

=item *

The entire arument hash/hashref gets turned into a mess of mixed up
keys and values that don't reflect the actual input at all.  Instead,
you get hash keys containing both argument names and argument values.

=item *

The argument hash/hashref is created with an uneven number of elements
and/or uninitialized values.

=back

Warnings I<(see L<perldiag|perldiag>)> resulting from the above mentioned
situations could include any the following  (Some of these don't apply unless
you run your program under the L<warnings pragma|warnings>) like you
I<L<should|perl/BUGS>>.

=over

=item C<Can't coerce array into hash>

I<This is a fatal warning, eg- if you see it your program
failed and execution aborted.)>

=item C<Odd number of elements in hash assignment>

I<non-fatal.>

=item  C<Not a %s reference>

-where C<%s> is probably "HASH", though it could be complaining about a
non-reference to any data type that your routine may be attempting to treat
as a reference.  This is often the result of a class method being called in
procedural style rather than in the object-oriented style using the arrow
C<-\>> syntax.  The class method expects the first argument to be an object
reference, when it is clearly not. I<(This warning is fatal as well.)>

=item C<Can't call method %s on unblessed reference>

I<This is another a fatal warning>, and will occur under the same circumstances
that surround the warning described immediately above.  The class method
expects the first argument to be an object reference when it's not.

=back

=head2 myargs(@_)

This method retrieves the input sent to your class methods and returns it
untouched, with the exception that if a blessed object reference from the same
namespace as the caller is found in $_[0], it will be not be included with
the rest of the arguments when they are returned.  This simply allows the
methods in your class to get their argment list quickly without having to check
if they were called procedurally or with object-oriented notation.  This has its
own pros and cons, and you should use this tool with care.

If you are expecting a blessed object reference from your package to be in @_
regardless of the way your method was called -B<don't use this method> because
that reference will obviously be excluded from your argument list.

=head3 Syntax

   package Your::Class;
   use OOorNO qw( myargs );

   sub bar {

      my(@args) = myargs(@_);
   ...

B<-OR->

   package Your::Class;
   use OOorNO;
   our($onobj) = OOorNO->new();

   sub foo {

      my(@args) = $onobj->myargs(@_);
   ...

=head2 myself(@_)

Undocumented.

=head2 OOorNO(@_)

Undocumented.

=head2 shave_opts(\@_)

Undocumented.

=head1 PREREQUISITES

None.

=head1 BUGS

This documentation isn't done yet, as you can see.  This is being rectified
as quickly as possible.  Please excercise caution if you choose to use this
code before it can be further documented for you.  It is present on CPAN
at this time despite its unfinished condition in order to providing support for
the L<File::Util|File::Util> module which lists OOorNO among its prerequisites.
Please excuse the inconvenience.

=head1 AUTHOR

Tommy Butler <L<cpan@atrixnet.com|mailto:cpan@atrixnet.com>>

=head1 COPYRIGHT

Copyright(c) 2001-2003, Tommy Butler.  All rights reserved.

=head1 LICENSE

This library is free software, you may redistribute
and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

=over

=item L<File::Util>

=item L<Getopt::Long>

=item L<CGI>

=item L<Exporter>

=back

=cut

