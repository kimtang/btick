args:.Q.def[`name`port!("vlangular/dev.q";9065);].Q.opt .z.x

/ remove this line when using in production
/ vlangular/dev.q:localhost:9065::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 9065"; } @[hopen;`:localhost:9065;0];

\l qlib.q

.import.summary[]

.import.module `vl
.import.doc`vl

.vl.data `weather
.vl.data `stocks
(::)stocks:update date:"D"$date from stocks

.vl.vg .vl.vl[weather;"mark:point";"x:date,y:wind,color:weather"]
.vl.json .vl.vl[weather;"mark:line";"x:date,y:wind"]

`data`mark`aes set'(weather;"type0:point,filled:1b";"x:date,y:wind")

.util.parsea mark

.vl.vl:{[data;mark;aes]
 result:enlist`sym`v!(`data`values;data);
 pmark:{([]sym:key x;v:value x)} .util.parsea mark;
 result:result,update sym:{`mark,/: ((x!x),(1#`type0)!1#`type)x}sym from pmark;
 paes:{([]sym:key x;v:value x)} .util.parsea aes;
 result:result,update sym:{(`encoding;x;`field)}@'sym from paes;
 result:result,update sym:{(`encoding;x;`type)}@'sym,v:{(exec n!v from .vl.mapping) type x}@'data v from paes;
 result:result,enlist`sym`v!(1#`width;`container);
 result:result,enlist`sym`v!(1#`height;250);
 .util.cdict result
 }


.vl.json .util.cdict result
.vl.vg .util.cdict result

.vl.vg .vl.vl[weather;"type0:point,filled:1b";"x:date,y:wind,color:wind"]

.vl.vg .vl.vl[stocks;"type0:line,point:1b";"x:date,y:price,color:symbol"]


/

.vl.mark_point:{[aes;l] if[l~(::);l:()];
 l,enlist (`mark_point;aes)
 }
.vl.mark_point0:.vl.mark_point[""]


(::)aes:"x:date,y:wind"
(::)data:weather
(::)l:.vl.mark_point["color:drizzle";::]

.vl.graph:{[data;aes;l]
 tbl:enlist`sym`v!(`data`values;data);
 paes:.util.parsea aes;
 {[tbl;data;paes;l0]
  .vl.mark[l0 0][tbl;data;paes;l0 1]
 }[tbl;data;paes] l0:l 0 
 }

.vl.mark_point:{[aes;l] if[l~(::);l:()];
 l,enlist (`mark_point;aes)
 }


.vl.mark:()!()

(::)l1:l0 1




.vl.mark[`mark_point]:{[tbl;data;paes;l1]
 laes:.util.parsea l1;

 (`encoding`x`field;(paes,laes)`x)
 }





.util.cdict 
.util.ctable 

.vl.vl[([]a:1 2 3 4 5;b:3 2 3 2 5);"mark:line";"x:a,y:b"]

.util.cdict flip`sym`v!((`data`a;`data`values);(3 2 1;1 2 3))

.util.ctable `data`data1!(`asd;`a`values!(3 2 1;1 2 3))

.vl.json
 .vl.data[([]a:1 2 3 4 5;b:3 2 3 2 5);"x:a,y:b"]
 . 

.vl.vl[([]a:1 2 3 4 5;b:3 2 3 2 5);"mark:line";"x:a,y:b"]

/.h.HOME:"C:\\dev\\angular\\angular-tour-of-heroes\\dist\\angular-tour-of-heroes"