
.bt.add[`.tick.init.schemas;`.tick.batch.schemas]{
 .bt.execute[{[tname;column;ocolumn;tipe]t:(column!tipe) ocolumn ;tname set flip ocolumn!()}]@'.tick.schemas;
 }

.bt.add[`;`.tick.upd]{[allData;tname;data]
 data:$[.tick.a tname;.tick.addTime;(::)]data;
 .tick.l enlist d:(`upd;tname;data);
 .tick.i:.tick.i + 1;
 data:.tick.addCols[tname;data];
 tname insert data;
 }

.bt.addDelay[`.tick.publish.data]{`tipe`time!(`in;00:00:00.500)}
.bt.add[`.tick.init.schemas`.tick.publish.data;`.tick.publish.data]{
 {[tname0]
  hdls:exec hdl from .tick.con where tname = tname0,not null hdl;
  d:(`upd;tname0;get tname0);
  -25!(hdls;d);
  delete from tname0;
  }@'.tick.t where 0<(count get @)@'.tick.t;
  .tick.j:.tick.i;
 } 

/