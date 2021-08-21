args:.Q.def[`name`port!("createDateHdb.q";8913);].Q.opt .z.x

/ remove this line when using in production
/ createDateHdb.q:localhost:8913::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8913"; } @[hopen;`:localhost:8913;0];

mainRoot:`:tmpDB

(:)c:count first m:1000#'flip cross/[(`a`b`c`d`e`;`f`g`h`i`j`k`l`m`;`n`o`p`q)]
(:)T:([]sym:m 0;B:m 1;C:m 2;D:c?.z.D + til 3;E:c?til 6;v:c?1000;w:c#`x`y`z`w)
(:)T:update vecc:string count[i]?0ng  from T
(:)T:update vecj:count[i]?{10 cut neg[n]?til n:10*count T } T  from T

T:.Q.en[mainRoot] T

{.Q.dpft[mainRoot;x;`sym;`T] }@'.z.D - til 3
