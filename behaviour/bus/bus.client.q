
.bus.tcon:flip`topic`data!()

.bus.hdl:0ni

.bt.add[`.library.init;`.bus.init]{
 .bus.con:select uid,avail:0b from .sys;
 }

.bt.add[`;`.bus.handshake]{[data]
 .bus.hdl:.z.w;
 .bus.con:.bus.con lj 1!data;
 .bt.action[`.bus.sendTweet]@'.bus.tcon;
 `topic`data!(`.bus.whoIsAvail;.proc)
 }

.bt.add[`;`.bus.avail]{[data] .bus.con:.bus.con lj 1!data;}



.bt.addIff[`.bus.pc]{[zw] zw=.bus.hdl }
.bt.add[`.hopen.pc;`.bus.pc]{[zw] .bus.hdl:0ni;}

.bt.add[`.bus.handshake;`.bus.sendTweet]{[allData] allData,.bt.md[`flush]0b}

.bt.add[`;`.bus.sendTweetFlush]{.bt.md[`flush]1b}

.bt.addIff[`.bus.sendTweet.noBus]{null .bus.hdl}
.bt.add[`.bus.sendTweetFlush`.bus.sendTweet;`.bus.sendTweet.noBus]{[topic;data]
 `.bus.tcon insert enlist `topic`data!(topic;data);
 }

.bt.addIff[`.bus.sendTweet.availBus]{not null .bus.hdl}
.bt.add[`.bus.sendTweetFlush`.bus.sendTweet;`.bus.sendTweet.availBus]{[allData]
 neg[.bus.hdl] (`.bt.action;`.bus.receiveTweet; `topic`data#allData );
 }

.bt.addIff[`.bus.sendTweet.flush]{[flush]flush}
.bt.add[`.bus.sendTweet.availBus;`.bus.sendTweet.flush]{ neg[.bus.hdl][];} 

.bt.addIff[`.bus.receiveTweet]{[topic] topic in (exec sym from .bt.repository) ,exec distinct (trigger,sym) from .bt.behaviours }
.bt.add[`;`.bus.receiveTweet]{[topic;data] .bt.action[topic] .bt.md[`data]data }

/

.bt.repository