
d) module
 docker
 Library for working with kafka
 q).import.module`docker


.docker.summary:{}


d) function
 docker
 .docker.summary
 Function to get a summary
 q) .docker.summary

.docker.init:{[]
 .docker.config:.import.config`docker;
 .docker.daemon: `$.bt.print["%host%:%port%"] .docker.config`daemon;
 .docker.openapi.json:.j.k "c"$read1 `$.bt.print[":%BTSRC%/qlib/docker/openapi/%json%"] `json`BTSRC! (.docker.config . `openapi`json;getenv `BTSRC);
 }

.docker.openapi.summary:{[x]
 if[max x~\:(::;`);:.docker.openapi.json];
 r:.docker.openapi.json x;
 ([] k:key r;v:value r)
 }

d) function
 docker
 .docker.openapi.summary
 Function to get openapi summary
 q).docker.openapi.summary []
 q).docker.openapi.summary `paths


.docker.openapi.paths.summary:{
 allPaths:.docker.openapi.summary `paths;
 allPaths0:ungroup select path:k,mode:key @'v,val:value @'v from allPaths;
 allPaths0:update tags:first@' `$val[;`tags] from allPaths0;
 update path:{ssr[;"}";"%"] ssr[;"{";"%"] x}@'string path from `tags xasc `tags xcols allPaths0 
 }

d) function
 docker
 .docker.openapi.paths.summary
 Function to get openapi summary in pahs
 q).docker.openapi.paths.summary []

.docker.openapi.paths.summary:{
 allPaths:.docker.openapi.summary `paths;
 allPaths0:ungroup select path:k,mode:key @'v,val:value @'v from allPaths;
 allPaths0:update tags:first@' `$val[;`tags],summary:first@' `$val[;`summary] from allPaths0;
 update string path from `tags xasc `tags`path`mode`summary xcols allPaths0
 }

.docker.paths.getUrl:{[path;data]
 if[max path ~\:(`;::) ;:.docker.openapi.paths.summary[]];
 if[-11h = type path;path:string path];
 data:(`$lower string key data)!value data;
 path:ssr[;"}";"%"] ssr[;"{";"%"]path;
 path:.bt.print[path] data;
 `$.bt.print["%daemon%%path%"] .docker,data,.bt.md[`path] path 	
 }

.docker.paths.get0:{[path;data]
 .j.k .Q.hg `$.bt.print[":http://%0"] .docker.paths.getUrl[path;data]
 }

.docker.paths.get:{[path]
 if[max path~/:(::;`);:.docker.openapi.paths.summary[]];
 .docker.paths.get0[path;()!()]
 }

d) function
 docker
 .docker.paths.get
 Function to get openapi summary in pahs
 q).docker.paths.get [] 
 q).docker.paths.get "/containers/json"
 q).docker.paths.get `$"/containers/json"

.docker.paths.post0:{[path;data;mime;post] .Q.hp[;mime;post] `$.bt.print[":http://%0"] .docker.paths.getUrl[path;data]}

d) function
 docker
 .docker.paths.post0
 Function to post openapi summary in pahs
 q) allProcs:.docker.containers.summary[]
 q).docker.paths.post0 ["/containers/{id}/stop";;.h.ty`txt;"phrase"] first select from allProcs where uid like "prx.sm.*"


.docker.paths.post:{[path;data] .docker.paths.post0[path;data;.h.ty`txt;""]}

d) function
 docker
 .docker.paths.post
 Function to post openapi summary in pahs
 q) allProcs:.docker.containers.summary[]
 q).docker.paths.post ["/containers/{id}/stop"] first select from allProcs where uid like "prx.sm.*"

.docker.paths.getVal:{[path0]
 allPaths:.docker.openapi.paths.summary[];
 if[max path0~/:(::;`);:allPaths];
 if[-11h = type path0;path0:string path0]; 
 result:select from allPaths where path like path0;
 result [0]`val
 }

d) function
 docker
 .docker.paths.getVal
 Function to get details from path
 q).docker.paths.getVal [] 
 q).docker.paths.getVal "/containers/json"
 q).docker.paths.getVal `$"/containers/json"


.docker.containers.summary:{
 allContainers:.docker.paths.get "/containers/json";
 if[0=count allContainers;:()];
 allContainers:(`$ lower string cols allContainers ) xcol allContainers ;
 tmp:select name:`${1_x}@'names[;0],host:hostconfig,port:ports,`$id from allContainers;
 tmp1:ungroup  select name,port:{ r:x where {all `IP`PrivatePort`PublicPort`Type in key x}@'x;if["b"$count r;:r];:flip`IP`PrivatePort`PublicPort`Type!(enlist"nohost";enlist 0ni;enlist 0ni;enlist `) }@'port,id from tmp;
 tmp2:`uid`port xasc select uid:`${ssr[x;"-";"."]}@'string name,host:{if[x~"0.0.0.0";:`localhost];`$x }@'port[;`IP],port:"j"$port[;`PublicPort],id from tmp1;
 `uid`id xcols update uid:.Q.dd'[uid;i],id:`$6#/:string id,user:`,passwd:count[i]#enlist"",cid:id from tmp2
 }

d) function
 docker
 .docker.containers.summary
 Function to get details from path
 q).docker.containers.summary [] 

.docker.containers.top:{[ids]
 if[isDic:99h=type ids;ids:enlist ids];
 result:.docker.containers.top0@'ids;
 if[isDic;:result 0];
 raze result
 }

.docker.containers.top0:{[id]
 r:.docker.paths.get0["/containers/{id}/top"] id;
 tbl:`id`cmd xcols update id:id`id from flip (`$lower r`Titles)!flip r`Processes
  }

d) function
 docker
 .docker.containers.top
 Function to get results of top
 q).docker.containers.top 0!select by id from .docker.containers.summary[]

.docker.containers.stop:{[ids]
 if[isDic:99h=type ids;ids:enlist ids];
 result:.docker.containers.stop0@'ids;
 if[isDic;:result 0];
 raze result
 }

.docker.containers.stop0:{[id]
 :.docker.paths.post ["/containers/{id}/stop"] id
 }

d) function
 docker
 .docker.containers.stop
 Function to get results of top
 q).docker.containers.stop 0!select by id from .docker.containers.summary[]

.docker.init[]