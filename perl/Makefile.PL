require 5.005002;
use strict;
use ExtUtils::MakeMaker;

my $cflags = q[-DHAVE_CONFIG_H];
$cflags .= q[ -Wall -g -O0] if -d '/home/shevek';	# Maintainer/gcc stuff

WriteMakefile(
	NAME			=> 'Mail::SPF_XS',
	VERSION_FROM	=> 'SPF_XS.pm',
    ABSTRACT_FROM	=> "SPF_XS.pm",
	AUTHOR			=> 'Shevek <cpan@anarres.org>',
	PREREQ_PM		=> {
					# 'Mail::SPF'		=> 0.30,
					'String::Escape'	=> 0,
					'Test::More'		=> 0,
						},
	OPTIMIZE		=> $cflags,
	LIBS			=> [ '-L../src/libspf2/.libs -lspf2', ],
);

sub MY::postamble {
	my $self = shift;
	my $old = $self->MM::postamble(@_);
	chomp($old);
	my $new = <<'EON';

$(INST_DYNAMIC) : ../src/libspf2/.libs/libspf2.so.*

.PHONY : aux dep readme clean check

aux : readme dep

readme : SPF_XS.pm
	perldoc -t SPF_XS.pm > README

check :: test
	# Could use valgrind here.

clean ::
	rm -f Makefile.old

EON
	return $old . $new;
}
