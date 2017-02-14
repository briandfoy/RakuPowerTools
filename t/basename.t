#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin basename>;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err;
	my $output = $proc.out.slurp-rest( :close );
	$ = $proc.err.close;
	is $output, "Syntax OK\n";
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program, :err;
	$ = $proc.err.slurp-rest( :close );
	is $proc.exitcode, 2, 'exit code';
	}, "{$program} no arguments";

subtest {
	my $proc = run $*EXECUTABLE, $program, qw/a b/, :err;
	$ = $proc.err.slurp-rest( :close );
	is $proc.exitcode, 2, 'exit code';
	}, "{$program} with two arguments";

subtest {
	my @parts = ( $*SPEC.rootdir, slip qw/usr local bin perl6/ );
	my $path = $*SPEC.catfile( @parts.flat );
	my $expected = @parts[*-1];
	my $proc = run $*EXECUTABLE, $program, $path, :out;
	is $proc.out.get, $expected, 'Got the path';
	$ = $proc.out.close;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with path";

done-testing();
