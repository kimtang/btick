

.monitor.con:flip`uid`looptime`executetime`tname`nname`init`upd`loop`error`data!()

.monitor.cep.heartbeat.uid:`heartbeat.bin
.monitor.cep.heartbeat.looptime:`second$5
.monitor.cep.heartbeat.executetime:0np
.monitor.cep.heartbeat.tname:`heartbeat
.monitor.cep.heartbeat.nname:`heartbeatlow
.monitor.cep.heartbeat.init:{[data]0#heartbeat}
.monitor.cep.heartbeat.upd:{[odata;ndata] odata,ndata}
.monitor.cep.heartbeat.loop:{[data] 0!select btime:min time,etime:max time,cnt:count i, used:max used,heap:max heap,peak:max peak,wmax:max wmax,mmap:max mmap,mphy:max mphy,syms:max syms,symw:max symw by uid from data }
.monitor.cep.heartbeat.error:{}
.monitor.cep.heartbeat.data:()

.monitor.upd:{[tname0;ndata]
 update data:upd{[upd;data] upd . data }'flip(data;count[data]#enlist ndata) from `.monitor.con where tname =  tname0;
 }


.bt.add[`.tick.cep.init;`.monitor.cep.init]{
 `.cep.con insert `uid`upd`time!(`.monitor.cep;`.monitor.upd;.z.p);
 `.monitor.con insert cols[.monitor.con]#.monitor.cep.heartbeat;
 update executetime:.z.p + looptime from `.monitor.con where null executetime;
 update data:init @'data from `.monitor.con;
 }



.bt.addDelay[`.monitor.cep.loop]{`tipe`time!(`at;min exec executetime from .monitor.con)}
.bt.add[`.monitor.cep.init`.monitor.cep.loop;`.monitor.cep.loop]{
 uids:exec uid from .monitor.con where executetime<=.z.p;
 update executetime:.z.p + looptime from `.monitor.con where uid in uids;
 .bt.md[`uids] uids
 }


.bt.addIff[`.monitor.cep.executeloop]{[uids] 0<count uids}
.bt.add[`.monitor.cep.loop;`.monitor.cep.executeloop]{[uids]
 {.bt.action[`.bus.sendTweet] `topic`data!(`.monitor.cep.receiveData;x) }@'flip exec nname,ndata:loop@'data from .monitor.con where uid in uids;
 update data:init @'data from `.monitor.con where uid in uids;
 }

/ 