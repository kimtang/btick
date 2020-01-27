
.tick.parse0:{
  t:ungroup update file:key each cdb from .tick.replay;
  .tick.symfiles:select from t where not file like "????.??.??";
  .tick.symfiles:update cfile:.Q.dd'[cdb;file] from .tick.symfiles;
  .tick.symfiles:update hfile:.Q.dd'[.tick.hdb;file] from .tick.symfiles;
  .tick.symfiles:update cfile:`${.util.wlin  1_x}@'string cfile,hfile:`${.util.wlin  1_x}@'string hfile from .tick.symfiles;
  .tick.symfiles:update cmd:.bt.print["mklink %hfile% %cfile%"]@'.tick.symfiles from .tick.symfiles;

  .tick.cdbs:select uid,cdb,date:file,cfile:.Q.dd'[cdb;file] from t where file like "????.??.??";
  .tick.cdbs:ungroup update tname:key@'cfile from .tick.cdbs;
  .tick.cdbs:select from .tick.cdbs where tname in .tick.schemas`tname;
  .tick.cdbs:update cfile:.Q.dd'[cfile;tname] from .tick.cdbs;
  .tick.cdbs:update mkdir: {"mkdir " , .util.wlin 1_string .Q.dd[x;y]}'[.tick.hdb;date] from .tick.cdbs;
  .tick.cdbs:update hfile:.Q.dd'[.tick.hdb;flip (date;tname)] from .tick.cdbs ;
  .tick.cdbs:update cfile:`${.util.wlin  1_x}@'string cfile,hfile:`${.util.wlin  1_x}@'string hfile from .tick.cdbs;
  .tick.cdbs:update cmd:.bt.print["mklink /D %hfile% %cfile%"]@'.tick.cdbs from .tick.cdbs ;

  t:([]root:1#.tick.hdb);
  t:ungroup update file:key@'root from t;

  .tick.hsymfiles:select from t where not file like "????.??.??";
  .tick.hdbs:select root,date:file,cfile:.Q.dd'[root;file] from t where file like "????.??.??";
  .tick.hdbs:ungroup update tname:key@'cfile from .tick.hdbs;
  .tick.hdbs:update cfile:.Q.dd'[cfile;tname] from .tick.hdbs;
  .tick.hdbs:update cfile:`${.util.wlin  1_x}@'string cfile from .tick.hdbs;
 }


.bt.add[`.bus.handshake;`.tick.init.schemas]{
 .tick.schemas:select from .schemas.con where (.proc[`subsys] in/:hsubscriber) or ((subsys = .proc`subsys) and `default in/:hsubscriber);	
 .tick.uids:exec uid from .sys where subsys in .tick.schemas[`subsys],`tick.replay {max x in y}/:library;
 .tick.replay:select uid,hdb from .sys where uid in .tick.uids;
 .tick.replay: select uid,cdb:`${.util.wlin .bt.print[":%cwd%/%hdb%/cdb"] .proc,x}@'.tick.replay from .tick.replay; 
 .tick.hdb:`$.util.wlin .bt.print[":%cwd%/%gData%/hdb"] .proc;
 .tick.cwd:"";
 .tick.lead:` sv (-1_` vs .proc.uid),`0;
 }

.bt.addIff[`.tick.checkCdb]{0=.proc.id}
.bt.add[`.tick.init.schemas`.replay.eod;`.tick.checkCdb]{ .tick.parse0[]; }


.bt.addIff[`.tick.cHdb]{0<count .tick.cdbs}

.bt.add[`.tick.checkCdb;`.tick.cHdb]{
 a:select from .tick.cdbs where not hfile in .tick.hdbs`cfile;
 @[system;;()]@'exec distinct mkdir from a;
 @[system;;()]@'a`cmd;
 b:select from .tick.symfiles where not file in .tick.hsymfiles`file;
 @[system;;()]@'b`cmd;
 }

.bt.add[`.tick.cHdb`.tick.hdb.reload;`.tick.lHdb]{
 dbpath:$[.tick.cwd~"";1_string .tick.hdb;"."];
 system "l ",dbpath;
 .tick.cwd:.tick.hdb; 
 }

.bt.add[`.tick.lHdb;`.tick.hdb.tweet]{
 `topic`data!(`.tick.hdb.reload;``uid#.proc)
 }


.bt.addOnlyBehaviour[`.tick.hdb.tweet]`.bus.sendTweet


.bt.addIff[`.replay.eod]{[data] data[`uid] in .tick.replay`uid   }

.bt.add[`;`.replay.eod]{[allData]}

.bt.addIff[`.tick.hdb.reload]{[data] data[`uid] = .tick.lead   }

/ 

tables[]

select from property
