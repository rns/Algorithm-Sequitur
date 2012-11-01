use strict;
use warnings;

use Test::More tests => 3;

BEGIN { 
    use_ok 'Algorithm::Sequitur';
}

my @text = split //, "In the beginning, God created the heavens and the earth.
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
And God created great whales, and every living creature that moveth, which the waters brought forth abundantly, after their kind, and every winged fowl after his kind: and God saw that it was good.";

=pod
pease porridge hot,
pease porridge cold,
pease porridge in the pot,
nine days old.

some like it hot,
some like it cold,
some like it in the pot,
nine days old.
=cut

my $result = <<EOR;
Usage   Rule
 0  R0 -> R1 R1 R2 
 2  R1 -> R3 R3 
 2  R2 -> a b c d e f 
 2  R3 -> R2 1 
EOR

my $s = Algorithm::Sequitur->new;
isa_ok $s, 'Algorithm::Sequitur';

$s->build(\@text);
is $s->first_rule->getRules, $result, "The generated grammar is correct";

