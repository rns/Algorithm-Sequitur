# Perl port of SEQUITUR algorithm [1] devised by Craig Nevill-Manning [2] and
# Ian Witten [3]
#
# Translated into Perl from Java port [4] by Eibe Frank [5]
# 
# References:
#   [1] http://sequence.rutgers.edu/sequitur/
#   [2] http://craig.nevill-manning.com
#   [3] http://www.cs.waikato.ac.nz/~ihw
#   [4] http://sequence.rutgers.edu/sequitur/java/
#   [5] http://www.cs.waikato.ac.nz/~eibe

use strict;
use warnings;

my $numRules = 0;
my $numTerminals = 100000;
my $prime = 2265539;
my %theDigrams;
my $firstRule;

# convenience globals
my ($VERSION, $DEBUG, $LOG);
$VERSION = "0.8";
$DEBUG   = 0;
$LOG     = \*STDERR;

# for debug purposes only: to print short class names
my %class_map = (
    'Algorithm::Sequitur::NonTerminal' => 'nonTerminal',
    'Algorithm::Sequitur::Terminal' => 'terminal',
);

package Algorithm::Sequitur::Rule;
# ABSTRACT: Perl port of Sequitur algorithm

sub new{
    my $class = shift;
    my $self = {};

  # The rule's number.
  # Used for identification of
  # non-terminals.

    $self->{number} = $numRules;
  # The total number of rules.

    $numRules++;

  # Guard symbol to mark beginning
  # and end of rule.

    $self->{theGuard} = Algorithm::Sequitur::Guard->new($self);

  # Counter keeps track of how many
  # times the rule is used in the
  # grammar.

    $self->{count} = 0;

  # Index used for printing.
    $self->{index} = 0;
    
    bless $self, $class;
}

sub first{
    return $_[0]->{theGuard}->{n};
}
  
sub last{
    return $_[0]->{theGuard}->{p};
}

sub walk_rules{
}

sub getRules{
    my $self = shift;
    
    my @rules;
    my $currentRule;
    my $referedTo;
    my $sym;
    my $index;
    my $processedRules = 0;
    my $text;
    my $charCounter = 0;

    $text .= "Usage\tRule\n";
    push @rules, $self;
    while ($processedRules < @rules){
        $currentRule = $rules[$processedRules];
        $text .= " ";
        $text .= $currentRule->{count};
        $text .= "\tR";
        $text .= $processedRules;
        $text .= " -> ";
        for ($sym = $currentRule->first(); (!$sym->isGuard()); $sym = $sym->{n}){
            if ($sym->isNonTerminal()){
                $referedTo = $sym->{r};
                if ( @rules > $referedTo->{index} &&
                     $rules[$referedTo->{index}] eq $referedTo ){
                    $index = $referedTo->{index};
                }
                else{
                    $index = @rules;
                    $referedTo->{index} = $index;
                    push @rules, $referedTo;
                }
                $text .= 'R';
                $text .= $index;
            }
            elsif ($sym->{value} eq ' '){
                $text .= '_';
            }
            elsif ($sym->{value} eq "\n"){
                $text .= "\\n";
            }
            else{
                $text .= $sym->{value};
            }
            $text .= ' ';
        }
        $text .= "\n";
        $processedRules++;
    }
    $text =~ s/\s+$//s;
    return $text;
}

package Algorithm::Sequitur::Symbol;

sub new{
    my $class = shift;
    my $self = {};
    $self->{value} = undef;
    $self->{p} = undef;
    $self->{n} = undef;
    bless $self, $class;
}

#
# Links two symbols together, removing any old
# digram from the hash table.
#

sub join{
    my ($left, $right) = @_;

    $DEBUG && print $LOG "symbol::join: joining ",$left->{value}," and ",$right->{value},"\n";

    if (defined $left->{n}){
        $left->deleteDigram();
    }
    $left->{n} = $right;
    $right->{p} = $left;
}

#
# cleans up for symbol deletion.
#  

