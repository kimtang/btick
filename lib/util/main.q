args:.Q.def[`name`port!("util main.q";8888);].Q.opt .z.x

/ remove this line when using in production
/ util main.q:localhost:8888::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8888"; } @[hopen;`:localhost:8888;0];

\l util.q

default:`a`b`c!(1;2;`a`b`c! (6 ; `a`b`c!5 6 7 ;8))
arg:`b`c!(2;`a`b`c! (6 ; `b`c!6 7 ;18))

.util.deepMerge[default]arg

`a`b`c!(1j;2j;`a`c`b!(6j;18j;`a`b`c!5 6 7j))

.util.deepMerge[()!()](1#`a`b)!1#1 2
enlist [`a]!enlist 1j