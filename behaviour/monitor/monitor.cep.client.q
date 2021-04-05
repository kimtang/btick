

.monitor.con:flip`uid`looptime`executetime`tname`nname`init`upd`loop`error`data!()

.monitor.cep.tblcnt.uid:`tblcnt.bin
.monitor.cep.tblcnt.looptime:`second$5
.monitor.cep.tblcnt.executetime:0np
.monitor.cep.tblcnt.tname:`all
.monitor.cep.tblcnt.nname:`tblcnt
.monitor.cep.tblcnt.init:{ 1!([] tbl:exec tname from .schemas.con;btime:.z.P;cnt:0) }
.monitor.cep.tblcnt.upd:{[tname;odata;ndata]odata + 1!enlist `tbl`btime`cnt!(tname;0;count ndata) }
.monitor.cep.tblcnt.loop:{[data] update etime:.z.P from 0!data}
.monitor.cep.tblcnt.error:{}
.monitor.cep.tblcnt.data:() / exec tname from .schemas.con where subsys=.proc.subsys

.monitor.cep.aheartbeat.uid:`aheartbeat
.monitor.cep.aheartbeat.looptime:`second$5
.monitor.cep.aheartbeat.executetime:0np
.monitor.cep.aheartbeat.tname:`heartbeat
.monitor.cep.aheartbeat.nname:`aheartbeat
.monitor.cep.aheartbeat.init:{[data] if[not()~data;:data]; t:`uid xkey exec 0#schema 0 from .schemas.con where subsys=`admin,tname=`heartbeat; t upsert select uid from .sys  }
.monitor.cep.aheartbeat.upd:{[tname;odata;ndata]odata upsert ndata }
.monitor.cep.aheartbeat.loop:{[data] 0!data}
.monitor.cep.aheartbeat.error:{}
.monitor.cep.aheartbeat.data:() / exec tname from .schemas.con where subsys=.proc.subsys



.monitor.upd:{[tname0;ndata]
 update data:upd{[upd;data] upd . data }'flip(tname0;data;count[data]#enlist ndata) from `.monitor.con where (tname=`all)or tname =  tname0;
 }


.bt.add[`.tick.cep.init;`.monitor.cep.init]{
 `.cep.con insert `uid`upd`time!(`.monitor.cep;`.monitor.upd;.z.p);
 `.monitor.con insert cols[.monitor.con]#.monitor.cep.tblcnt;
 `.monitor.con insert cols[.monitor.con]#.monitor.cep.aheartbeat; 
 update executetime:.z.p + looptime from `.monitor.con where null executetime;
 update data:init @'data from `.monitor.con;
 }



.bt.addDelay[`.monitor.cep.loop]{`tipe`time!(`at;min exec executetime from .monitor.con)}
.bt.add[`.monitor.cep.init`.monitor.cep.loop;`.monitor.cep.loop]{
 uids:exec uid from .monitor.con where executetime<=.z.P;
 update executetime:.z.P + looptime from `.monitor.con where uid in uids;
 .bt.md[`uids] uids
 }


.bt.addIff[`.monitor.cep.executeloop]{[uids] 0<count uids}
.bt.add[`.monitor.cep.loop;`.monitor.cep.executeloop]{[uids]
 {.bt.action[`.bus.sendTweet] `topic`data!(`.monitor.cep.receiveData;x) }@'flip exec nname,ndata:loop@'data from .monitor.con where uid in uids;
 update data:init @'data from `.monitor.con where uid in uids;
 }