d) module
 oexr
 Library create query openexchangerates. You need to put appid in qlib.json
 q).import.module`oexr

.oexr.appid:""

.bt.addIff[`.oexr.addDb]{`oexr in key .import.config}
.bt.add[`.import.ljson;`.oexr.addDb]{ .oexr.appid:.import.config . `oexr`appid;}

.bt.action[`.oexr.addDb] ()!();


.oexr.query:{
 result:system .bt.print["curl -v \"https://openexchangerates.org/api/latest.json?app_id=%appid%\" "] .oexr;
 result:.j.k "\n"sv result;
 result:@[result;`timestamp;:;] 1970.01.01 + "n"$ 0D00:00:01 * result`timestamp;
 update time:result`timestamp from ([] base:`usd;ccy:`$lower string key result`rates;rate:value result`rates)
 }

d) function
 oexr
 .oexr.query
 Function to reset the todo db
 q).oexr.query[]

.oexr.conv:{[base0]
 rates:.oexr.query[];
 ancor0:first ancor:select from rates where ccy = base0;
 if[0=count ancor;'`.oexr.base_not_found];
 update base:base0, rate:rate % ancor0`rate from rates
 }

d) function
 oexr
 .oexr.conv
 Function to reset the todo db
 q)rates:.oexr.conv`eur


