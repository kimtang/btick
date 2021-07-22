
d) module
 os
 Library for working with the os
 q).import.module`os

.os.tree0:{[t]
 s:update ksym:key each fullPath,kparent:child from t;
 
 s:select from s where not fullPath ~' ksym;
 s:update knum:count@'ksym,kfullPath:fullPath{.Q.dd[x]@/:y}'ksym from s;
 s:update kchild:knum{y + til x}'(1+max[child] + 0^prev sums knum ) from s;
 s:cols[t]#ungroup select sym:ksym,parent:kparent,fullPath:kfullPath,child:kchild from s;
 s
 }

.os.tree:{
 if[10h =  abs type x;x:`$x];
 t:enlist `sym`parent`child`fullPath!(x;0;0;x);
 raze .os.tree0 scan t	
 }

d) function
 os
 .os.tree
 return all available files & folders in the root directory
 q) .os.tree `:.

