/ test.q:localhost:8888::


/ 
 q test.q -folder folder -env env [show] all
 q test.q -folder testPlant -env deepData show all
 q test.q
\

.env.win:"w"=first string .z.o;
.env.lin:not .env.win;

{
  qhome:$[not ""~getenv `QHOME;hsym `$getenv `QHOME;.env.win;`$":C:\\q";hsym`$getenv[`HOME],"/q"];
  if[`bt.q in key qhome;:()];
  0N!"Please install missing bt.q into q home directory;Download it from https://github.com/kimtang/behaviourTag";
  exit 0;
 }[];

\l bt.q

\c 1000 1000

if[""~getenv`BTSRC;
 0N!"Please define the missing variable BTSRC to point to the btick3 implementation";
 exit 0;
 ];

.env.btsrc:getenv`BTSRC
.env.libs:1#`util
.env.behaviours:0#`
.env.arg:.Q.def[`folder`testFile`debug!`test`all,0b] .Q.opt { rest:-2#("show";"all"),rest:x (til count x)except  w:raze 0 1 +/:where "-"=first each x;(x w),(("-cmd";"-testFile"),rest) 0 2 1 3 } .z.x

if[not .env.arg`debug;.bt.outputTrace:.bt.outputTrace1];

{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'.env.libs;
{@[system;;()] .bt.print["l %btsrc%/behaviour/%behaviour%/%behaviour%.q"] .env , enlist[`behaviour]!enlist x}@'.env.behaviours;


.bt.addIff[`.test.parseFolder]{[env] null env}
.bt.add[`.test.init;`.test.parseFolder]{[allData]
 (::)t:ungroup update file:key each root  from t:([]root:1#`$.bt.print[":%btsrc%/test"] .env);
 (::)t:update path:.Q.dd'[root;file] from select from t where file like "*.q";
 {([]k:key x;v:value x)} allData
 / t:([]root:enlist `$.bt.print[":%folder%"] allData); 
 / t:update sroot:`${1_string x}@'root from t;
 / t:ungroup update file:key@'root from t;
 / t:select from t where file like "*.json"; 
 / t:update env:{`$ -5_/:string x}@file from t;
 / t:update cmd:.bt.print["q test.q -folder %sroot% -env %env% status all"]@'t from t;
 / enlist[`result]!enlist t 
 }

.bt.action[`.test.init] .env.arg;

/

.bt.putAction `.test.parseFolder













/