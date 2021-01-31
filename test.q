/ test.q:localhost:8888::


/ 
 q test.q -interactive 1 -folder folder -env env [show] all
 q test.q -interactive 1 -folder testPlant -env deepData show all
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

\c 1000 1000

.bt.addCatch[`]{[error] .bt.stdOut0[`error;`test] .bt.print["Please investigate the following error: %0"] enlist error;'error}

.env.libs:`util`action`test
.env.behaviours:1#`pm
.env.arg:.Q.def[`folder`testFile`mode`debug`interactive!`test``,00b] .Q.opt .z.x

if[not .env.arg`debug;.bt.outputTrace:.bt.outputTrace1];

{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'.env.libs;
{@[system;;()] .bt.print["l %btsrc%/behaviour/%behaviour%/%behaviour%.q"] .env , enlist[`behaviour]!enlist x}@'.env.behaviours;

.pm.parseFolder:first .bt.repository[enlist `.pm.parseFolder`behaviour]`fnc
.pm.parseEnv:first .bt.repository[enlist `.pm.parseEnv`behaviour]`fnc


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
  1 .Q.s select mode,testFile,`$cmd from result;
 }

.bt.addIff[`.test.selectTest]{[mode;testFile] not (null testFile) and null mode}
.bt.add[`.test.parseFolder;`.test.selectTest]{[allData;mode0;testFile0;result]
 tests:select from result where (mode0=`all) or mode=mode0,(testFile0=`all) or testFile=testFile0;
 / env:first .pm.parseFolder[ allData]`result;
 / .test.env:env; 
 {[allData;test] .bt.action[`.test.executeTest] allData,test}[allData]@'tests; 
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


.bt.add[`.test.executeTest.win;`.test.executeTest.prepare]{[path]
 .bt.stdOut0[`test;`run_file] .bt.print["Prepare test file: %0"] enlist path:1_string path;	
 opt:(`folder`env`subsys`proc`debug`print!(`testPlant```all,10b) ), (``env#.test.env);
 .bt.stdOut0[`test;`prepare] "Stop all processes";
 .bt.action[`.pm.init] opt,.bt.md[`cmd] `stop;
 .bt.stdOut0[`test;`prepare] "Start all processes"; 
 .bt.action[`.pm.init] opt,.bt.md[`cmd] `start;
 `path`opt!(path;opt)
 }

.bt.addIff[`.test.executeTest.file]{[interactive] not interactive}


.bt.add[`.test.executeTest.prepare;`.test.executeTest.file]{[path]
 .bt.stdOut0[`test;`run_file] .bt.print["Run test file: %0"] enlist path;
 system "l ",path;
 .bt.stdOut0[`test;`run_file] .bt.print["Finished test file: %0"] enlist path;	
 }

.bt.add[`.test.executeTest.file;`.test.executeTest.clean]{[opt]
 .bt.stdOut0[`test;`prepare] "Stop all processes";
 .bt.action[`.pm.init] opt,.bt.md[`cmd] `stop;
 .test.sleep 20;
 }

.bt.add[`.test.selectTest;`.test.executeTest.show]{
 .Q.dd[`:testResult;.z.d,`$string[.z.t] 0 1 3 4 6 7] 0: "," 0: .test.t;	
 1 .Q.s .test.t;
 }


.bt.addIff[`.test.executeTest.lin]{ .env.lin }
.bt.add[`.test.executeTest;`.test.executeTest.lin]{[allData;path]
 path
 } 



.bt.addIff[`.test.stop]{[interactive;debug](not interactive) and not debug}
.bt.add[`.test.show`.test.executeTest.show;`.test.stop]{[allData] exit 0;}


.bt.action[`.test.init] .env.arg;




/
