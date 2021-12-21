.import.module`util;

.z.ws:{ neg[.z.w] -8!value -9!x}
.z.wc:{update endTime:.z.P from `.vl.con where hdl=x }

d) module
 vl
 vl provides a set of functions to visualize data in kdb using vega-lite
 q).import.module`vl


.vl.con:flip`hdl`startTime`endTime!()

.vl.register:{if[.z.w=0;:()]; `.vl.con insert (.z.w;.z.P;0np)}

.vl.register[]

d) function
 vl
 .vl.register
 register connection from a websocket
 q) .vl.register[]


.vl.vg:{[obj] (neg exec hdl from .vl.con where null endTime)@\: -8!enlist[`vg]!enlist obj}


d) function
 vl
 .vl.vg
 send the vega object via websocket as vega-lite spec
 q) .vl.vg .vl.vl[([]a:1 2 3 4 5;b:3 2 3 2 5);"mark:point";"x:a,y:b"]


.vl.json:{[obj] (neg exec hdl from .vl.con where null endTime)@\: -8!enlist[`json]!enlist obj}

d) function
 vl
 .vl.json
 send the vega object via websocket as json
 q) .vl.json .vl.vl[([]a:1 2 3 4 5;b:3 2 3 2 5);"mark:point";"x:a,y:b"]


.vl.md:{(1#x)!enlist y}

d) function
 vl
 .vl.md
 create a dictionary
 q) .vl.md[`a] 1 2 3


.vl.mapping0:(!) . flip 2 cut ``unknown`boolean`quantitative`guid`nominal`byte`quantitative`short`quantitative`int`quantitative`long`quantitative`real`quantitative`float`quantitative`char`nominal`symbol`nominal`timestamp`temporal`month`temporal`date`temporal`datetime`temporal`timespan`temporal`minute`temporal`second`temporal`time`temporal
.vl.mapping:update v:.vl.mapping0 k from update k:{@[key;x;`]}@'l from update n:"h"$ i,l:{.[$;(x;());()] }@'t from ([]t:.Q.t)

.vl.vl:{[data;mark;aes]
 result: .vl.md[`data] .vl.md[`values] data;
 result:result,.util.parsea mark;
 result:result,.vl.md[`encoding] {[data;x] `field`type!(x;(exec n!v from .vl.mapping) type data x)}[data]@'.util.parsea aes;
 result[`width]:`container;
 result[`height]:250;
 result
 }

d) function
 vl
 .vl.vl
 create a vega lite spec
 q) .vl.vg .vl.vl[([]a:1 2 3 4 5;b:3 2 3 2 5);"mark:point";"x:a,y:b"]


.vl.data:{[x]
 data:{`$first "." vs x}@'string data1:key `$.bt.print[":%btsrc%/qlib/vl/data"] .env;
 if[max (`;::)~\:x;:data];
 if[10h = abs type x;x:`$x];
 if[not -11h = type x;:data];
 if[not x in data;:data];
 file:`$.bt.print[":%btsrc%/qlib/vl/data/%file%"] arg:.env,.bt.md[`file] (data!data1) x;
 format: (!) . ("s*";",")0:`$ .bt.print[":%btsrc%/qlib/vl/data.csv"] arg;
 dataset:$[file like "*.json";.j.k "c"$read1 file; (format x;", ") 0: file ];
 .Q.id[x] set dataset
 }

d) function
 vl
 .vl.data
 Return dataset
 q) .vl.data[]  / shows a set of data
 q) .vl.data`  / shows a set of data
 q) .vl.data .vl.data[] 0  

.vl.mark:()!()

.vl.mark[`mark_point]:{[tbl;data;paes;l1]}