sub cleanUp{
    my $self = shift;
    $DEBUG && print $LOG "symbol::cleanUp: ",$self->{p}->{value},"/",$self->{value},"/",$self->{n}->{value};
}

#
# Inserts a symbol after this one.
#

sub insertAfter{
    my $self = shift;
    my $toInsert = shift;
    $DEBUG && print $LOG "symbol::insertAfter: inserting ",$toInsert->{value}," after ",$self->{value},"\n";
    &Algorithm::Sequitur::Symbol::join($toInsert,$self->{n});
    &Algorithm::Sequitur::Symbol::join($self,$toInsert);
}

#
#   Removes the digram from the hash table.
#   Overwritten in sub class guard.
#

sub deleteDigram{
    my $self = shift;

    my $dummy;

    if ($self->{n}->isGuard()){
        return;
    }
    $dummy = $theDigrams{$self->hashCode};

    # Only delete digram if its exactly
    # the stored one.

# FIXME? 
# in Java: if ($dummy eq $self){ produces uninitialized value in string eq ... warning
# hence check for defined
    if (defined $dummy && $dummy eq $self){
#       print "symbol::deleteDigram: Deleting ",$self->{value},'/',$self->{n}->{value}," ...\n";
        delete $theDigrams{$self->hashCode};
    }
}

#
# Returns true if this is the guard symbol.
# Overwritten in subclass guard.
#

sub isGuard{
    return 0;
}

#
#   Returns true if this is a non-terminal.
#   Overwritten in subclass nonTerminal.
#

sub isNonTerminal{
    return 0;
}

#
#   Checks a new digram. If it appears
#   elsewhere, deals with it by calling
#   match(), otherwise inserts it into the
#   hash table.
#   Overwritten in subclass guard.
#

sub check{
    my $self = shift;
    
    $DEBUG && print $LOG "symbol::check: checking ",$self->{value},'/',$self->{n}->{value},"\n";

    if ($self->{n}->isGuard()){
#       print "symbol::check: next is the guard\n";
        return 0;
    }
    # check if $self->{n} or $self->{n}->{value} are delimiters
    # return 0 if yes
    return 0 
        if (ref $self->{value} and $self->{value}->is_delimiter)
            or (ref $self->{n}->{value} and $self->{n}->{value}->is_delimiter);
    
    if (!exists $theDigrams{$self->hashCode}){
#       print "symbol::check: found ",$self->{value},'/',$self->{n}->{value}," inserting ...\n";
        $theDigrams{$self->hashCode} = $self;
        return 0;
    }
    my $found = $theDigrams{$self->hashCode};
    if ($found->{n} != $self){
#       print "symbol::check: found ",$self->{value},'/',$self->{n}->{value}," matching ...\n";
        $self->match($self,$found);
    }
    return 1;
 }

#
# Replace a digram with a non-terminal.
#

sub substitute{
    my $self = shift;
    my $r = shift;
    $DEBUG && print $LOG "symbol (",$class_map{ref $self},")::substitute: cleaning up I ",$self->{value},"/",$self->{n}->{value},"\n";
    $self->cleanUp;
    $DEBUG && print $LOG "symbol (",$class_map{ref $self->{n}},")::substitute: cleaning up II ",$self->{n}->{value},"/",$self->{n}->{n}->{value},"\n";
    $self->{n}->cleanUp();
    $self->{p}->insertAfter(Algorithm::Sequitur::NonTerminal->new($r));
    if (!$self->{p}->check()){
#       print "symbol::substitute: checking ",$self->{p}->{n}->{value},"\n";
        $self->{p}->{n}->check();
        }
  }

#
#   Deal with a matching digram.
#

