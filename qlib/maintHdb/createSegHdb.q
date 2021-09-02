args:.Q.def[`name`port!("createSegHdb.q";8914);].Q.opt .z.x

/ remove this line when using in production
/ createSegHdb.q:localhost:8914::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8914"; } @[hopen;`:localhost:8914;0];

mainRoot:`:segDB

(:)c:count first m:1000#'flip cross/[(`a`b`c`d`e`;`f`g`h`i`j`k`l`m`;`n`o`p`q)]
(:)T:([]sym:m 0;B:m 1;C:m 2;D:c?.z.D + til 3;E:c?til 6;v:c?1000;w:c#`x`y`z`w)
(:)T:update vecc:string count[i]?0ng  from T
(:)T:update vecj:count[i]?{10 cut neg[n]?til n:10*count T } T  from T
(:)T:update vecS1:`$string count[i]?0ng  from T
(:)T:update vecS2:`$string count[i]?0ng  from T
(:)T:update vecD:{enlist[`a]!enlist x}@'count[i]?0ng  from T

T:.Q.en[.Q.dd[mainRoot]`db] T

{[x;y].Q.dpft[.Q.dd[mainRoot]x;;`sym;`T]@'y} ./: flip (til 3;3 cut .z.D - til 9)

.Q.dd[mainRoot;`db`par.txt] 0: "../",/:string til 3

