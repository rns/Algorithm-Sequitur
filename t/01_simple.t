use strict;
use warnings;

use Test::More tests => 3;

BEGIN { 
    use_ok 'Algorithm::Sequitur';
}

my @text = split //, "abcdef1abcdef1abcdef1abcdef1abcdef";

my $result = <<EOR;
Usage	Rule
 0	R0 -> R1 R1 R2 
 2	R1 -> R3 R3 
 2	R2 -> a b c d e f 
 2	R3 -> R2 1 
EOR

my $s = Algorithm::Sequitur->new;
isa_ok $s, 'Algorithm::Sequitur';

$s->build(\@text);
is $s->first_rule->getRules, $result, "The generated grammar is correct";

