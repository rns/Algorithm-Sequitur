Sequitur [0] is a linear-time algorithm identifying hierarchical structure in sequences [1].

Example from [0]: abcabdabcabd

	Rule                 Expansion
	----------------     ---------
	S -> 0 -> 1 1 \n                                       
	1 -> 2 c 2 d         abcabd
	2 -> a b             ab

Sequitur is implemented in Java [3], C++ [4], and ObjectPascal [5]. 

This module is to implement Sequitur in Perl.

[0] http://sequitur.info/

[1] http://sequitur.info/jair/

[3] http://sequitur.info/java/

[4] http://sequitur.info/sequitur_simple.cc

[5] http://sequitur.info/grammar_compression.tar.gz
