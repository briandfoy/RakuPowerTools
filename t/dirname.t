#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin dirname>;

my $null_fh = $*SPEC.devnull.IO.open;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err($null_fh);
	my $output = $proc.out.slurp-rest( :close );
	$ = $proc.err.slurp-rest( :close );
	is $output, "Syntax OK\n";
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program, :err($null_fh);
	$ = $proc.err.close;
	is $proc.exitcode, 1, 'exit code';
	}, "{$program} no arguments";

subtest {
	my $proc = run $*EXECUTABLE, $program, qw/a b/, :err($null_fh);
	is $proc.exitcode, 1, 'exit code';
	$ = $proc.err.close
	}, "{$program} with two arguments";

subtest {
	my @parts = ( $*SPEC.rootdir, slip qw/usr local bin perl6/ );
	my $path = $*SPEC.catfile( @parts.flat );
	my $expected = $*SPEC.catfile: @parts[0..*-2];
	my $proc = run $*EXECUTABLE, $program, $path, :out;
	is $proc.out.get, $expected, 'Got the path';
	$proc.out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with path";

done-testing();
