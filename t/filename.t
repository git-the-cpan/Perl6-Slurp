use Test::More "no_plan";
BEGIN {use_ok(Perl6::Slurp)};

my $desc;
sub TEST { $desc = $_[0] };

open FH, '>data' or exit;
print FH map "data $_\n", 1..20;
close FH;

open FH, 'data' or exit;
my $pos = tell *FH;

my $data = do { local $/; <FH> };
seek *FH, 0, 0;
my @data = <FH>;
close FH;

TEST "scalar slurp from 'data' in main";
$str = slurp 'data';
is $str, $data, $desc;

TEST "list slurp from 'data' in main";
@str = slurp 'data';
is_deeply \@str, \@data, $desc;

for my $mode (qw( < +< )) {
	TEST "scalar slurp from '${mode}data' in main";
	$str = slurp "${mode}data";
	is $str, $data, $desc;

	TEST "scalar slurp from '$mode data' in main";
	$str = slurp "$mode data";
	is $str, $data, $desc;

	TEST "scalar slurp from '$mode', 'data' in main";
	$str = slurp $mode, 'data';
	is $str, $data, $desc;

	TEST "list slurp from '${mode}data' in main";
	@str = slurp "${mode}data";
	is_deeply \@str, \@data, $desc;

	TEST "list slurp from '$mode data' in main";
	@str = slurp "$mode data";
	is_deeply \@str, \@data, $desc;

	TEST "list slurp from '$mode', 'data' in main";
	@str = slurp $mode, 'data';
	is_deeply \@str, \@data, $desc;
}

unlink 'data';
