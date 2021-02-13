
.bus.topic:0#`

.bus.tcon:enlist`topic`data!(`;{})

.bus.hdl:0ni

.bt.add[`.library.init;`.bus.init]{
 .bus.con:select uid,avail:0b from .sys;
 .bus.topic:(distinct (exec sym from .bt.repository) ,distinct raze exec (trigger,sym) from .bt.behaviours) except `;
 }

.bt.addDelay[`.bus.loop]{`tipe`time!(`in;00:00:02)}
.bt.add[`.bus.init`.bus.loop;`.bus.loop]{}

.bt.addIff[`.bus.publishBulk]{(not null .bus.hdl) and not 1=count .bus.tcon }
.bt.add[`.bus.loop;`.bus.publishBulk]{
 tcon:select from .bus.tcon where not null topic;
 delete from `.bus.tcon where not null topic;
 neg[.bus.hdl] (".bt.action";`.bus.receiveBulk;.bt.md[`tcon] tcon);	
 }

.bt.add[`;`.bus.handshake]{[data]
 .bus.hdl:.z.w;
 .bus.con:.bus.con lj 1!data;
 / .bt.action[`.bus.sendTweet]@'.bus.tcon;
 neg[.bus.hdl] (".bt.action";`.bus.receiveRegisterTopic;`uid`topic!(.proc.uid; .bus.topic));
 `topic`data!(`.bus.whoIsAvail;.proc, .bt.md[`topic] .bus.topic )
 }

.bt.add[`;`.bus.avail]{[data] .bus.con:.bus.con lj 1!data;}

.bt.addIff[`.bus.pc]{[zw] zw=.bus.hdl }
.bt.add[`.hopen.pc;`.bus.pc]{[zw] .bus.hdl:0ni;}

.bt.add[`;`.bus.sendTweet]{[allData] `.bus.tcon insert enlist `topic`data#allData;}

.bt.add[`;`.bus.sendTweetFlush]{.bt.md[`flush]1b}

.bt.addIff[`.bus.sendTweet.noBus]{null .bus.hdl}
.bt.add[`.bus.sendTweetFlush;`.bus.sendTweet.noBus]{[topic;data]
 `.bus.tcon insert enlist `topic`data!(topic;data);
 }

.bt.addIff[`.bus.sendTweet.availBus]{not null .bus.hdl}
.bt.add[`.bus.sendTweetFlush;`.bus.sendTweet.availBus]{[allData]
 neg[.bus.hdl] (`.bt.action;`.bus.receiveTweet; `topic`data#allData );
 }

.bt.addIff[`.bus.sendTweet.flush]{[flush]flush}
.bt.add[`.bus.sendTweet.availBus;`.bus.sendTweet.flush]{ neg[.bus.hdl][];} 

.bt.addIff[`.bus.receiveTweet]{[topic] topic in .bus.topic }
.bt.add[`;`.bus.receiveTweet]{[topic;data] .bt.action[topic] .bt.md[`data]data }

/

select from .bt.history where not null error

