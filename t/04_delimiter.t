use 5.010;
use strict;
use warnings;

use Test::More tests => 3;

use_ok 'Algorithm::Sequitur';

my @text = split //, "abc0def1abc0def0abc0def0abc0def0abc0def";

my $result = q{Usage    Rule
 0    R0 -> R1 0 R2 1 R1 0 R2 0 R1 0 R2 0 R1 0 R2 0 R1 0 R2 
 5    R1 -> a b c 
 5    R2 -> d e f};

my $s = Algorithm::Sequitur->new;

isa_ok $s, 'Algorithm::Sequitur';

for my $char (@text){
    $s->add(Algorithm::Sequitur::Item->new($char));
}

my $grammar = $s->first_rule->getRules;
$grammar =~ s/\t/    /g;
unless (is $grammar, $result, "The generated grammar is correct"){
    say $grammar;
}

