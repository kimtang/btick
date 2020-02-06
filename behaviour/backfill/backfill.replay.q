
.backfill.maxSize:512 / 1gb
.backfill.zd:17 3 6

.bt.add[`.library.init;`.backfill.replay.init]{[allData]
 .backfill.tick:first select uid from .sys where subsys = .proc`subsys,`backfill.tick {max x in y}/:library;
 .backfill.tick:first select from .sys where uid = .backfill.tick`uid;
 }

.bt.add[`;`.backfill.replay.ran.schedule]{[data]
 logFolder:`$.bt.print[":%gData%/logFile/%uid%"] .backfill.tick,data;
 schema:get .Q.dd[logFolder]`data;
 hdb:`$.bt.print[":%data%/%folder%/%env%/%subsys%/hdb"] .proc,.global,``subsys#schema;
 cdb:.Q.dd[hdb;`cdb];
 archive:.Q.dd[hdb;`archive]; 
 / if[()~key hdb;.Q.dd[hdb;`dontcare] set ();hdel .Q.dd[hdb;`dontcare] ];
 logFiles:`file xasc update path:.Q.dd'[logFolder;file] from ([]logFolder;file:key logFolder);
 logFiles:select from logFiles where not file like "data"; 
 cdbFolder:([]cdb;file:key cdb);
 `logFolder`schema`hdb`cdb`archive`logFiles`cdbFolder!(logFolder;schema;hdb;cdb;archive;logFiles;cdbFolder)
 }


.bt.addIff[`.backfill.replay.non_automated_parted]{[schema]not `automatic ~ schema`partition_column }

.bt.add[`.backfill.replay.ran.schedule;`.backfill.replay.non_automated_parted]{[allData;schema]
 (schema`tname) set flip schema[`column] ! schema[`tipe]$\:();
 allData[`root]:`$.bt.print[":%data%/staging/%uid%"] allData,allData[`schema],allData[`data],``data#.proc;
 allData:{[x;y]  -11!y; x:.bt.action[`.backfill.non_automated_save_down] x;x } over enlist[allData], allData . `logFiles`path;
 allData
 }

.bt.addIff[`.backfill.non_automated_save_down]{[schema] 0<count get schema`tname }
.bt.add[`;`.backfill.non_automated_save_down]{[allData;schema]
 pnum:distinct(get schema`tname)partition_column:schema`partition_column;
 t:ungroup update parted_number:count[t]#enlist pnum from t:([]root:allData[`root];tname:schema`tname;cls:cols schema`tname);
 t:update file:.Q.dd'[root;flip (parted_number;tname;cls)] from t;
 t:select from t where not cls = partition_column;
 select {[file;tname;cls;partition_column;parted_number] .[file;();,;tname[cls] where parted_number=tname[partition_column] ]}'[file;tname;cls;partition_column;parted_number] from t;
 }


