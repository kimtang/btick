
\d .util

croot:{enlist[`]!enlist x}
cinit:{([] sym:key x; v:value x) }
untree:{raze {$[not 99h = type x`v;enlist[x];(@[x;`v;:;::] ), ([]sym: x[`sym] .Q.dd' key x`v;v:value x`v) ] }@'x }

ctable:{
 a:untree over cinit croot x;
 c:update sym:{1_` vs x}@'sym from delete from a where v~\:(::)
 }

tree0:{
 a:select from x where {x=max x:count@'x}sym;
 b:select from x where not {x=max x:count@'x}sym; 
 b,0!select v:raze v by sym from update sym:-1_/:sym,v:sym{ (-1 # x)!enlist y }'v from a
 }

tree1:{
 if[1 >= count x;:x];
 a:select from x where {x=max x:count@'x}sym;
 b:select from x where not {x=max x:count@'x}sym; 
 b,0!select v:raze v by sym from update sym:-1_/:sym,v:sym{ (-1 # x)!enlist y }'v from a
 } 

cdict:{{x[0;`v]} tree1 over tree0 x}

deepMerge:{[default;arg]
 cdict delete mode from 0!select by sym from (update mode:`default from ctable default),update mode:`arg from ctable arg
 }

wlin:{$[.env.win;ssr[;"/";"\\"];(::)]}[]

getFiles:{ $[()~key x;0#`;x ~ key x;x;raze .z.s@'.Q.dd'[x;key x]] }

createSchema:{[tname;subsys;tbl;addTime] 
 path:.Q.dd[hsym .env.arg `folder] .env.arg[ `env],`schemas,subsys;
 m:0!meta tbl;
 m:update t:"*" from m where t = upper t ;
 json:.bt.md[`tname]tname;
 json[`column] : $[addTime;"time,";""],","sv string m`c;
 json[`tipe] : $[addTime;"p";""],m`t;
 json[`rattr] : $[addTime;"s";""],"g",(-1 + count[ m`t])#"*";
 json[`hattr] : $[addTime;"S";""],"g",(-1 + count[ m`t])#"*";
 json[`tick]: "default";
 json[`rsubscriber]: "default";
 json[`hsubscriber]: "default";
 json[`addTime]:addTime;
 json[`ocolumn]:json[`column]; 
 json[`upd]:"{x}";  
 .Q.dd[path;.Q.dd[tname]`json] 0: enlist .j.j enlist[`] _ json	
 }

/ ceateSchema[tname;subsys;tbl;addTime]



