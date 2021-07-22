
d) module
 baum
 Library for working with treetable
 q).import.module`baum

\d .baum

/ construct treetable
construct:{[t;g;p;a]r[1#0],g xasc 1_e:(r:root[t;g;a])block[t;g;a]/visible p}


/ visible paths
visible:{[p]
 q:parent n:exec n from p;
 k:(reverse q scan)each til count q;
 n where all each(exec v from p)k}

/ path-list > parent-vector
parent:{[n]n?-1_'n}

/ instruction > constraint
constraint:{[p]flip(in;key p;flip enlist value p)}

/ construct root block
root:{[t;g;a]
 a[g]:nul,'g;
 (`n_,g)xcols node_[`;g]flip enlist each?[t;();();a]
 }

/ construct a block = node or leaf
block:{[t;g;a;r;p]
 f:$[g~key p;leaf;node g(`,g)?last key p];
 r,(`n_,g)xcols f[t;g;a;p]}

/ construct node block

node:{[b;t;g;a;p]
 c:constraint p;
 a[h]:first,'h:(i:g?b)#g;
 a[h]:{first 1#0#x},'h:(1+i)_g;
 s:?[t;c;enlist[b]!enlist b;a];
 node_[b;g]0!s
 }

/ compute n_ for node block
node_:{[b;g;t]
 num:sum reverse sums reverse b=g;
 f:{x where not null x};
 n:$[count g;num#/:r:flip flip[t]g;enlist til 0];
 if[n~enlist ();n:enlist 0#r . 0 0];
 ![t;();0b;enlist[`n_]!2 enlist/n]
 }

/ construct leaf block
leaf:{[t;g;a;p]
 c:constraint p;
 a:last each a;
 a[g]:g;
 leaf_[g]0!?[t;c;0b;a]}

/ compute n_ for leaf block
leaf_:{[g;t]
 n:flip[flip[t]g],'`$string til count t;
 ![t;();0b;enlist[`n_]!2 enlist/n]}
 
/ keep valid paths
paths:{[p;g]
 n:key each exec n from p;
 i:where til[count g]{(count[y]#x)~y}/:g?/:n;
 1!(0!p)i}

/ open/close to group (h=` > open to leaves)
opento:{[t;g;h]
 k:(1+til count k)#\:k:(g?h)#g;
 n:enlist(0#`)!0#`;
 f:{y,z!/:distinct flip flip[x]z};
 m:distinct n,raze f[t;n]each k;
 ([n:m]v:count[m]#1b)}

/ open/close at a node
at:{[b;p;g;n]p,([n:enlist(count[n]#g)!n,()]v:enlist b)}

openat:at 1b
closeat:at 0b

/ treetable sort
tsort:{[t;c;o]
 n:exec n_ from t;
 i:children[parent n]except enlist();
 j:msort[0!t;c;o]each i;
 I:n?pmesh over n j;
 1!(0!t)I
 }

/ parent-vector > child-list
children:{[p]@[(2+max p)#enlist();first[p],1+1_p;,;til count p]}

/ multi-sort
msort:{[t;c;o;i]i{x y z x}/[til count i;o;flip[t i]c]}

/ mesh nest of paths
pmesh:{i:1+x?-1_first y;(i#x),y,i _ x}

/ predicates (** bugfix 10.18.2015 **)
isopen:{[t;p]key[t][`n_]in value each visible p}
isleaf:{[t;g]count[g]=level t}

/ level of each record
level:{[t]count each key[t]`n_}

/ first if 1=count else null (for syms, non-summable nums)
nul:{first$[1=count distinct x,();x;0#x]}

/ discard invalid paths
valid:{[p;g]
 n:key each exec n from p;
 i:where til[count g]{(count[y]#x)~y}/:g?/:n;
 1!(0!p)i}


parsec:{ parse["select from t where ", x]2}
parseb:{ parse["select by ",x," from t"]3}
parsea:{ parse["select ",x," from t"]4}

open:{[formula;l] if[formula~"";:l]; l,enlist formula}

tbaum:{[t;formula;l]
 G:key parsea first formula:"~~" vs formula;
 A:parsea A:last formula;
 P:([]n:enlist(0#`)!first 0#/:t G;v:enlist 1b); 
 n:raze {((,) scan key x)#\:x}@'{first@'parsea x}@'l;
 P:1!P,([]n;v:1b);
 1!construct[t;G;P;A]
 }

sort:{[formula;t]
 d:parsea formula; 
 tsort[t;key d;value d]
 }

\d .

.baum.open:{[formula;l] if[formula~"";:l]; l,enlist formula}

d) function
 baum
 .baum.open
 Function to create nodes in treetable
 q)c:count first m:1000#'flip cross/[(`a`b`c`d`e`;`f`g`h`i`j`k`l`m`;`n`o`p`q)]
 q)T:([]A:m 0;B:m 1;C:m 2;D:c?.z.D + til 3;E:c?til 6;v:c?1000;w:c#`x`y`z`w)
 q).baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open[""] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open[""] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open["A:`a"] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open["A:`a,E:4"] ()

.baum.tbaum:{[t;formula;l]
 G:key .baum.parsea first formula:"~~" vs formula;
 A:.baum.parsea A:last formula;
 P:([]n:enlist(0#`)!first 0#/:t G;v:enlist 1b); 
 n:raze {((,) scan key x)#\:x}@'{first@'.baum.parsea x}@'l;
 P:1!P,([]n;v:1b);
 1!.baum.construct[t;G;P;A]
 }

d) function
 baum
 .baum.tbaum
 Function to create treetable
 q)c:count first m:1000#'flip cross/[(`a`b`c`d`e`;`f`g`h`i`j`k`l`m`;`n`o`p`q)]
 q)T:([]A:m 0;B:m 1;C:m 2;D:c?.z.D + til 3;E:c?til 6;v:c?1000;w:c#`x`y`z`w)
 q).baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open[""] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open[""] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open["A:`a"] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open["A:`a,E:4"] ()

.baum.sort:{[formula;t]
 d:.baum.parsea formula; 
 .baum.tsort[t;key d;value d]
 }

d) function
 baum
 .baum.sort
 Function to sort treetable
 q)c:count first m:1000#'flip cross/[(`a`b`c`d`e`;`f`g`h`i`j`k`l`m`;`n`o`p`q)]
 q)T:([]A:m 0;B:m 1;C:m 2;D:c?.z.D + til 3;E:c?til 6;v:c?1000;w:c#`x`y`z`w)
 q).baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open[""] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open[""] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open["A:`a"] ()
 q).baum.sort["counts:idesc"] .baum.tbaum[T;"A,E,D,B,C ~~ counts:count v,v:sum v,w:.baum.nul w"] .baum.open["A:`a,E:4"] ()


/ 

// parallel variant

/ construct treetable (parallel)
pconstruct:{[t;g;p;a]1!`n_ xasc root[t;g;a],raze pblock[t;g;a]peach visible p}

/ construct a block (parallel)
pblock:{[t;g;a;p]
 f:$[g~key p;leaf;node g(`,g)?last key p];
 (`n_,g)xcols f[t;g;a;p]}

