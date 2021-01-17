
.heartbeat.sendTime:`second$1

.bt.add[`.solacePubSub.initSuccess;`.heartbeat.init]{[solacePubSub]
 .heartbeat.topic:`$.bt.print[solacePubSub[`topic],"/heartbeat"] .proc.global,`subsys`#.proc;	 
 }

.bt.addDelay[`.heartbeat.sendHeartbeat]{`tipe`time!(`in;.heartbeat.sendTime)}
.bt.add[`.heartbeat.init`.heartbeat.sendHeartbeat;`.heartbeat.sendHeartbeat]{
 .bt.md[`data] (`time`uid!(.z.P;.proc.uid)),.Q.w[]
 }

.bt.add[`.heartbeat.sendHeartbeat;`.heartbeat.receiveHeartBeat]{[data]
 .solace.sendDirect[.heartbeat.topic] -8!data
 }