use Test::More "no_plan";
use utf8;
BEGIN {use_ok(Perl6::Slurp)};

my $desc;
sub TEST { $desc = $_[0] };

open FH, '>:utf8', 'data' or exit;
print FH map chr, 0..0x1FF;
close FH;

undef $/;

my @layers = ( qw(:raw :bytes :unix :stdio :perlio :crlf :utf8),
			   ":raw :utf8",
			   ":raw:utf8",
			 );


for my $layer (@layers) {
	open FH, "<$layer", 'data' or exit;
	$data{$layer} = <FH>;
	$len{$layer}  = length $data{$layer};
	close FH;
}

for my $layer (@layers) {
	TEST "scalar slurp from '<$layer', 'data'";
	$str = slurp "<$layer", 'data';
	is $data{$layer}, $str, $desc;
	ok length($str) == $len{$layer}, "length of $desc";

	TEST "scalar slurp from '< $layer', 'data'";
	$str = slurp "< $layer", 'data';
	is $data{$layer}, $str, $desc;
	ok length($str) == $len{$layer}, "length of $desc";
}

%opts = (
	':raw'       => [{raw=>1}],
	':utf8'      => [{utf8=>1}],
	':raw :utf8' => [{raw=>1}, {utf8=>1}],
	':raw:utf8'  => [[raw=>1, utf8=>1]],
);

for my $layer (keys %opts) {
	local $" = ", ";
	TEST "scalar option slurp from 'data', $layer";
	$str = slurp 'data', @{$opts{$layer}};
	is $data{$layer}, $str, $desc;
	ok length($str) == $len{$layer}, "length of $desc";

	TEST "scalar option slurp from $layer, 'data'";
	$str = slurp @{$opts{$layer}}, 'data';
	is $data{$layer}, $str, $desc;
	ok length($str) == $len{$layer}, "length of $desc";

}

unlink 'data';
