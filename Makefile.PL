use ExtUtils::MakeMaker;
require 5.6.0;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile
   (
   'ABSTRACT'     => 'Transparently handles @_ for your class',
   'AUTHOR'       => 'Tommy Butler <cpan@atrixnet.com>',
   'INSTALLDIRS'  => 'perl',
   'NAME'         => 'OOorNO',
   'VERSION_FROM' => 'OOorNO.pm',
   'linkext'      => { LINKTYPE => '' }, # no link needed
   'dist'         =>
      {
         'COMPRESS'  => 'gzip -9f',
         'SUFFIX'    => 'gz',
         'ZIP'       => '/usr/bin/zip',
         'ZIPFLAGS'  => '-rl',
      }
   );

__END__
   * NAME
   * SYNOPSIS
   * DESCRIPTION
   * INSTALLATION
   * EXPORT
   * EXPORT_OK
   * GLOBAL VARIABLES
   * PUBLIC METHODS
   * PRIVATE METHODS
   * EXAMPLES
   * BUGS
   * AUTHOR
   * COPYRIGHT
   * SEE ALSO