sub match{
    my $self = shift;
    my ($newD, $matching) = @_; 

    $DEBUG && print $LOG "symbol::match: matching ",$newD->{value}," and ",$matching->{value},"\n";
    my $r;
    my ($first,$second);

    if ($matching->{p}->isGuard() &&
        $matching->{n}->{n}->isGuard()){
        # reuse an existing rule
#       print "symbol::match: reusing the existing rule\n";
        $r = $matching->{p}->{r};
        $newD->substitute($r);
    }
    else{

        # create a new rule

#       print "symbol::match: creating new rule\n";
        $r = Algorithm::Sequitur::Rule->new;
        $first = $newD->clone();
        $second = $newD->{n}->clone();
        $r->{theGuard}->{n} = $first;
        $first->{p} = $r->{theGuard};
        $first->{n} = $second;
        $second->{p} = $first;
        $second->{n} = $r->{theGuard};
        $r->{theGuard}->{p} = $second;

        $theDigrams{$first->hashCode} = $first;
#       print "symbol::match: substituting matching\n";
        $matching->substitute($r);
#       print "symbol::match: substituting newD\n";
        $newD->substitute($r);
    }

    # Check for an underused rule.

    if ( $r->first()->isNonTerminal() &&
        ($r->first()->{r}->{count} == 1) ){
#       print "symbol::match: expanding ",$r->first->{value},"\n";
        $r->first()->expand();
    }
}

#
# Produce the hashcode for a digram.
#

sub hashCode{
    my $self = shift;
    my $code;

#   return -1 if $self->{value} eq '1' or $self->{n}->{value} eq '1';
    return "$self->{value}/$self->{n}->{value}";
    # Values in linear combination with two
    # prime numbers. see Knuth :) 
# FIXME? ensure that $ code is long enough like C's and Java's long to use numeric keys
    $code = 21599 * $self->{value} + 20507 * $self->{n}->{value};
    $code = $code % $prime;
    $DEBUG && print $LOG "symbol::hashCode: for ",$self->{value},"/",$self->{n}->{value}," = ",$code,"\n";
    return $code;
}

#
# Test if two digrams are equal.
# WARNING: don't use to compare two symbols.
#

sub equals{
    my $self = shift;
    my $obj = shift;
    
    $DEBUG && print $LOG "symbol::equals: comparing ",$self->{value}," and ",$obj->{value},"\n";
    return $self->{value} == $obj->{value} &&
        $self->{n}->{value} == $obj->{n}->{value};
}

# data inheritance is not directly supported in Perl

sub clone{
    my $self = shift;
    
    my $class = ref $self;
    my $sym = $class->new;
    $sym->{value} = $self->{value};
    $sym->{p} = $self->{p};
    $sym->{n} = $self->{n};
    return $sym;
}

package Algorithm::Sequitur::NonTerminal;

use base 'Algorithm::Sequitur::Symbol';

sub new{
    my $class = shift;
    my $theRule = shift;

    my $self = {};
    $self->{r} = $theRule;
    $self->{r}->{count}++;
    $self->{value} = $numTerminals + $self->{r}->{number};
    $self->{p} = undef;
    $self->{n} = undef;
    bless $self, $class;
}

#
#   Extra cloning method necessary so that
#   count in the corresponding rule is
#   increased.
#

sub clone{
    my $self = shift;
    
    my $sym = Algorithm::Sequitur::NonTerminal->new($self->{r});

    $sym->{p} = $self->{p};
    $sym->{n} = $self->{n};
    return $sym;
}

sub cleanUp{
    my $self = shift;
    $DEBUG && print $LOG "nonTerminal::cleanUp: ",$self->{p}->{value},"/",$self->{value},"/",$self->{n}->{value},"\n";
    &Algorithm::Sequitur::Symbol::join($self->{p},$self->{n});
    $self->deleteDigram();
    $self->{r}->{count}--;
}

sub isNonTerminal{
    return 1;
}

#
#  This symbol is the last reference to
#  its rule. The contents of the rule
#  are substituted in its place.
#

