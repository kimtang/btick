args:.Q.def[`name`port!("cfg main.q";8888);].Q.opt .z.x

/ remove this line when using in production
/ cfg main.q:localhost:8888::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8888"; } @[hopen;`:localhost:8888;0];

\l bt.q

.env.btsrc:getenv`BTSRC
.env.libs:`util`cfg
.env.behaviours:0#`
.env.ycmd:"yaml2json"

{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'.env.libs;
{@[system;;()] .bt.print["l %btsrc%/behaviour/%behaviour%/%behaviour%.q"] .env , enlist[`behaviour]!enlist x}@'.env.behaviours;


(::)cfg:.j.k first system .bt.print["%ycmd% cfg.yml"] .env
(::)global:cfg `global


(::)core:.j.k first system  .bt.print["%ycmd% %core%/%core%.yml"] .env,global
(::)cfg:.util.deepMerge[core;cfg]

.util.ctable cfg  