# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..53\n"; }
END {print "not ok 1\n" unless $loaded;}
use Text::Balanced qw ( extract_quotelike );
$loaded = 1;
print "ok 1\n";
$count=2;
use vars qw( $DEBUG );
sub debug { print "\t>>>",@_ if $DEBUG }

######################### End of black magic.


$cmd = "print";
$neg = 0;
while (defined($str = <DATA>))
{
	chomp $str;
	$str =~ s/\\n/\n/g;
	if ($str =~ s/\A# USING://) { $neg = 0; $cmd = $str; next; }
	elsif ($str =~ /\A# TH[EI]SE? SHOULD FAIL/) { $neg = 1; next; }
	elsif (!$str || $str =~ /\A#/) { $neg = 0; next }
	$str =~ s/\\n/\n/g;
	debug "\tUsing: $cmd\n";
	debug "\t   on: [$str]\n";

	my @res;
	$var = eval "\@res = $cmd";
	debug "\t list got: [" . join("|",@res) . "]\n";
	debug "\t list left: [$str]\n";
	print "not " if (substr($str,pos($str),1) eq ';')==$neg;
	print "ok ", $count++;
	print " ($@)" if $@ && $DEBUG;
	print "\n";

	pos $str = 0;
	$var = eval $cmd;
	$var = "<undef>" unless defined $var;
	debug "\t scalar got: [$var]\n";
	debug "\t scalar left: [$str]\n";
	print "not " if ($str =~ '\A;')==$neg;
	print "ok ", $count++;
	print " ($@)" if $@ && $DEBUG;
	print "\n";
}

__DATA__

# USING: extract_quotelike($str);


"a";
'b';
`cc`;

q(d);
qq(e);
qx(f);
qr(g);
qw(h i j);
q{d};
qq{e};
qx{f};
qr{g};
qq{a nested { and } are okay as are () and <> pairs and escaped \}'s };
q/slash/;
q # slash #;
qr qw qx;

s/x/y/;
s/x/y/cgimsox;
s{a}{b};
s{a}\n {b};
s(a){b};
s(a)/b/;
tr/x/y/;
y/x/y/;

# THESE SHOULD FAIL
s<$self->{pat}>{$self->{sub}};
s-$self->{pap}-$self->{sub}-;