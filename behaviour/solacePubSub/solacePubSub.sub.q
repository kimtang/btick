

/ for library to register its behaviour
.solace.topicToBehaviour:(enlist `)!(enlist `.solacePubSub.subUpdate)

.solace.subUpdate:{[dest;payload;metaDict]
 .bt.action[.solace.topicToBehaviour (key[.solace.topicToBehaviour ]!key .solace.topicToBehaviour) dest] `dest`payload`metaDict!(dest;payload;metaDict);
 .solace.sendAck[dest;metaDict`msgId];
 0i
 }


.bt.add[`;`.solacePubSub.subUpdate]{[allData]}

.bt.add[`.solacePubSub.initSuccess;`.solacePubSub.initSub]{[solacePubSub]
 .solace.endPoint:`$.bt.print[solacePubSub[`endpoint],"/%proc%"] .proc.global,`subsys`proc#.proc;
 .solace.topics:`$.bt.print[solacePubSub[`topic],"/*"] .proc.global,`subsys`proc#.proc;	
 createEndpoint:.solace.createEndpoint[;1i]`ENDPOINT_ID`ENDPOINT_PERMISSION`ENDPOINT_ACCESSTYPE`ENDPOINT_NAME!`2`c`1,.solace.endPoint;
 endpointTopicSubscribe:.solace.endpointTopicSubscribe[;2i;.solace.topics]`ENDPOINT_ID`ENDPOINT_NAME!(`2;.solace.endPoint);
 setTopicMsgCallback:.solace.setTopicMsgCallback`.solace.subUpdate;
 subscribeTopic:.solace.subscribeTopic[.solace.topics;1b];
 } 