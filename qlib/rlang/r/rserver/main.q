
args:.Q.def[`name`port!("name";8888);].Q.opt .z.x

/ remove this line when using in production
/ name:localhost:8888::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8888"; } @[hopen;`:localhost:8888;0];

\l R.q

r) library(ggplot2)

(::)tmp: Rframe "diamonds"

tmp