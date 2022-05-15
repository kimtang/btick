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


