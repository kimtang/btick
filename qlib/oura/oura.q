d) module
 oura
 Library create a oura list
 q).import.module`oura

.oura:.bt.md[`] ()!()

.bt.addIff[`.oura.addDb]{`oura in key .import.config}
.bt.add[`.import.ljson;`.oura.addDb]{ .oura:.oura,@[;`startDate;"D"$ ] @[;`db;{hsym `$x}] .import.config `oura;}
.bt.action[`.oura.addDb] ()!();

.oura.template:"curl -v GET \"https://api.ouraring.com/v1/%mode%\""
.oura.userInfo:"userinfo?access_token=%access_token%"
.oura.activity:"activity?access_token=%access_token%&start=%start%&end=%end%"
.oura.sleep:"sleep?access_token=%access_token%&start=%start%&end=%end%"
.oura.readiness:"readiness?access_token=%access_token%&start=%start%&end=%end%"
.oura.bedtime:"bedtime?access_token=%access_token%&start=%start%&end=%end%"


.oura.print:{[mode;arg]
 arg:arg,.bt.md[`] ()!();
 if[`start in key arg;arg:@[;`start;{10#.h.iso8601 x }]arg];
 if[`end in key arg;arg:@[;`end;{10#.h.iso8601 x }]arg];
 .bt.print[.oura.template ] .bt.md[`mode] .bt.print[(.oura mode)] .oura,arg
 }

.oura.getDate:{ ([]date:reverse {x+ til 1+y - x } . .oura.startDate,.z.D - 1)}

d) function
 oura
 .oura.getDate
 Function to get oura dates
 q).oura.getDate[]

.oura.query:{[arg] .j.k first system .oura.print[arg`mode] `start`end#arg }

.oura.qActivity:{[start;end]
 r:(.oura.query `mode`start`end!(`activity;start;end))`activity;
 1!update summary_date:"D"$summary_date from r
 }

d) function
 oura
 .oura.qActivity
 query activity
 q).oura.qActivity[.z.D - 1;.z.D - 1]


.oura.qSleep:{[start;end]
 r:(.oura.query `mode`start`end!(`sleep;start;end))`sleep;
 1!update summary_date:"D"$summary_date from r 
 }

d) function
 oura
 .oura.qSleep
 query sleep
 q).oura.qSleep[.z.D - 1;.z.D - 1]

.oura.qReadiness:{[start;end]
 r:.oura.query `mode`start`end!(`readiness;start;end); 
 1!update summary_date:"D"$summary_date from r`readiness
 }

d) function
 oura
 .oura.qReadiness
 query readiness
 q).oura.qReadiness[.z.D - 1;.z.D - 1] 

.oura.qActivityY:{ .oura.qActivity[.z.D - 1;.z.D - 1] }

d) function
 oura
 .oura.qActivityY
 query activity from yesterday
 q).oura.qActivityY[]

.oura.qSleepY:{ .oura.qSleep[.z.D - 1;.z.D - 1] }

d) function
 oura
 .oura.qSleepY
 query sleep from yesterday
 q).oura.qSleepY[]

.oura.qReadinessY:{ .oura.qReadiness[.z.D - 1;.z.D - 1] }

d) function
 oura
 .oura.qReadinessY
 query readiness from yesterday
 q).oura.qReadinessY[]