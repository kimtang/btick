.bus.tcon:enlist`topic`data`zw!(`;{};0ni)

.bt.add[`;`.bus.receiveBulk]{[tcon] `.bus.tcon insert update zw:.z.w from tcon }

.bt.add[`.library.init;`.bus.init]{[allData]
 .bus.topic:(distinct (exec sym from .bt.repository) ,distinct raze exec (trigger,sym) from .bt.behaviours) except `;	
 t:select from .sys where (`bus.server in/:library ) or subsys = allData`subsys;
 t:select uid,host:`$host,user:.proc.uid,port,passwd,mode:(`bus.server {`inside`outside x in y}/:library) from t;
 t:update hdl:0ni,topic:count[i]#enlist 1#`all from t;
 t:update hdl:0,topic:count[i]#enlist .bus.topic,mode:`inside from t where uid=.proc`uid;
 .bus.con:t;
 }

.bt.addDelay[`.bus.loop.tcon]{`tipe`time!(`in;00:00:02)}
.bt.add[`.bus.init`.bus.loop.tcon;`.bus.loop.tcon]{}

.bt.addIff[`.bus.reduce.tcon]{1<count .bus.tcon}
.bt.add[`.bus.loop.tcon;`.bus.reduce.tcon]{
 tcon:select from .bus.tcon where not null topic ;
 delete from `.bus.tcon where not null topic;
 chooser:group exec hdl!topic from ungroup select hdl,topic from .bus.con where mode=`inside,not null hdl;
 inside:update shdl:(chooser[`all],/:chooser[ topic]) except' zw from tcon;
 inside:ungroup update data:{[shdl;data] count[shdl]#enlist data}'[shdl;data] from inside;
 inside:0!select data:{$[0=type x;raze x;x]} data by topic,shdl from inside;
 .bt.execute[{[topic;shdl;data] neg[shdl] (".bt.action";`.bus.receiveTweet;`topic`data!(topic;data)); }]@'select from inside where not shdl=0;
 .bt.execute[{[topic;data] @[.bt.action[topic];.bt.md[`data]data;{}];}]@'select from inside where shdl=0;

 chooser:group exec hdl!topic from ungroup select hdl,topic from .bus.con where mode=`outside,not null hdl;
 outside:update shdl:(chooser[`all],/:chooser[ topic]) except' zw from tcon;
 outside:ungroup update data:{[shdl;data] count[shdl]#enlist data}'[shdl;data] from outside;
 outside:0!select tcon:([]topic;data) by shdl from outside;
 .bt.execute[{[shdl;tcon] neg[shdl] (".bt.action";`.bus.receiveBulk;.bt.md[`tcon]tcon); }]@'outside; 
 }

/ ungroup select uid,topic  from .bus.con where uid=`bus_dev.admin.tick.0 


.bt.add[`.bus.init;`.bus.connect]{ .bt.action[`.hopen.add] @' `uid`host`port`user`passwd#select from .bus.con where not uid=.proc`uid; }

.bt.add[`.hopen.success;`.bus.success]{[result]
 result:result lj 1!select uid,mode from .bus.con;
 .bus.con:.bus.con lj 1!select uid,hdl from result;
 data:select uid,avail:not null hdl from .bus.con;
 select neg[hdl]@\:(`.bt.action;`.bus.handshake;.bt.md[`data] data) from result where mode=`inside; 
 `topic`data!(`.bus.avail;data)
 }

.bt.add[`;`.bus.whoIsAvail]{[data]
 / update topic:count[i]#enlist data`topic from `.bus.con where uid = data`uid;
 `topic`data!(`.bus.avail;select uid,avail:not null hdl from .bus.con)
 }

.bt.add[`;`.bus.receiveRegisterTopic]{[uid0;topic0] update topic:count[i]#enlist topic0 from `.bus.con where uid = uid0;} 

.bt.addIff[`.bus.pc]{[zw] zw in .bus.con[;`hdl]}
.bt.add[`.hopen.pc;`.bus.pc]{[zw]
 update hdl:0ni from `.bus.con where hdl = zw;
 data:select uid,avail:not null hdl from .bus.con; 
 `topic`data!(`.bus.avail;data) 
 }

.bt.add[`.bus.success`.bus.whoIsAvail`.bus.pc;`.bus.sendTweet]{[allData]
 `.bus.tcon insert update zw:0 from enlist `topic`data#allData;
 }

.bt.add[`;`.bus.receiveTweet]{[topic;data] `.bus.tcon insert update zw:.z.w from enlist `topic`data!(topic;data); }



/

select from  .bt.history where action=`.bus.loop.tcon

select from .bt.tme where null runAt


