#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin primes>;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err;
	my $output = $proc.out.slurp-rest( :close );
	is $output, "Syntax OK\n", 'Syntax OK message';
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program, :out;
	my $out = $proc.out;

	is $out.get, 2, 'First prime is 2';
	is $out.get, 3, 'Second prime is 3';

	$out.lines(498);

	is $out.get, 3581, '501th prime is 3581';

	$out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with no arguments";

subtest {
	my $proc = run $*EXECUTABLE, $program, 2, 10, :out;
	my $out = $proc.out;

	my @lines = $out.lines;

	is @lines.elems, 4, 'There are four primes';
	is @lines, qw/2 3 5 7/, 'Prime list is correct';

	$out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with with args 2 and 10";

subtest {
	my $proc = run $*EXECUTABLE, $program, 2, 2, :out;
	my $out = $proc.out;

	my @lines = $out.lines;

	is @lines, qw/2/, 'There is one prime';

	$out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with with args 2 and 2";

subtest {
	my $proc = run $*EXECUTABLE, $program, 2, 1, :out;
	my $out = $proc.out;

	my @lines = $out.lines;
	is @lines.elems, 0, 'No primes';

	$out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with with args 2 and 1";


done-testing();
