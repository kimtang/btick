
.import.module`util;

d) module
 tidyq
 Tidyq provides a set of functions that help you to manipulate tables. 
 q).import.module`tidyq




.tidyq.dcast0:{[t;k;p;v]
 f:{[v;P]`${{x,"_",y} over x}@'flip {if[10h = type x;:x]; string x}each flip raze v ,/:\:P};   
 v:(),v;
 G:group flip k!(t:.Q.v t)k;
 F:group flip p!t p;
 count[k]! 0!key[G]!(asc cols[tmp])xcols tmp:flip(C:f[v]P:flip value flip key F)!raze
  {[i;j;k;x;y]
   a:count[x]#x 0N;
   if[0h=type x;a:a,{}];
   a[y]:x y;
   if[0h=type x;a:-1_a];   
   b:count[x]#0b;
   b[y]:1b;
   c:a i;
   if[0h=type x;c:c,{}];
   c[k]:first'[a[j]@'where'[b j]];
   if[0h=type x;c:-1_c];
   c}[I[;0];I J;J:where 1<>count'[I:value G]]/:\:[t v;value F]
 }

.tidyq.dcast:{[t;ids;formula]
 k:key .util.parsea ids;
 p:key .util.parsea first formula:"~~" vs formula;
 v:key .util.parsea last formula;   
 .tidyq.dcast0[t;k;p;v]
 }

d) function
 tidyq
 .tidyq.dcast
 This is a function to pivot a table
 q) .tidyq.dcast[q;"date,sym,time";"side,level~~price,size"]
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

