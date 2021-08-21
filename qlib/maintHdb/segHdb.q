args:.Q.def[`name`port!("segHdb.q";8167);].Q.opt .z.x

/ remove this line when using in production
/ segHdb.q:localhost:8167::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8167"; } @[hopen;`:localhost:8167;0];

\l segDB\db