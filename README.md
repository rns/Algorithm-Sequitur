[Sequitur](http://sequitur.info/) is a [linear-time algorithm identifying hierarchical structure in sequences](http://sequitur.info/jair/).

Example: 

  Sequence: 
  
  	abcabdabcabd\n

	Grammar:

		Rule                 Expansion
		----------------     ---------
		S -> 0 -> 1 1 \n                                       
		1 -> 2 c 2 d         abcabd
		2 -> a b             ab

Sequitur is implemented in [Java](http://sequitur.info/java/), [C++](http://code.google.com/p/sequitur/), and [ObjectPascal](http://sequitur.info/grammar_compression.tar.gz). 

This module is to implement Sequitur in Perl.
