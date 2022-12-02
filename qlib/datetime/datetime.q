d) module
 datetime
 Utility library for datetime
 q).import.module`datetime

/ .bt.addIff[`.datetime.addDb]{`datetime in key .import.config}
/ .bt.add[`.import.ljson;`.datetime.addDb]{ .datetime.db:.Q.dd[hsym `$.import.config . `datetime`db;`datetime];}

/ .bt.action[`.datetime.addDb] ()!();

.datetime.week:{(`s#0 1 2 3 4 5 6!`sat`sun`mon`tue`wed`thu`fri) x mod 7 }

d) function
 datetime
 .datetime.week
 Function to get the datetime db
 q).datetime.week .z.D
 q).datetime.week .z.D + til 7

.datetime.getYearStart:{[x] if[x~(::);x:.z.D]; r:`date$min@'allM @'where @'(`year$now)=`year$allM:(`month$now:(),x) -\: til 12;$[0>type x;first r;r] }

d) function
 datetime
 .datetime.getYearStart
 Function to get the start of the year
 q) 2022.01.01 2022.01.01 ~ .datetime.getYearStart x:2022.02.01 2022.02.01

.datetime.getYearEnd:{ -1+`date$ 12+`month$ .datetime.getYearStart x }

d) function
 datetime
 .datetime.getYearEnd
 Function to get the start of the year
 q) 2022.12.01 2022.01.01 ~ .datetime.getYearEnd x:2022.02.01 2022.02.01

