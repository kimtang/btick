
d) module
 util
 util provides a set of functions that help you to manipulate tables. 
 q).import.module`util


.util.parsec:{ if[not 10h=type x;:x]; raze parse["select from t where ", x]2}

d) function
 util
 .util.parsec
 return the where column from a select statement
 q) .util.parsec "not null a, b=`h"


.util.parseb:{ if[not 10h=type x;:x]; parse["select by ",x," from t"]3}

d) function
 util
 .util.parseb
 return the by column from a select statement
 q) .util.parseb "not null a, tmp:b=`h"

.util.parsea:{ if[not 10h=type x;:x];if[""~x;:()!()];; parse["select ",x," from t"]4}

d) function
 util
 .util.parsea
 return the select column from a select statement
 q) .util.parsea "not null a, tmp:b=`h"

.util.setArg:{[function;values]
 function:$[-11h = type function;get function;function];
 (first 1_get function) set' values
 }


d) function
 util
 .util.setArg
 set the argument of a function according to the values
 q) .util.setArg[{[a;b]};1 2]

.util.croot:{enlist[`]!enlist x}
.util.cinit:{([] sym:key x; v:value x) }
.util.untree:{raze {$[not 99h = type x`v;enlist[x];(@[x;`v;:;::] ), ([]sym: x[`sym] .Q.dd' key x`v;v:value x`v) ] }@'x }

.util.ctable:{
 a:.util.untree over .util.cinit .util.croot x;
 c:update sym:{1_` vs x}@'sym from delete from a where v~\:(::)
 }

.util.tree0:{
 a:select from x where {x=max x:count@'x}sym;
 b:select from x where not {x=max x:count@'x}sym; 
 b,0!select v:raze v by sym from update sym:-1_/:sym,v:sym{ (-1 # x)!enlist y }'v from a
 }

.util.tree1:{
 if[1 >= count x;:x];
 a:select from x where {x=max x:count@'x}sym;
 b:select from x where not {x=max x:count@'x}sym; 
 b,0!select v:raze v by sym from update sym:-1_/:sym,v:sym{ (-1 # x)!enlist y }'v from a
 } 

.util.cdict:{{x[0;`v]} .util.tree1 over .util.tree0 x}

.util.deepMerge:{[default;arg]
 .util.cdict delete mode from 0!select by sym from (update mode:`default from .util.ctable default),update mode:`arg from .util.ctable arg
 }

d) function
 util
 .util.deepMerge
 Function to merge two different dictionaries
 q) default:`a`b`c!(1;2;`a`b`c! (6 ; `a`b`c!5 6 7 ;8))
 q) arg:`b`c!(2;`a`b`c! (6 ; `b`c!6 7 ;18))
 q) .util.deepMerge[default]arg
 q) `a`b`c!(1j;2j;`a`c`b!(6j;18j;`a`b`c!5 6 7j))
 q) .util.deepMerge[()!()](1#`a`b)!1#1 2




.util.wlin:{$[.env.win;ssr[;"/";"\\"];(::)]}[]

.util.getFiles:{ $[()~key x;0#`;x ~ key x;x;raze .z.s@'.Q.dd'[x;key x]] }


.util.createSchema:{[tname;subsys;tbl;addTime] 
 path:.Q.dd[hsym .proc `folder] .proc[ `env],`schemas,subsys;
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

d) function
 util
 .util.createSchema
 Function to create schema
 q) .util.createSchema


.util.lfile:{[x]
 if[(not -11h=type x)or  max x~/:(::;`);: .proc ];
 .Q.dd[`$.bt.print[":%lfile%"] .proc;x] 0: enlist ""
 }

d) function
 util
 .util.lfile
 Function to create local q file
 q) .util.lfile[] \ shows the local folder
 q) .util.lfile `main.q \ create the local file in the local folder


.util.sleep0:()!()
.util.sleep0[1b]:{system .bt.print["timeout %0 /nobreak"] enlist x; }
.util.sleep0[0b]:{system .bt.print["sleep %0"] enlist x; }

.util.sleep:{[secs] .util.sleep0[.env.win] secs }

.util.pwd0:()!()
.util.pwd0[1b]:{`$system"cd" }
.util.pwd0[0b]:{`$system"pwd" }

.util.pwd:{ .util.pwd0[.env.win][] }

.util.radnomSeed:{
 seed:enlist sum "J"$9 cut reverse string .z.i + "j"$.z.P;
 system .bt.print["S %0"] seed;     
 }


d) function
 util
 .util.radnomSeed
 Function to set random seed
 q) .util.radnomSeed[] \ set random seed


.util.windowSize:{ lst where not null lst:"J"$ " " vs system["powershell -command \"&{(get-host).ui.rawui.WindowSize;}\""] 3}


d) function
 util
 .util.windowSize
 Function to get windows size
 q) .util.windowSize[] \ set random seed