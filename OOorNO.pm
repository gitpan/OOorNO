package OOorNO;
use strict;
use vars qw( $VERSION   @ISA   @EXPORT_OK   %EXPORT_TAGS );
use Exporter;
$VERSION     = 0.00_6; # 12/23/02, 12:48 am
@ISA         = qw( Exporter );
@EXPORT_OK   = qw( shave_opts   coerce_array   OOorNO   myargs   myself );
%EXPORT_TAGS = ( 'all' => [ @EXPORT_OK ] );

# --------------------------------------------------------
# Constructor
# --------------------------------------------------------
sub new { bless({ }, shift(@_)); }


# --------------------------------------------------------
# OOorNO::OOorNO()
# --------------------------------------------------------
sub OOorNO { return($_[0]) if defined($_[0]) and UNIVERSAL::can($_[0],'can'); }


# --------------------------------------------------------
# OOorNO::myargs()
# --------------------------------------------------------
sub myargs { if (OOorNO(@_)) { shift(@_) } @_; }


# --------------------------------------------------------
# OOorNO::myself()
# --------------------------------------------------------
sub myself { return(@{$_[0]}) if OOorNO( @{$_[0]} ); }


# --------------------------------------------------------
# OOorNO::shave_opts()
# --------------------------------------------------------
sub shave_opts {

   my($mamma) = myargs(@_);

   return(undef) unless ($mamma && ref($mamma) eq 'ARRAY');

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
OOorNO - Transparently handles @_ for your class methods whether they were
called in OO style or not.

=head1 VERSION
0.00_6

=head1 @ISA
   Exporter

=head1 @EXPORT
None by default.

=head1 @EXPORT_OK
All available methods.

=head1 %EXPORT_TAGS
   :all (exports all of @EXPORT_OK)

=head1 Methods
   coerce_array()
   myargs()
   myself()
   OOorNO()
   shave_opts()

=head2 AUTOLOAD-ed methods
none

=head1 PREREQUISITES
none

=head1 AUTHOR
Tommy Butler <cpan@atrixnet.com>

=head1 COPYRIGHT
Copyright(c) 2001-2003, Tommy Butler.  All rights reserved.

=head1 LICENSE
This library is free software, you may redistribute
and/or modify it under the same terms as Perl itself.

=cut

