use strict;
use warnings;

use Test::More tests => 3;

BEGIN { 
    use_ok 'Algorithm::Sequitur';
}

my @text = split //, "abcdef1abcdef1abcdef1abcdef1abcdef";

my $result = q{Usage    Rule
 0    R0 -> R1 R1 R2 
 2    R1 -> R3 R3 
 2    R2 -> a b c d e f 
 2    R3 -> R2 1};

my $s = Algorithm::Sequitur->new;
isa_ok $s, 'Algorithm::Sequitur';

$s->build(\@text);
my $grammar = $s->first_rule->getRules;
$grammar =~ s/\t/    /g;
is $grammar, $result, "The generated grammar is correct";

