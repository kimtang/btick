
d) module
 util
 util provides a set of functions that help you to manipulate tables. 
 q).import.module`util


.util.parsec:{ if[not 10h=type x;:x]; raze parse["select from t where ", x]2}

d) function
 util
 .util.parsec
 return the where column from a select statement
 q) .util.parsec "not null a, b=`h"


.util.parseb:{ if[not 10h=type x;:x]; parse["select by ",x," from t"]3}

d) function
 util
 .util.parseb
 return the by column from a select statement
 q) .util.parseb "not null a, tmp:b=`h"

.util.parsea:{ if[not 10h=type x;:x]; parse["select ",x," from t"]4}

d) function
 util
 .util.parsea
 return the select column from a select statement
 q) .util.parsea "not null a, tmp:b=`h"

.util.setArg:{[function;values]
 function:$[-11h = type function;get function;function];
 (first 1_get function) set' values
 }


d) function
 util
 .util.setArg
 set the argument of a function according to the values
 q) .util.setArg[{[a;b]};1 2]