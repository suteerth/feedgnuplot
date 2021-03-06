use strict;
use warnings;
use ExtUtils::MakeMaker;

sub parseversion
{
# grab the version number from the changelog. I look for lines line
#
# libpackage-perl (0.02)
#
# I parse out the 0.02 part
  open DCH, 'Changes' or die "Couldn't open 'Changes'";
  my ($version) = <DCH> =~ /^\S+ \s* \( ([0-9\.]+) \)/x
    or die "Couldn't parse version from 'Changes'";
  close DCH;

  return $version;
}

sub MY::libscan
{
    package MY;

    my ($self, $file) = @_;

    # Don't install any symlinks (i.e. README.pod)
    return undef if -l $file;

    return $self->SUPER::libscan ($file);
}

# I want my manpage to go into the man section '1', NOT '1p'. Here I add a
# snippet to the end of the generated Makefile to force this
sub MY::postamble
{
  return "MAN1EXT := 1\n";
}


WriteMakefile
  (
   NAME                       => 'feedgnuplot',
   AUTHOR                     => q{Dima Kogan <dima@secretsauce.net>},
   VERSION                    => parseversion(),
   ABSTRACT_FROM              => 'bin/feedgnuplot.pod',
   ($ExtUtils::MakeMaker::VERSION >= 6.3002
    ? ('LICENSE'              => 'perl')
    : ()),
   PL_FILES                   => {},
   EXE_FILES                  => [ 'bin/feedgnuplot' ],
   MAN1PODS                   => { 'bin/feedgnuplot.pod' => 'blib/man1/feedgnuplot.1' },
   PREREQ_PM                  => { 'Test::Script::Run' => 0},
   dist                       => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
   clean                      => { FILES => 'feedgnuplot-*' },
  );
