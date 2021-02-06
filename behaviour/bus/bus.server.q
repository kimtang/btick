
.bt.add[`.library.init;`.bus.init]{[allData]
 t:select from .sys where (`bus.server in/:library ) or subsys = allData`subsys;
 t:select uid,host:`$host,user:.proc.uid,port,passwd,mode:(`bus.server {`inside`outside x in y}/:library) from t;
 t:delete from t where uid=.proc`uid;
 .bus.con:t:update hdl:0ni,topic:count[i]#enlist`$() from t;
 }

.bt.add[`.bus.init;`.bus.connect]{ .bt.action[`.hopen.add] @' `uid`host`port`user`passwd#.bus.con; }

.bt.add[`.hopen.success;`.bus.success]{[result]
 result:result lj 1!select uid,mode from .bus.con;
 .bus.con:.bus.con lj 1!select uid,hdl from result;
 data:select uid,avail:not null hdl from .bus.con;
 select neg[hdl]@\:(`.bt.action;`.bus.handshake;.bt.md[`data] data) from result where mode=`inside; 
 `topic`data!(`.bus.avail;data)
 }

.bt.add[`;`.bus.whoIsAvail]{[data]
 update topic:count[i]#enlist data`topic from `.bus.con where uid = data`uid;
 `topic`data!(`.bus.avail;select uid,avail:not null hdl from .bus.con)
 }

.bt.addIff[`.bus.pc]{[zw] zw in .bus.con[;`hdl]}
.bt.add[`.hopen.pc;`.bus.pc]{[zw]
 update hdl:0ni from `.bus.con where hdl = zw;
 data:select uid,avail:not null hdl from .bus.con; 
 `topic`data!(`.bus.avail;data) 
 }

.bt.add[`.bus.success`.bus.whoIsAvail`.bus.pc;`.bus.sendTweet]{[allData]
 (neg exec hdl from .bus.con where not null hdl)@\: (`.bt.action;`.bus.receiveTweet;`topic`data#allData);
 }

.bt.add[`;`.bus.receiveTweet]{[topic;data] .bt.action[topic] .bt.md[`data]data; }

.bt.addIff[`.bus.receiveTweet.fromInside]{.z.w in exec hdl from .bus.con where mode=`inside}
.bt.add[`.bus.receiveTweet;`.bus.receiveTweet.fromInside]{[allData]
 a:select from .bus.con where (allData[`topic] in/:topic) or 0=count each topic;	
 hdls:neg exec hdl from a where not hdl= .z.w,not null hdl;
 hdls@\: (`.bt.action;`.bus.receiveTweet;`topic`data#allData);
 } 

.bt.addIff[`.bus.receiveTweet.fromOutside]{.z.w in exec hdl from .bus.con where mode=`outside}
.bt.add[`.bus.receiveTweet;`.bus.receiveTweet.fromOutside]{[allData]
 a:select from .bus.con where (allData[`topic] in/:topic) or 0=count each topic;
 hdls:neg exec hdl from a where mode=`inside,not null hdl;
 hdls@\: (`.bt.action;`.bus.receiveTweet;`topic`data#allData);	
 }  
 


/

allData:.bt.md[`topic] `.heartbeat.receiveHeartBeat

ungroup update `$passwd from select from .bus.con where uid = `oura.oura.rdb.0

select from .bt.history where not null error