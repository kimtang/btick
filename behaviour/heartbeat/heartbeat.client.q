
.heartbeat.sendTime:`second$1

.bt.add[`.library.init;`.heartbeat.init]{}

.bt.addDelay[`.heartbeat.sendHeartbeat]{`tipe`time!(`in;.heartbeat.sendTime)}
.bt.add[`.heartbeat.init`.heartbeat.sendHeartbeat;`.heartbeat.sendHeartbeat]{
 `topic`data!enlist[`.heartbeat.receiveHeartBeat;] (`time`uid!(.z.P;.proc.uid)),.Q.w[]
 }

.bt.addOnlyBehaviour[`.heartbeat.sendHeartbeat]`.bus.sendTweet

/ 

select from .bt.history where action = `.heartbeat.sendHeartbeat
 