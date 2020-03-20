/ tick.sub is needed


.cep.con:flip `time`uid`upd!()

.bt.add[`.tick.init.schemas;`.tick.cep.init]{[tick] }

/ we remove the unwanted behaviours

.bt.remove@'`.tick.init.logFiles`.tick.replay.logFiles`.tick.sub`.tick.eod;

.bt.add[`.tick.success;`.cep.sub]{[result]
 hdls:exec distinct hdl from result;
 {
 	subsys0:first exec subsys from .tick.con where hdl = x;
 	con:select subsys,tname,rsubscriber:.proc.uid from .tick.schemas where subsys = subsys0;
 	x (`.bt.action;`.tick.sub;`uid`con!(.proc`uid;con)) 
 	}@'hdls;
 }

upd:{[tname;data]
 tname:.tick.t tname;
 data:.tick.addCols[tname;data]; / now distribute to the 
 {[tname;data;cep] @[0;(cep`upd;tname;data);]
 	{[cep;error] .bt.action[`.info.send] `time`uid`nsp`error`msg!(.z.p;.proc.uid;`.tick.cep;`$error;.bt.print["Error in tick.ctp for %uid% and error %error% "] `uid`error!(cep`uid;error)); }[cep];
 }[tname;data;] each .cep.con;
 }

/

reverse select from .bt.history where action like ".error.send"

.error.con 

.bt.putArg 9117j