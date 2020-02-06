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



tables[]

select cnt:count i by sym from mnist

select from .bt.history where action = `.backfill.receive.newData

select  by arg from .bt.history where action like ".bus.re*",mode = `behaviour