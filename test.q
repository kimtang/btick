/ test.q:localhost:8888::


/ 
 q test.q -folder folder -env env [show] all
 q test.q -folder testPlant -env deepData show all
 q test.q
\

.env.win:"w"=first string .z.o;
.env.lin:not .env.win;
.env.btsrc:getenv`BTSRC

if[""~getenv`BTSRC;
 0N!"Please define the missing variable BTSRC to point to the btick3 implementation";
 exit 0;
 ];


if[ not`bt in key `;system "l ",.env.btsrc,"/bt.q"];
if[ not`pm in key `;system "l ",.env.btsrc,"/pm.q"];

\c 1000 1000

.bt.addCatch[`]{[error] .bt.stdOut0[`error;`test] .bt.print["Please investigate the following error: %0"] enlist error;'error}

.env.libs:`util`test
.env.behaviours:0#`
.env.arg:.Q.def[`folder`testFile`mode`debug!`test``,0b] .Q.opt .z.x

if[not .env.arg`debug;.bt.outputTrace:.bt.outputTrace1];

{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'.env.libs;
{@[system;;()] .bt.print["l %btsrc%/behaviour/%behaviour%/%behaviour%.q"] .env , enlist[`behaviour]!enlist x}@'.env.behaviours;

.pm.parseFolder:first .bt.repository[enlist `.pm.parseFolder`behaviour]`fnc
.pm.parseEnv:first .bt.repository[enlist `.pm.parseEnv`behaviour]`fnc
.pm.addPid:first .bt.repository[enlist `.pm.win.addPid`behaviour]`fnc
.pm.start:first .bt.repository[enlist `.pm.os.start`behaviour]`fnc
.pm.stop:first .bt.repository[enlist `.pm.os.kill`behaviour]`fnc


.bt.addIff[`.test.parseFolder]{[env] null env}
.bt.add[`.test.init;`.test.parseFolder]{[allData]
 root:hsym[ allData`folder],`$.bt.print[":%btsrc%/test"] .env;
 t:ungroup update testFile:key each root  from t:([]mode:`local`btsrc;root);
 t:update path:.Q.dd'[root;testFile] from select from t where testFile like "*.q";
 t:update cmd: {.bt.print["q test.q -mode %mode% -testFile %testFile%"] x}@'t from t;
 .bt.md[`result] t
 }

.bt.addIff[`.test.show]{[mode;testFile] (null testFile) and null mode}
.bt.add[`.test.parseFolder;`.test.show]{[result]
  1 "We found these tests\n";
  1 .Q.s select mode,testFile,cmd from result;
 }

.bt.addIff[`.test.selectTest]{[mode;testFile] not (null testFile) and null mode}
.bt.add[`.test.parseFolder;`.test.selectTest]{[mode0;testFile0;result]
 tests:select from result where mode=mode0,testFile=testFile0;
 .bt.action[`.test.executeTest]@'tests; 
 }

.bt.addIff[`.test.executeTest.win]{ .env.win }
.bt.add[`.test.executeTest;`.test.executeTest.win]{[allData]

 if[not()~key `:testPlant;system "rm -rf testPlant";];
 if[not()~key `:data/testPlant;system "rm -rf data/testPlant";];

 system "cp -r --no-preserve=mode,ownership plant testPlant"; /copy whole plant folder 

 allData:`folder`env`subsys`proc`debug`cmd!(`testPlant```all,0b,`status);
 env:first .pm.parseFolder[ allData]`result;
 .test.env:env;
 allData:allData,env;

 file:`$.bt.print[":testPlant/%file%"] allData;
 subsys:exec distinct subsys from .pm.parseEnv[allData]`result;

 cfg:.j.k "c"$read1 file;
 cfg:{[x;y] .[x;`global,y[0],`basePort;:;y 1] } over enlist[cfg], flip (subsys;"f"$ 10000 + 1000*til count subsys); 
 file 0: enlist  .j.j cfg;
 env
 }


.bt.add[`.test.executeTest.win;`.test.executeTest.file]{[allData;path]
 .test.t 
 opt:(`folder`env`subsys`proc`debug`print!(`testPlant```all,10b) ), (``env#.test.env);
 .bt.action[`.pm.init] opt,.bt.md[`cmd] `stop;
 .bt.action[`.pm.init] opt,.bt.md[`cmd] `start; 

 system "l ",1_string path;

 .bt.action[`.pm.init] opt,.bt.md[`cmd] `stop;
 1 .Q.s .test.t
 }

.bt.addIff[`.test.executeTest.lin]{ .env.lin }
.bt.add[`.test.executeTest;`.test.executeTest.lin]{[allData;path]
 path
 } 



.bt.addIff[`.test.stop]{[debug]not debug}
.bt.add[`.test.show;`.test.stop]{[allData] exit 0;}


.bt.action[`.test.init] .env.arg;




/

.bt.action[`.test.selectTest] `mode0`testFile0`result!(mode0;testFile0;result)



allData`path


.bt.putAction `.test.selectTest
.bt.putAction `.test.executeTest.win













/