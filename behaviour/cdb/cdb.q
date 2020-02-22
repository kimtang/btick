.bt.add[`.bus.handshake;`.cdb.init]{
 .cdb.path:.bt.print["%hdb%/cdb"] .proc; 
 .cdb.cwd:"";
 }

.bt.addIff[`.backfill.receive.newData]{[data] schema:data`schema;.proc.subsys = schema`subsys}

.bt.add[`;`.backfill.receive.newData]{[allData]}

.bt.addIff[`.cdb.loadHdb]{ not ()~key hsym `$ $[.cdb.cwd~"";.cdb.path;"."] }

.bt.add[`.cdb.init`.backfill.receive.newData;`.cdb.loadHdb]{
 dbpath:$[.cdb.cwd~"";.cdb.path;"."];
 system "l ",dbpath;
 .cdb.cwd:dbpath;
 }

/