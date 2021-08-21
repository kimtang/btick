
.import.module`os

d) module
 maintHdb
 Library for working maintaining an hdb
 q).import.module`maintHdb

.maintHdb.summaryPart:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 summary:.os.treen[1] x;
 summary:update mode:`folder`file {x~key x}@'fullPath from summary ;
 partedSym:update p:{first "DMI" where not null a:"DMI"$\:string x}@'sym from select from summary where parent = 0,not child=0;
 summary:select from summary lj 1!`fullPath`p#partedSym;
 tbls:.os.treen[2] first exec fullPath idesc p{x$string y}'sym from summary where not null p;
 summary:summary,1_update mode:`folder`file {x~key x}@'fullPath,p:count[i]#"" from tbls;
 summary:update t:{.Q.t type get x}@'fullPath from summary where mode=`file;
 update symFile:{key get x}@'fullPath from summary where  t="s"
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
 summary:update t:{.Q.t type get x}@'fullPath from summary where mode=`file,not sym=`par.txt;
 update symFile:{key get x}@'fullPath from summary where  t="s"
 }


.maintHdb.summary:{[x]
 if[any x~/:(`;::);.os.tree`:. ];
 $[`par.txt in key x;.maintHdb.summarySeg;.maintHdb.summaryPart] x
 }

d) function
 maintHdb
 .maintHdb.summary
 Function to give a deep summary of the hdb folder
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
 summary:update t:{.Q.t type get x}@'fullPath from summary where mode=`file;
 update symFile:{key get x}@'fullPath from summary where  t="s"
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
 summary:update t:{.Q.t type get x}@'fullPath from summary where mode=`file,not sym=`par.txt;
 update symFile:{key get x}@'fullPath from summary where  t="s"
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
