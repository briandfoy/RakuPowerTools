#!perl6

use v6;

use Test;

my $program = $*SPEC.catfile: <bin yes>;

my $null_fh = $*SPEC.devnull.IO.open;

subtest {
	ok $program.IO.e, "Program {$program} exists";
	my $proc = run $*EXECUTABLE, '-c', $program, :out, :err($null_fh);
	my $output = $proc.out.slurp-rest( :close );
	is $output, "Syntax OK\n", 'Syntax OK message';
	is $proc.exitcode, 0, 'compile check exit code';
	}, 'Boring setup things';

subtest {
	my $proc = run $*EXECUTABLE, $program, :out;
	my $out = $proc.out;

	is $out.get, 'y', 'First line is "y"';
	is $out.get, 'y', 'Second line is "y"';

	$out.lines(498);

	is $out.get, 'y', '501th line is "y"';

	$out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with no arguments";

subtest {
	my $proc = run $*EXECUTABLE, $program, 'ni', :out;
	my $out = $proc.out;

	is $out.get, 'ni', 'First line is "ni"';
	is $out.get, 'ni', 'Second line is "ni"';

	$out.lines(498);

	is $out.get, 'ni', '501th line is "ni"';

	$out.close.so;
	is $proc.exitcode, 0, 'exit code';
	}, "{$program} with 'ni' argument";


done-testing();
