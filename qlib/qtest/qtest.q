d) module
 qtest
 qtest provides a set of functions to implement behaviour driven testing (ScalaTest and AnyFlatSpec)
 q).import.module`qtest

.qtest.suiteName:"noName"

.qtest.folder:":test/data"

.bt.addIff[`.qtest.addFolder]{`qtest in key .import.config}
.bt.add[`.import.ljson;`.qtest.addFolder]{ .qtest.folder:.Q.dd[hsym `$.import.config . `qtest`folder;`qtest];}
.bt.action[`.qtest.addFolder] ()!();


.qtest.con:flip`suit`description`fnc`stime`etime`error`result!"***pps*"$\:()
.qtest.suit:{.qtest.suitName:x}
.qtest.ind:0nj;

.qtest.data.get:{[data] data set get `$.bt.print["%folder%/%data%"] .qtest, .bt.md[`data] data }

d) function
 qtest
 .qtest.data.get
 Function to get test data from a test folder.
 q).qtest.data.set `data1 set ([]a:1 2 3; b: 4 5 6)
 q).qtest.data.get `data1 / it is expected there is a dataset at :test/data/data1

.qtest.data.set:{[data] (`$.bt.print["%folder%/%data%"] .qtest, .bt.md[`data] data) set get data  }

d) function
 qtest
 .qtest.data.set
 Function to save a dataset in the test folder.
 q).qtest.data.set`data1 set ([]a:1 2 3; b: 4 5 6)
 q).qtest.data.get`data1


.qtest.should:{[description;fnc]
 stime:.z.P;
 .qtest.ind:first `.qtest.con insert enlist`suit`description`fnc`stime`etime`error`result!(.qtest.suitName;description;fnc;stime;0np;`;());
 r:@[{[fnc;x] `result`error!(fnc x;`) }[fnc];();{`result`error!(`;`$x)}];
 update error:r`error, etime:.z.P from `.qtest.con where i =.qtest.ind;
 }

d) function
 qtest
 .qtest.should
 Function to save a dataset in the test folder.
 q) .qtest.should["my desciption"]{ .qtest.mustmatch[1;1]; }


.qtest.musteq:{[shouldValue;calcValue]
 update result:enlist(result[0],enlist (`.qtest.p.musteq;shouldValue;calcValue)) from `.qtest.con where i =.qtest.ind
 }

.qtest.p.musteq:{[shouldValue;calcValue] all .[=;(shouldValue;calcValue);0b] }

.qtest.mustmatch:{[shouldValue;calcValue]
 update result:enlist(result[0],enlist (`.qtest.p.mustmatch;shouldValue;calcValue)) from `.qtest.con where i =.qtest.ind
 }

.qtest.p.mustmatch:{[shouldValue;calcValue] shouldValue ~ calcValue }

.qtest.musttrue:{[calcValue]
 update result:enlist(result[0],enlist (`.qtest.p.musttrue;calcValue)) from `.qtest.con where i =.qtest.ind
 }

.qtest.p.musttrue:{[calcValue] calcValue }

.qtest.mustfalse:{[calcValue]
 update result:enlist(result[0],enlist (`.qtest.p.mustfalse;calcValue)) from `.qtest.con where i =.qtest.ind
 }

.qtest.p.mustfalse:{[calcValue] not calcValue }

.qtest.passed:{
  update passed:error{[error;result] if[not null error;:0b]; 0@'result}'result from .qtest.con
 }

.qtest.reportShort:{
 p:.qtest.passed[];
 arg:(1#`suit)!1#count distinct exec suit from p;
 arg,:(1#`should)!1#count distinct exec description from p;
 arg,:(1#`test)!1#sum exec count@'result from p;  
 msg:enlist .bt.print["For %suit% suit, %should% expectations and %test% test(s) were run."]arg;

 arg:(1#`passed)!1#sum raze exec passed from p;
 arg,:(1#`failed)!1#sum not raze exec passed from p;
 arg,:(1#`error)!1#sum not null exec error from p;  

 msg,:enlist .bt.print["%passed% passed, %failed% failed, %error% errors."] arg;
 msg,:enlist .bt.print["It took %took%"] (1#`took)!1#exec (max etime) - min stime from p;
 :msg
 };

d) function
 qtest
 .qtest.reportShort
 Function to save a dataset in the test folder.
 q) .qtest.suit"myName"
 q) .qtest.should["my desciption"]{ .qtest.mustmatch[1;1]; }
 q) .qtest.reportShort[]

.qtest.outputShort:{
 0N!/:.qtest.reportShort[]
 };

d) function
 qtest
 .qtest.outputShort
 Function to save a dataset in the test folder.
 q) .qtest.suit"myName"
 q) .qtest.should["my desciption"]{ .qtest.mustmatch[1;1]; }
 q) .qtest.outputShort[]
