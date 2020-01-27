


.heartbeat.sendTime:`second$1

.bt.add[`.library.init;`.heartbeat.init]{}

.bt.addDelay[`.heartbeat.sendHeartbeat]{`tipe`time!(`in;.heartbeat.sendTime)}
.bt.add[`.heartbeat.init`.heartbeat.sendHeartbeat;`.heartbeat.sendHeartbeat]{
 .bt.md[`data] (`time`uid!(.z.P;.proc.uid)),.Q.w[]
 }

.bt.add[`.heartbeat.sendHeartbeat;`.heartbeat.receiveHeartBeat]{[data] upd[`heartbeat] data }