.bt.add[`.backfill.replay.non_automated_parted;`.backfill.replay.non_automated_parted.enum]{[allData;schema]
 pnum:distinct(get tname:schema`tname)partition_column:schema`partition_column;
 ![tname;();0b;0#`]; 
 / pnum:enlist 0	
 .Q.dd'[allData[`root];pnum,\:tname,`.d]set\: cols [tname] except schema`partition_column;	
 sym_file: .Q.dd[allData`cdb;symname:`$.bt.print["%subsys%sym"] schema];
 / archive_sym_file: .Q.dd[allData`hdb;symname:`$.bt.print["%subsys%sym"] schema]; 
 if[() ~ key sym_file;sym_file set 0#`];
 archive_sym_file:.Q.dd[allData`archive;schema[`uid],symname];
 archive_sym_file set get sym_file;
 symname set get sym_file;
 t:update path:.Q.dd'[path;cls]from ungroup update cls:key each path from update path:.Q.dd'[path;tname]from ungroup update tname:key each path from update path:.Q.dd'[path;folder] from ([]path:allData[`root];folder:key allData[`root]); 
 t:select from t where not cls like "*#";
 t:t lj 1!([]cls:schema[`column];tipe:schema[`tipe]);
 t:update toPath:.Q.dd'[allData`cdb;flip (folder;tname;cls)] from t;
 pcol:allData . `schema`parted_column;
 t:update pcolv:count[cls]# enlist iasc get first path where cls=pcol by folder  from t;
 select path{[path;pcolv]path set get[ path]pcolv}'pcolv from t where not cls=`.d;
 select toPath{[toPath;path] -19! path,toPath,.backfill.zd  }'path from t where not tipe in "s ";
 select toPath{[toPath;path] toPath set get path;  }'path from t where cls=`.d; 
 select {[symname;toPath;path] (toPath,.backfill.zd) set symname?get path  }'[symname;toPath;path] from t where tipe = "s";
 sym_file set get symname;
 `topic`data!(`.backfill.receive.newData;``schema#allData)
 }

.bt.addOnlyBehaviour[`.backfill.replay.non_automated_parted.enum]`.bus.sendTweet

.bt.addIff[`.backfill.replay.automated_parted]{[schema]`automatic ~ schema`partition_column }

.bt.add[`.backfill.replay.ran.schedule;`.backfill.replay.automated_parted]{[allData;schema]
 allData[`parted_number]: 1 + max ("J"$string allData . `cdbFolder`file),-1;	
 (schema`tname) set flip schema[`column] ! schema[`tipe]$\:();
 allData[`root]:`$.bt.print[":%data%/staging/%uid%"] allData,allData[`schema],allData[`data],``data#.proc;
 allData[`non_iff_check]:0b;
 allData:{[x;y]  -11!y; x:.bt.action[`.backfill.automated_save_down] x;x } over enlist[allData], allData . `logFiles`path;
 allData[`non_iff_check]:1b;
 allData:.bt.action[`.backfill.automated_save_down] allData;
 allData
 }

.bt.add[`.backfill.replay.automated_parted;`.backfill.replay.automated_parted.enum]{[allData;schema]
 sym_file: .Q.dd[allData`cdb;symname:`$.bt.print["%subsys%sym"] schema];
 / archive_sym_file: .Q.dd[allData`hdb;symname:`$.bt.print["%subsys%sym"] schema]; 
 if[() ~ key sym_file;sym_file set 0#`];
 archive_sym_file:.Q.dd[allData`archive;schema[`uid],symname];
 archive_sym_file set get sym_file;
 symname set get sym_file;
 t:update path:.Q.dd'[path;cls]from ungroup update cls:key each path from update path:.Q.dd'[path;tname]from ungroup update tname:key each path from update path:.Q.dd'[path;folder] from ([]path:allData[`root];folder:key allData[`root]); 
 t:select from t where not cls like "*#";
 t:t lj 1!([]cls:schema[`column];tipe:schema[`tipe]);
 t:update toPath:.Q.dd'[allData`cdb;flip (folder;tname;cls)] from t;
 select toPath{[toPath;path] -19! path,toPath,.backfill.zd  }'path from t where not tipe = "s";
 select {[symname;toPath;path] (toPath,.backfill.zd) set symname?get path  }'[symname;toPath;path] from t where tipe = "s";
 sym_file set get symname;
 `topic`data!(`.backfill.receive.newData;``schema#allData)
 }


.bt.addOnlyBehaviour[`.backfill.replay.automated_parted.enum]`.bus.sendTweet

upd:{[tname;data] tname insert data}

.bt.addIff[`.backfill.automated_save_down]{[schema;non_iff_check] non_iff_check or .backfill.maxSize<(-22!get schema`tname) % 1024 * 1024 }
.bt.add[`;`.backfill.automated_save_down]{[allData;schema]
 t:([]root:allData[`root];parted_number:allData[`parted_number];tname:schema`tname;cls:cols schema`tname);
 select {[file;tname;cls] .[file;();,;tname cls]}'[file;tname;cls] from t:update file:.Q.dd'[root;flip (parted_number;tname;cls)] from t;
 .Q.dd[allData[`root];allData[`parted_number],schema[`tname],`.d] set cols schema`tname;
 ![schema[`tname];();0b;0#`];
 pcol:allData . `schema`parted_column;
 f set `p#g ind:iasc g:get f:first exec file from t where cls = pcol;
 {[ind;file] file set get[file] ind  }[ind]each exec file from t where not cls = pcol;
 .bt.md[`parted_number] 1 + allData`parted_number
 }


/

select from .bt.history where not null error

.bt.putAction `.backfill.replay.automated_parted