

/ select from .bt.behaviours where sym = `.heartbeat.init

.bt.add[`.solacePubSub.initSub;`.heartbeat.init]{[solacePubSub]
 .heartbeat.topic:`$.bt.print[solacePubSub[`topic],"/heartbeat"] .proc.global,`subsys`#.proc;	 
 .solace.topicToBehaviour[.heartbeat.topic]:`.heartbeat.receiveSolaceHeartBeat;
 }

.bt.add[`;`.heartbeat.receiveSolaceHeartBeat]{[dest;payload;metaDict] upd[`heartbeat] -9!payload;}