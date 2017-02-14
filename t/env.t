#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin env>;

my $null_fh = $*SPEC.devnull.IO.open: :w;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err($null_fh);
	my $output = $proc.out.slurp-rest( :close );
	is $output, "Syntax OK\n", "Sees 'Syntax OK' message";
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program, :out($null_fh);
	$proc.out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} exits with true value";

subtest {
	my $proc = run $*EXECUTABLE, $program, '-k', :err;
	my $message = $proc.err.slurp-rest( :close );
	like $message, rx:i/invalid/, 'Invalid option warns';
	is $proc.exitcode, 2, 'exit code';
	}, "{$program} exits with false value with unknown switch";

subtest {
	temp %*ENV = qw/
		ABC    123
		NUMBER 137
		NAME   Hamadryas
		/;
	my $proc = run $*EXECUTABLE, $program, :out;
	my $message = $proc.out.slurp-rest( :close );

	like $message, rx/ ^^ ABC    '=' 123       $$ /, 'ABC is there';
	like $message, rx/ ^^ NUMBER '=' 137       $$ /, 'NUMBER is there';
	like $message, rx/ ^^ NAME   '=' Hamadryas $$ /, 'NAME is there';

	# XXX: Test that the values are there

	# XXX: Test that other values aren't there

	is $proc.exitcode, 0, 'exit code';
	}, "{$program} exits with true value";

done-testing();