sub expand{
    my $self = shift;
    # check if $self->{n} or $self->{n}->{value} are delimiters
    return 
        if (ref $self->{value} and $self->{value}->is_delimiter)
            or (ref $self->{n}->{value} and $self->{n}->{value}->is_delimiter);
    # return if yes
    &Algorithm::Sequitur::Symbol::join($self->{p},$self->{r}->first());
    &Algorithm::Sequitur::Symbol::join($self->{r}->last(),$self->{n});

    # Necessary so that garbage collector
    # can delete rule and guard.

    undef $self->{r}->{theGuard}->{r};
    undef $self->{r}->{theGuard};
}

package Algorithm::Sequitur::Terminal;

use base 'Algorithm::Sequitur::Symbol';

sub new{
    my $class = shift;
    my $theValue = shift;
    my $self = {};
    $self->{value} = $theValue;
    $self->{p} = undef;
    bless $self, $class;
}

sub cleanUp{
    my $self = shift;
    $DEBUG && print $LOG "terminal::cleanUp: ",$self->{p}->{value},"/",$self->{value},"/",$self->{n}->{value},"\n";
    &Algorithm::Sequitur::Symbol::join($self->{p},$self->{n});
    $self->deleteDigram();
}

package Algorithm::Sequitur::Guard;

use base 'Algorithm::Sequitur::Symbol';

sub new{
    my $class = shift;
    my $theRule = shift;
    my $self = {};
    $self->{r} = $theRule;
    $self->{value} = 0;
    $self->{p} = $self;
    $self->{n} = $self;
    bless $self, $class;
}

sub cleanUp{
    my $self = shift;
    $DEBUG && print $LOG "guard::cleanUp: ",$self->{p}->{value},"/",$self->{value},"/",$self->{n}->{value},"\n";
    &Algorithm::Sequitur::Symbol::join($self->{p},$self->{n});
}

sub isGuard{
    return 1;
}

sub deleteDigram{
    my $self = shift;
    $DEBUG && print $LOG "guard::deleteDigram: deleting ",$self->{value},"/",$self->{n}->{value},"\n";
    # Do nothing
}

sub check{
    my $self = shift;
    $DEBUG && print $LOG "guard::check: checking ",$self->{value},"/",$self->{n}->{value},"\n";
    return 0;
}

package Algorithm::Sequitur::Item;

sub new{
    my $class = shift;
    my $self = {};
    $self->{STR} = shift;
    bless $self, $class;
}

sub str{ $_[0]->{STR} }

use overload 
    "0+" => sub { $_[0]->key },
    "\"\"" => sub { $_[0]->key },
    "eq" => sub { $_[0]->key eq $_[1] },
    "*" => sub { ($_[0]->key) * $_[1] },
    ;

# to be overridden
sub key{ $_[0]->{STR} }
sub is_delimiter{ $_[0]->{STR} eq '0' }

package Algorithm::Sequitur;

sub new{
    my $class = shift;
    
    my %opts = @_;
    $DEBUG = $opts{DEBUG} if $opts{DEBUG};
    $LOG = $opts{LOG} if $opts{LOG};
    
    my $self = {};

    # Reset number of rules and Hashtable.
    $firstRule = Algorithm::Sequitur::Rule->new;
    $numRules = 0;
    undef %theDigrams;

    bless $self, $class;
}

sub build{
    my $self = shift;
    my $items = shift;

    for my $i (0..@$items-1){
        $self->add_item( $items->[$i] );
    }
    return $firstRule;
}

=item add( $item )
    Wraps $item to Algorithm::Sequitur::Item which stringify it as needed
=cut

sub add{
    my $self = shift;
    $self->add_item( 
        Algorithm::Sequitur::Item->new( shift )
    )
}

=item add_item( $item )

    Adds $item to the grammar assuming that $item already has stringification 
    as needed.
    
=cut
sub add_item{
    my $self = shift;
    
    $firstRule->last()->insertAfter( 
        Algorithm::Sequitur::Terminal->new(
            shift
        )
    );
    $firstRule->last()->{p}->check();
    $DEBUG && print $LOG $firstRule->getRules;
    $DEBUG && print $LOG "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n";
}

sub first_rule{
    $firstRule;
}

1;
