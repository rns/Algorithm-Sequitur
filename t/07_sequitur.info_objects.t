use 5.010;
use strict;
use warnings;
use Algorithm::Sequitur;

package word;

sub new{
    my $class = shift;
    my $self = {};
    $self->{value} = shift;
    $self->{package} = __PACKAGE__;
    
    bless $self, $class;
}

# define stringification and string comparison
use overload 
    '""'    => sub { $_[0]->{value} },           
    "eq"    => sub { $_[0]->{value} eq $_[1] },  
    ;

# override to avoid rules formation across the symbol, 0 by default
sub is_delimiter{ $_[0]->{value} eq '0' }

package main;

use Test::More tests => 2;

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
 0    R0 -> R1 hot R2 cold R2 R3 0 R4 hot R5 cold R5 R3 0 
 2    R1 -> pease porridge 
 2    R2 -> , R1 
 2    R3 -> in the pot , nine days old 
 2    R4 -> some like it 
 2    R5 -> , R4}

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
 0    R0 -> In the beginning , God created the heavens and R1 0 And R1 was without form R2 void R3 darkness was R4 deep 0 R5 Spirit of God moved R4 waters 0 R6 light R7 there was light 0 R8 saw R9 , R10 R11 divided R12 0 R13 R9 Day R2 R14 he called Night 0 R15 first day 0 R6 a firmament R16 midst R17 R18 it divide R19 R20 0 R21 R22 R2 divided R19 R23 under R22 R20 R23 above R22 R24 0 R13 R22 Heaven 0 R15 second day 0 R25 under R26 be gathered together unto one place R18 R27 appear R24 0 R13 R27 Earth R3 the gathering together R17 called he Seas R28 0 R29 R1 bring R30 the R31 R32 fruit R33 R34 R35 is R36 R37 0 R5 earth brought R30 and R31 R34 and the R33 , R35 was R36 R38 0 R15 third day 0 R6 R39 divide R40 from R41 R3 R42 signs R43 seasons R43 days R2 years : And R42 R39 R44 R37 0 R21 two great lights ; the greater R45 R40 R32 lesser R45 R41 : he made the stars also 0 R8 set them R16 R46 R26 to R44 R47 , And to rule over R40 and over R41 R2 to divide R12 R28 0 R15 fourth day 0 R25 bring R48 the moving R49 hath life R2 fowl that may fly above R1 R16 open R46 heaven 0 R8 created great whales R50 living R49 moveth , which R19 brought R48 , after their kind R50 winged fowl R38 0 
 4    R1 -> the earth 
 10    R2 -> , and 
 3    R3 -> ; and 
 2    R4 -> R51 face of the 
 3    R5 -> And the 
 3    R6 -> R29 there be 
 3    R7 -> : and 
 6    R8 -> And God 
 3    R9 -> the light 
 2    R10 -> that R52 good 
 2    R11 -> R7 God 
 2    R12 -> R9 from R14 
 3    R13 -> R8 called 
 2    R14 -> the darkness 
 4    R15 -> R5 evening and the morning were the 
 4    R16 -> in the 
 2    R17 -> of R19 
 2    R18 -> R2 let 
 6    R19 -> the waters 
 2    R20 -> from R19 
 2    R21 -> R8 made 
 4    R22 -> the firmament 
 2    R23 -> which were 
 3    R24 -> R7 R52 so 
 2    R25 -> R29 R19 
 3    R26 -> the heaven 
 2    R27 -> the dry land 
 3    R28 -> R11 saw R10 
 3    R29 -> R8 said , Let 
 2    R30 -> forth grass , 
 2    R31 -> herb yielding seed 
 2    R32 -> R2 the 
 2    R33 -> tree yielding fruit 
 2    R34 -> R53 , 
 2    R35 -> whose seed 
 2    R36 -> in itself , 
 2    R37 -> R47 R24 
 2    R38 -> R53 R28 
 2    R39 -> lights R16 firmament of R26 to 
 3    R40 -> the day 
 3    R41 -> the night 
 2    R42 -> let them be for 
 2    R43 -> R2 for 
 2    R44 -> give light 
 2    R45 -> light to rule 
 2    R46 -> firmament of 
 2    R47 -> R51 earth 
 2    R48 -> forth abundantly 
 2    R49 -> creature that 
 2    R50 -> R2 every 
 2    R51 -> upon the 
 2    R52 -> it was 
 2    R53 -> after his kind}

]

){

    my ($input, $expected) = @$test;

    my @input = 
            grep { $_ } 
                map { s/^\s+//; s/\s+$//; $_ } 
                    split /(\w+)/, $input;

    my $s = Algorithm::Sequitur->new;
    
    for my $token (@input){
        # don't form rules across sentence boundaries
        $s->add(word->new(
            $token ~~ [ '.' ] ? '0' : $token
        ));
    }
    
    my $grammar = $s->first_rule->getRules;
    $grammar =~ s/\t/    /g;
    unless (is $grammar, $expected, "The generated grammar is correct"){
        say "# input:\n", $input, "\n# grammar:\n", $grammar;
    }

} # for my $test
