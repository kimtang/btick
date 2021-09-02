
args:.Q.def[`name`port!("ex1.q";8912);].Q.opt .z.x

/ remove this line when using in production
/ ex1.q:localhost:8912::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8912"; } @[hopen;`:localhost:8912;0];

\l qlib.q
r) library(ggplot2)

.import.summary[]

.import.module`maintHdb

(:)summary:.maintHdb.summary x:`:tmpDB
(:)summary:.maintHdb.deepSummary `:tmpDB

/
