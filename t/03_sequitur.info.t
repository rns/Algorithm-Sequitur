use 5.010;
use strict;
use warnings;

use Test::More tests => 7;

use Test::Differences;

BEGIN { 
    use_ok 'Algorithm::Sequitur';
}

for my $test (

[

q{abcabdabcabd},

q{Usage    Rule
 0    R0 -> R1 R1 
 2    R1 -> R2 c R2 d 
 2    R2 -> a b}
  
],

[

q{pease porridge hot,
pease porridge cold,
pease porridge in the pot,
nine days old.

some like it hot,
some like it cold,
some like it in the pot,
nine days old.},

q{Usage    Rule
 0    R0 -> R1 R2 R3 R4 R3 R5 \n \n R6 R2 R7 R4 R7 R5 
 2    R1 -> p e a s R8 p o r r i d g R8 
 2    R2 -> h R9 
 2    R3 -> R10 R1 
 2    R4 -> c R11 
 2    R5 -> R12 _ t h R8 p R9 R10 n R12 R8 d a y s _ R11 . 
 2    R6 -> s o m R8 l i k R8 i t _ 
 2    R7 -> R10 R6 
 6    R8 -> e _ 
 2    R9 -> o t 
 3    R10 -> , \n 
 2    R11 -> o l d 
 2    R12 -> i n}

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
 0    R0 -> I R1 R2 g R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 . R13 R12 _ R14 R15 i R16 R17 R18 R19 m R20 v o R21 R22 R23 R15 a R24 R25 R26 e p R27 S p R28 R29 R30 R6 R31 R32 R25 R33 R34 R35 R36 R37 R38 R35 R39 w R40 R35 R5 R41 R42 R43 R44 R45 R46 R47 R44 D a y R48 R46 _ R49 R50 N R51 R52 R53 R54 R55 R34 a _ R56 R3 R40 m R21 R54 R57 R58 R59 R60 R33 R61 R62 R63 R64 R20 R43 R65 R66 R67 R68 R64 R61 R67 R69 R64 R70 R56 H R71 R52 R72 c R73 R74 R75 R68 R40 R10 R76 R77 R78 R32 R79 R80 R81 R73 R82 p R83 c e R58 R18 R84 R85 a p p R86 R70 R85 E R87 R16 R22 R84 R77 R88 R89 R79 R57 _ R50 R49 S R90 R91 R41 R92 R93 R89 R94 R84 R95 R48 R96 R97 R96 R98 R99 R100 R101 R102 R36 R103 R93 R104 R94 R105 R95 _ R98 R106 R97 R107 R108 R5 R99 R38 R101 R109 R91 R110 R111 R16 R28 R74 R37 R112 R113 R60 R55 R114 n R51 R22 R115 R116 R117 n R118 R116 R90 R73 R118 R119 R55 R118 y R86 s R120 R121 R115 R119 R113 g R122 R123 R103 R6 R124 w o R125 R18 R35 s ; R126 R125 R8 R127 R55 R48 R128 R72 R127 R129 R120 R130 R124 R130 s t R87 R11 l s o R131 e R18 R132 m _ R133 R134 R84 R135 R136 o R137 R122 R5 R121 R81 r u R138 _ R139 R55 R140 R139 R129 R20 R81 R60 R35 _ R141 R126 _ R46 R142 R111 R143 R144 R145 R55 R92 R75 R146 R89 R147 R148 R149 R150 h a R145 R151 f e R20 R152 R153 R18 R154 R155 f R156 _ R69 R148 R86 R145 R133 o p e R157 R134 R135 R62 R158 R65 g R159 R18 R160 a R128 R161 R151 R150 R31 R16 R5 R160 i c h R148 R33 _ R146 R104 R147 R5 R162 R132 R28 _ k R3 d R161 w R163 R65 R152 _ R109 R142 R164 . 
 2    R1 -> R157 R84 
 3    R2 -> b e 
 6    R3 -> i n 
 3    R4 -> n R163 
 11    R5 -> , _ 
 6    R6 -> G o R32 
 2    R7 -> c R159 
 4    R8 -> t e 
 3    R9 -> R32 R84 
 2    R10 -> h R71 
 2    R11 -> R24 a 
 2    R12 -> R165 R166 r R16 
 3    R13 -> \n A 
 3    R14 -> w a 
 2    R15 -> R24 w 
 9    R16 -> t h 
 2    R17 -> o u 
 14    R18 -> t _ 
 3    R19 -> R143 r 
 8    R20 -> R5 R105 
 4    R21 -> i d 
 3    R22 -> ; R140 
 2    R23 -> R167 r k n e s 
 6    R24 -> s _ 
 2    R25 -> R168 f a c e _ R30 R84 
 3    R26 -> d e 
 2    R27 -> R169 A R165 
 4    R28 -> i r 
 4    R29 -> i R18 
 5    R30 -> o f _ 
 2    R31 -> R149 R170 
 10    R32 -> d _ 
 5    R33 -> R14 R8 r s 
 2    R34 -> R92 R37 R2 _ 
 8    R35 -> R151 g h t 
 4    R36 -> : R140 
 3    R37 -> R78 _ 
 4    R38 -> R14 R24 
 2    R39 -> R131 a 
 5    R40 -> _ R84 
 2    R41 -> R110 R59 R38 g o o d 
 2    R42 -> R36 R6 
 3    R43 -> R171 v R21 
 2    R44 -> e R9 R35 _ 
 2    R45 -> R141 R40 
 3    R46 -> R23 s 
 2    R47 -> R62 R172 
 3    R48 -> R20 R84 
 2    R49 -> h R82 
 2    R50 -> R172 R65 
 2    R51 -> i R173 
 2    R52 -> R27 e R174 R163 R140 R84 R149 r R4 R175 R176 
 2    R53 -> f R28 
 2    R54 -> s R18 
 7    R55 -> R167 y 
 4    R56 -> R177 R18 
 2    R57 -> R30 R66 
 2    R58 -> R20 l e 
 2    R59 -> R18 R29 
 3    R60 -> R43 R176 
 2    R61 -> R114 R33 
 4    R62 -> R178 R6 
 2    R63 -> R154 R26 
 3    R64 -> R40 R177 t 
 5    R65 -> e R32 
 3    R66 -> R84 R33 
 2    R67 -> R179 h i c h R175 R82 
 2    R68 -> R80 R26 r 
 2    R69 -> R180 R181 
 2    R70 -> R36 R29 R38 s o R47 R65 R84 
 2    R71 -> R166 R174 
 5    R72 -> s e 
 3    R73 -> o n 
 2    R74 -> R32 R55 R92 
 2    R75 -> R66 _ 
 2    R76 -> _ R112 
 2    R77 -> g a 
 2    R78 -> R88 e 
 2    R79 -> R182 g e R88 _ 
 3    R80 -> u n 
 5    R81 -> R182 _ 
 7    R82 -> e _ 
 2    R83 -> l a 
 19    R84 -> R132 _ 
 2    R85 -> d r y _ R83 n R32 
 5    R86 -> R166 r 
 2    R87 -> a r 
 3    R88 -> R132 r 
 5    R89 -> R163 _ 
 2    R90 -> R166 s 
 2    R91 -> R42 s a w _ 
 4    R92 -> R39 R21 R5 L e R18 
 2    R93 -> R84 R86 R145 b r 
 2    R94 -> R183 g r R184 s R5 
 2    R95 -> R185 r b _ R186 R187 
 2    R96 -> R107 R29 
 2    R97 -> t r e R82 R186 
 2    R98 -> R109 R5 
 2    R99 -> R160 o R72 _ R187 _ 
 2    R100 -> i R24 
 2    R101 -> R188 R108 R72 l f R5 
 2    R102 -> R168 R86 R16 
 2    R103 -> R189 s o R178 
 2    R104 -> R17 R173 _ 
 5    R105 -> a n R32 
 2    R106 -> R105 R84 
 2    R107 -> R190 u 
 3    R108 -> i t 
 3    R109 -> R162 h R100 k R3 d 
 3    R110 -> R16 a 
 2    R111 -> R164 R178 R84 e R174 R89 R106 R149 r R4 R175 R176 
 2    R112 -> R2 _ 
 2    R113 -> R35 R24 R188 R84 R56 R30 R84 R185 a R174 _ R81 
 2    R114 -> _ R45 
 2    R115 -> R138 R18 R132 m R76 
 2    R116 -> R119 s 
 2    R117 -> i g 
 3    R118 -> s R20 
 3    R119 -> R19 _ 
 3    R120 -> : _ 
 2    R121 -> R13 n R32 
 2    R122 -> i R170 R191 R102 
 2    R123 -> R120 R105 
 2    R124 -> R63 R136 
 2    R125 -> R137 R159 
 4    R126 -> R136 R185 
 2    R127 -> r R191 R81 r u R138 R126 _ 
 2    R128 -> R138 s 
 2    R129 -> n R117 h t 
 2    R130 -> R185 _ 
 2    R131 -> R62 s 
 5    R132 -> R16 e 
 2    R133 -> R188 R84 
 2    R134 -> R56 R30 
 2    R135 -> R185 a R174 
 4    R136 -> _ t 
 2    R137 -> _ g 
 4    R138 -> l e 
 2    R139 -> R181 r R126 _ 
 4    R140 -> _ R105 
 2    R141 -> R190 o m 
 2    R142 -> R123 R6 s a w R153 
 3    R143 -> f o 
 2    R144 -> u r 
 5    R145 -> R16 _ 
 2    R146 -> b r 
 2    R147 -> R183 R180 R80 R167 n t R156 
 3    R148 -> R192 R82 
 4    R149 -> m o 
 2    R150 -> v R89 R158 R144 R82 R110 R18 
 3    R151 -> l i 
 2    R152 -> R143 w l 
 2    R153 -> R192 a 
 3    R154 -> m a 
 2    R155 -> y _ 
 2    R156 -> l y 
 2    R157 -> n _ 
 2    R158 -> R7 t 
 3    R159 -> r R166 
 3    R160 -> w h 
 2    R161 -> R20 e R170 r R155 
 2    R162 -> a f R8 r _ 
 4    R163 -> R3 g 
 2    R164 -> R18 R189 g o o d 
 2    R165 -> n R9 
 5    R166 -> e a 
 3    R167 -> d a 
 2    R168 -> u p o R1 
 2    R169 -> . _ 
 5    R170 -> v e 
 2    R171 -> d i 
 2    R172 -> c a l l 
 2    R173 -> g h t 
 5    R174 -> R170 n 
 3    R175 -> R179 e r 
 3    R176 -> R82 R84 
 2    R177 -> R53 R154 m e n 
 3    R178 -> R169 R13 n R32 
 3    R179 -> _ w 
 2    R180 -> a b 
 2    R181 -> o R170 
 2    R182 -> t o 
 2    R183 -> R19 R145 
 2    R184 -> a s 
 5    R185 -> h e 
 2    R186 -> y i e l R171 n g _ 
 2    R187 -> R72 e d 
 3    R188 -> R3 _ 
 2    R189 -> R108 R179 R184 _ 
 2    R190 -> f r 
 2    R191 -> _ R35 _ 
 2    R192 -> R136 h}

]

)
{

    my ($input, $expected) = @$test;

    my @input = split //, $input;

    my $s = Algorithm::Sequitur->new;
    isa_ok $s, 'Algorithm::Sequitur';

    $s->build(\@input);
    my $grammar = $s->first_rule->getRules;
    $grammar =~ s/\t/    /g;
    unless (eq_or_diff_text $grammar, $expected, "The generated grammar is correct"){
        say $grammar;
    }

} # for my $test
