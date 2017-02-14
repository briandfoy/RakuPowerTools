#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin false>;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err;
	my $output = $proc.out.slurp-rest( :close );
	$ = $proc.err.close;
	is $output, "Syntax OK\n";
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program;
	is $proc.exitcode, 1, 'exit code';
	}, "{$program} exits with false value";

done-testing();
