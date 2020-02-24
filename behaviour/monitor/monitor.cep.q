

.monitor.con:flip`uid`looptime`tname`nname`init`upd`loop`error`data!()

.monitor.cep.heartbeat.uid:`heartbeat.bin
.monitor.cep.heartbeat.looptime:`second$1
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
 update data:init @'data from `.monitor.con;
 }




/ 

update data:loop{[loop;data] loop data }'data from `.monitor.con where tname =  tname0;

0!select btime:min time,etime:max time,cnt:count i used:max used,heap:max heap,peak:max peak,wmax:max wmax,mmap:max mmap,mphy:max mphy,syms:max syms,symw:max symw by uid from heartbeat 

0!select btime:min time,etime:max time,cnt:count i ,used:max used,heap:max heap,peak:max peak,wmax:max wmax,mmap:max mmap,mphy:max mphy,syms:max syms,symw:max symw by uid from first .monitor.con`data