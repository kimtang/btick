
.import.module`os

d) module
 maintHdb
 Library for working maintaining an hdb
 q).import.module`maintHdb

/ .maintHdb.getType:{ t:.Q.t type g:get x;if[not null t;:t];upper .Q.t type g 0}
.maintHdb.getType:{`fullPath`t`f`k`symFile`cnt!enlist[x;;attr g;type g 0;$[max 11 20h in t;key g;`];count g]t:type g:get x}

.maintHdb.summaryPart:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 summary:.os.treen[1] x;
 summary:update mode:`folder`file {x~key x}@'fullPath from summary ;
 partedSym:update p:{first "DMI" where not null a:"DMI"$\:string x}@'sym from select from summary where parent = 0,not child=0;
 summary:select from summary lj 1!`fullPath`p#partedSym;
 tbls:.os.treen[2] first exec fullPath idesc p{x$string y}'sym from summary where not null p;
 summary:summary,1_update mode:`folder`file {x~key x}@'fullPath,p:count[i]#"" from tbls;
 summary:select from summary where not fullPath like "*#"; 
 summary:summary lj 1!exec .maintHdb.getType@'fullPath from summary where mode=`file;
 summary
 }

.maintHdb.summarySeg:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 summary:enlist `sym`parent`child`fullPath!(x;0;0;x);
 lst:`$first (1#"*";",") 0: .Q.dd[x]`par.txt;
 par:first select from summary where sym=`par.txt;
 summary:summary,([]sym:lst;parent:0;child:til[count lst]+1+max summary`child;fullPath:.Q.dd[x]@'lst );
 summary:raze .os.tree0\[1;summary];
 summary:update mode:`folder`file {x~key x}@'fullPath from summary ;
 partedSym:update p:{first "DMI" where not null a:"DMI"$\:string x}@'sym from select from summary where mode=`folder ;
 summary:select from summary lj 1!`fullPath`p#partedSym;
 tbls:.os.treen[2] first exec fullPath idesc p{x$string y}'sym from summary where not null p;
 summary:summary,1_update mode:`folder`file {x~key x}@'fullPath,p:count[i]#"" from tbls;
 summary:select from summary where not fullPath like "*#";
 summary:summary lj 1!exec .maintHdb.getType@'fullPath from summary where mode=`file,not sym=`par.txt;
 summary
 }


.maintHdb.summary:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 $[`par.txt in key x;.maintHdb.summarySeg;.maintHdb.summaryPart] x
 }

d) function
 maintHdb
 .maintHdb.summary
 Function to give a summary of the hdb folder. Use it for a quick summary.
 $ q createHdb.q
 q) .maintHdb.summary[] /showing folders tree 
 q) .maintHdb.summary` /showing folders tree 
 q) .maintHdb.summary `:tmpDB

.maintHdb.deepSummaryPart:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 summary:.os.tree x;
 partedSym:update p:{first "DMI" where not null a:"DMI"$\:string x}@'sym from select from summary where parent = 0,not child=0;
 summary:select from summary lj 1!`fullPath`p#partedSym;
 summary:update mode:`folder`file {x~key x}@'fullPath from summary;
 summary:select from summary where not fullPath like "*#";
 summary:summary lj 1!exec .maintHdb.getType@'fullPath from summary where mode=`file;
 summary  
 }

.maintHdb.deepSummarySeg:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 summary:enlist `sym`parent`child`fullPath!(x;0;0;x);
 lst:`$first (1#"*";",") 0: .Q.dd[x]`par.txt;
 par:first select from summary where sym=`par.txt;
 summary:summary,([]sym:lst;parent:0;child:til[count lst]+1+max summary`child;fullPath:.Q.dd[x]@'lst );
 summary:raze .os.tree0 scan summary;
 summary:update mode:`folder`file {x~key x}@'fullPath from summary ; 
 partedSym:update p:{first "DMI" where not null a:"DMI"$\:string x}@'sym from select from summary where mode=`folder ;
 summary:select from summary lj 1!`fullPath`p#partedSym;
 summary:select from summary where not fullPath like "*#"; 
 summary:summary lj 1!exec .maintHdb.getType@'fullPath from summary where mode=`file,not sym=`par.txt;
 summary
 } 

.maintHdb.deepSummary:{[x] 
 if[any x~/:(`;::);.os.tree`:. ];
 $[`par.txt in key x;.maintHdb.deepSummarySeg;.maintHdb.deepSummaryPart] x
 }

d) function
 maintHdb
 .maintHdb.deepSummary
 Function to give a deep summary of the hdb folder
 $ q createHdb.q
 q) .maintHdb.deepSummary[] /showing folders tree 
 q) .maintHdb.deepSummary` /showing folders tree 
 q) .maintHdb.deepSummary `:tmpDB


.maintHdb.transform0:{[opt]
 default:`dryRun`compress`date!(1b;17 2 6;0nd);
 if[any (`;::)~\: opt;:default];
 }


d) function
 maintHdb
 .maintHdb.transform0
 Function transform a column 
 q) .maintHdb.transform0[] / show parameters 
 q) .maintHdb.transform0` / show parameters 
 q) .maintHdb.transform0 `dryRun`compress`root`tbl`column`date`transform!(1b;17 2 6;`:tmpDB;`T;`vecS;0nd;string)
 q) .maintHdb.transform0 `dryRun`compress`root`tbl`column`date`transform!(0b;17 2 6;`:tmpDB;`T;`vecS1;0nd;string)  

opt:`root`dryRun`compress`transform!(`:tmpDB;1b;17 2 6;string)
allColumns:select from .maintHdb.deepSummary[`:tmpDB] where fullPath like ":tmpDB/*/T/vecS1"

.maintHdb.transform1:{[opt;allColumns]
 default:`dryRun`compress!(1b;17 2 6);
 if[any max (`;::)~\:/: (opt;allColumns);:default];
 opt:default,opt;
 if[not all `dryRun`compress`transform`root in key opt;:opt,.bt.md[`error] `missing_param ];
 allColumns:select fullPath from allColumns where {x~key x}@'fullPath;
 allColumns:allColumns lj 1!exec .maintHdb.getType@'fullPath from allColumns;
 symFiles:exec distinct symFile from allColumns;
 opt{[opt;symFile] symFile set get .Q.dd[opt`root]symFile}/:symFiles;
 opt{[opt;fullPath]($[any null opt`compress;fullPath;fullPath,opt`compress]) set opt[`transform] get fullPath}/:allColumns`fullPath;
 
 }

d) function
 maintHdb
 .maintHdb.transform1
 Function transform a column 
 q) .maintHdb.transform1[::;::] / show parameters 
 q) .maintHdb.transform1[`;`] / show parameters 
 q) .maintHdb.transform1[`dryRun`compress`transform!(1b;17 2 6;string)] select fullPath from .maintHdb.deepSummary[`:tmpDB] where fullPath like ":tmpDB/*/T/vecS1"


