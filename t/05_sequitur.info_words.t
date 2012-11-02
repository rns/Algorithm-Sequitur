use 5.010;
use strict;
use warnings;

use Test::More tests => 5;

use_ok 'Algorithm::Sequitur';

for my $test (

[

q{pease porridge hot,
pease porridge cold,
pease porridge in the pot,
nine days old.

some like it hot,
some like it cold,
some like it in the pot,
nine days old.
},

q{Usage    Rule
 0    R0 -> R1 hot R1 cold R1 R2 R3 hot R3 cold R3 R2 
 3    R1 -> pease porridge 
 2    R2 -> in the pot nine days old 
 3    R3 -> some like it}

],

[

q{In the beginning, God created the heavens and the earth.
And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters. 
And God said, Let there be light: and there was light. 
And God saw the light, that it was good: and God divided the light from the darkness. 
And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day. 
And God said, Let there be a firmament in the midst of the waters, and let it divide the waters from the waters. 
And God made the firmament, and divided the waters which were under the firmament from the waters which were above the firmament: and it was so. 
And God called the firmament Heaven. And the evening and the morning were the second day. 
And God said, Let the waters under the heaven be gathered together unto one place, and let the dry land appear: and it was so. 
And God called the dry land Earth; and the gathering together of the waters called he Seas: and God saw that it was good. 
And God said, Let the earth bring forth grass, the herb yielding seed, and the fruit tree yielding fruit after his kind, whose seed is in itself, upon the earth: and it was so. 
And the earth brought forth grass, and herb yielding seed after his kind, and the tree yielding fruit, whose seed was in itself, after his kind: and God saw that it was good. 
And the evening and the morning were the third day. 
And God said, Let there be lights in the firmament of the heaven to divide the day from the night; and let them be for signs, and for seasons, and for days, and years: 
And let them be for lights in the firmament of the heaven to give light upon the earth: and it was so. 
And God made two great lights; the greater light to rule the day, and the lesser light to rule the night: he made the stars also. 
And God set them in the firmament of the heaven to give light upon the earth, 
And to rule over the day and over the night, and to divide the light from the darkness: and God saw that it was good. 
And the evening and the morning were the fourth day. 
And God said, Let the waters bring forth abundantly the moving creature that hath life, and fowl that may fly above the earth in the open firmament of heaven. 
And God created great whales, and every living creature that moveth, which the waters brought forth abundantly, after their kind, and every winged fowl after his kind: and God saw that it was good.},

q{Usage    Rule
 0    R0 -> In the beginning God created the heavens and R1 And R1 was without form and void and darkness was R2 deep R3 Spirit of God moved R2 waters R4 light and there was light R5 saw R6 R7 R8 divided R9 R10 R6 Day and R11 he called Night R12 first day R4 a firmament R13 midst R14 R15 it divide R16 R17 R18 R19 divided R16 R20 under R21 R17 R20 above R19 R22 R21 Heaven R12 second R23 under R24 be gathered together unto one place R15 R25 appear and R22 R25 Earth R26 gathering together R14 called he Seas R27 R28 R1 bring R29 the R30 R26 fruit R31 R32 R33 is R34 R35 R3 earth brought R29 and R30 R32 R26 R31 R33 was R34 R32 R36 third R37 there be R38 divide R39 from R40 R15 R41 signs R42 seasons R42 days and years And let R41 R38 R43 R35 R18 two great lights the greater R44 R39 R26 lesser R44 R40 he made the stars also R5 set them R13 R45 R24 to R43 R46 And to rule over R39 and over R40 and to divide R9 R36 fourth R23 bring R47 the moving R48 hath life and fowl that may fly above R1 R13 open R45 heaven R5 created great whales R49 living R48 moveth which R16 brought R47 after their kind R49 winged fowl R32 R27 
 4    R1 -> the earth 
 2    R2 -> R50 face of the 
 3    R3 -> And the 
 2    R4 -> R28 there be 
 6    R5 -> And God 
 3    R6 -> the light 
 2    R7 -> that R51 good 
 2    R8 -> and God 
 2    R9 -> R6 from R11 
 2    R10 -> R5 called 
 2    R11 -> the darkness 
 3    R12 -> R3 evening and the morning were the 
 4    R13 -> in the 
 2    R14 -> of R16 
 3    R15 -> and let 
 6    R16 -> the waters 
 2    R17 -> from R16 
 2    R18 -> R5 made 
 2    R19 -> R21 and 
 2    R20 -> which were 
 3    R21 -> the firmament 
 2    R22 -> R52 R10 
 2    R23 -> R37 R16 
 3    R24 -> the heaven 
 2    R25 -> the dry land 
 4    R26 -> and the 
 3    R27 -> R8 saw R7 
 3    R28 -> R5 said Let 
 2    R29 -> forth grass 
 2    R30 -> herb yielding seed 
 2    R31 -> tree yielding fruit 
 4    R32 -> after his kind 
 2    R33 -> whose seed 
 2    R34 -> in itself 
 2    R35 -> R46 and R52 
 2    R36 -> R27 R12 
 2    R37 -> day R28 
 2    R38 -> lights R13 firmament of R24 to 
 3    R39 -> the day 
 3    R40 -> the night 
 2    R41 -> them be for 
 2    R42 -> and for 
 2    R43 -> give light 
 2    R44 -> light to rule 
 2    R45 -> firmament of 
 2    R46 -> R50 earth 
 2    R47 -> forth abundantly 
 2    R48 -> creature that 
 2    R49 -> and every 
 2    R50 -> upon the 
 2    R51 -> it was 
 2    R52 -> R51 so}

]

){

    my ($input, $expected) = @$test;

    my @input = 
        grep { /\w/ }                               # words only
            grep { $_ }                             # non-empty strings only
                map { s/^\s+//; s/\s+$//; $_ }      # trimm
                    split /(\w+)/,                  # words and whitespaces
                        $input;

    my $s = Algorithm::Sequitur->new;
    isa_ok $s, 'Algorithm::Sequitur';

    $s->build(\@input);
    my $grammar = $s->first_rule->getRules;

    $grammar =~ s/\t/    /g;

    unless (is $grammar, $expected, "The generated grammar is correct"){
        say $grammar;
    }

} # for my $test
