#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin true>;

my $null_fh = $*SPEC.devnull.IO.open;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err($null_fh);
	my $output = $proc.out.slurp-rest( :close );
	is $output, "Syntax OK\n";
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} exits with true value";

done-testing();
