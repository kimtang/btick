
.import.module`util;

d) module
 tidyq
 Tidyq provides a set of functions that help you to manipulate tables. 
 q).import.module`tidyq


.tidyq.dcast1:{[k;p0;t0] a:((),`$.bt.print[p0`cls] t0)!value p0`afunc;k xkey ?[;();1b;(k!k),a] flip (cols[t0] except p0`acls)#t0 }

.tidyq.dcast0:{[t;k;p0] (uj) over .tidyq.dcast1[k;p0;]@'p0[`acls] xasc 0!p0[`acls] xgroup t}

.tidyq.dcast:{[t;ids;formula]
 k:key .util.parsea ids;
 p:(`cls`func!"~~" vs) @'"||" vs formula;
 p:update acls:{`$s where 1=til[ count s:"%"vs x] mod 2 }@'cls from p;
 p:update afunc:.util.parsea@'func from p;
 (key?[t;();k!k;()]) lj (uj) over .tidyq.dcast0[t;k;]@'p
 }

d) function
 tidyq
 .tidyq.dcast
 This is a function to pivot a table
 q) book:.tidyq.dcast[q;"date,sym,time";"price_%side%_%level% ~~ price  - avg price || size_%side%_%level% ~~ size "]
 q) qpd:5*2*4*"i"$16:00-09:30
 q) date:raze(100*qpd)#'2009.01.05+til 5
 q) sym:(raze/)5#enlist qpd#'100?`4
 q) sym:(neg count sym)?sym
 q) time:"t"$raze 500#enlist 09:30:00+15*til qpd
 q) time+:(count time)?1000
 q) side:raze 500#enlist raze(qpd div 2)#enlist"BA"
 q) level:raze 500#enlist raze(qpd div 5)#enlist 0 1 2 3 4
 q) level:(neg count level)?level
 q) price:(500*qpd)?100f
 q) size:(500*qpd)?100
 q) quote:([]date;sym;time;side;level;price;size)
 q) q:select from quote where sym=first sym
 q) book:.tidyq.dcast[q;"date,sym,time";"price_%side%_%level% ~~ price  - avg price || size_%side%_%level% ~~ size "]


.tidyq.melt:{[t;ids;formula]
 k:key .util.parsea ids;
 p:(`cls`func!"~~" vs) @'"||" vs formula;
 p:update acls:{`$s where 1=til[ count s:"%"vs x] mod 2 }@'func from p;
 p:update bcls:{`$first"_"vs x }@'func from p;
 tcols:([]cls:cols[ t]);
 tcols:select from tcols where not cls in k;
 tcols:update cls0:`${"_"vs x}@'string cls from tcols ;
 tcols:update cls1:cls0[;0] from tcols;
 {[x;y] (k xkey x) uj (k:cols[x] inter cols[y]) xkey y} over .tidyq.melt0[t;k;tcols;]@'p
 }

.tidyq.melt0:{[t;k;tcols;p0]
 lst:{[t;k;p0;tcols0] ![;();0b;.util.parsea p0`cls] ?[t;enlist(not null@;tcols0`cls);0b;] (k!k),((!) . 1#/:tcols0`cls1`cls),((),p0`acls)!1#/:1_tcols0`cls0 }[t;k;p0]@'select from tcols where cls1 in p0`bcls;
 nlst:first 1#0#lst 0;
 nkey:key[nlst] except k,p0`acls;
 nlst:@[nlst;nkey;:;count[nkey]#{}];
 1_0!{[kk;x;y] (kk xkey x) uj kk xkey y }[k,p0`acls] over @[lst;0;{y,x};nlst]
 }

d) function
 tidyq
 .tidyq.melt
 This is a function to pivot a table
 q) .tidyq.melt[book;"date,sym,time";"price:price + avg price,side,level ~~ price_%side%_%level% || size,side,level ~~ size_%side%_%level% "]
 q) qpd:5*2*4*"i"$16:00-09:30
 q) date:raze(100*qpd)#'2009.01.05+til 5
 q) sym:(raze/)5#enlist qpd#'100?`4
 q) sym:(neg count sym)?sym
 q) time:"t"$raze 500#enlist 09:30:00+15*til qpd
 q) time+:(count time)?1000
 q) side:raze 500#enlist raze(qpd div 2)#enlist"BA"
 q) level:raze 500#enlist raze(qpd div 5)#enlist 0 1 2 3 4
 q) level:(neg count level)?level
 q) price:(500*qpd)?100f
 q) size:(500*qpd)?100
 q) quote:([]date;sym;time;side;level;price;size)
 q) q:select from quote where sym=first sym
 q) book:.tidyq.dcast[q;"date,sym,time";"side,level~~price,size"]
 q) .tidyq.melt[book;"date,sym,time";"price:price + avg price,side,level ~~ price_%side%_%level% || size,side,level ~~ size_%side%_%level% "]





