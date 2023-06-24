
d) module
 k8s
 k8s provides a set of functions to maintain connections in kdb+. After loading it you need to trigger .k8s.init
 q).import.module`k8s

.k8s.summary:{}


d) function
 k8s
 .k8s.summary
 Function to get a summary
 q) .k8s.summary

.k8s.init:{[]
 .k8s.config0:.j.k "\n"sv "b" "kubectl config view -o json";
 .k8s.cluster0:first .k8s.config0`clusters;
 .k8s.curl.cmd:k"curl --cacert %certificate-authority% %server%%api%";
 .k8s.user0:first .k8s.config0`users;
 }


.k8s.openapi.summary:{[x]
 if[max x~\:(::;`);:.k8s.openapi.json];
 r:.k8s.openapi.json x;
 ([] k:key r;v:value r)
 }

d) function
 k8s
 .k8s.openapi.summary
 Function to get openapi summary
 q).k8s.openapi.summary []
 q).k8s.openapi.summary `paths


.k8s.openapi.paths.summary:{
 allPaths:.k8s.openapi.summary `paths;
 allPaths0:ungroup select path:k,mode:key @'v,val:value @'v from allPaths;
 allPaths0:update tags:first@' `$val[;`tags] from allPaths0;
 update path:{ssr[;"}";"%"] ssr[;"{";"%"] x}@'string path from `tags xasc `tags xcols allPaths0 
 }

d) function
 k8s
 .k8s.openapi.paths.summary
 Function to get openapi summary in pahs
 q).k8s.openapi.paths.summary []

.k8s.openapi.paths.summary:{
 allPaths:.k8s.openapi.summary `paths;
 allPaths0:ungroup select path:k,mode:key @'v,val:value @'v from allPaths;
 allPaths0:update tags:first@' `$val[;`tags],summary:first@' `$val[;`summary] from allPaths0;
 update string path from `tags xasc `tags`path`mode`summary xcols allPaths0
 }

.k8s.paths.getUrl:{[path;data]
 if[max path ~\:(`;::) ;:.k8s.openapi.paths.summary[]];
 if[-11h = type path;path:string path];
 data:(`$lower string key data)!value data;
 path:ssr[;"}";"%"] ssr[;"{";"%"]path;
 path:.bt.print[path] data;
 `$.bt.print["%daemon%%path%"] .k8s,data,.bt.md[`path] path 	
 }

.k8s.paths.get0:{[path;data]
 .j.k .Q.hg `$.bt.print[":http://%0"] .k8s.paths.getUrl[path;data]
 }

.k8s.paths.get:{[path]
 if[max path~/:(::;`);:.k8s.openapi.paths.summary[]];
 .k8s.paths.get0[path;()!()]
 }

d) function
 k8s
 .k8s.paths.get
 Function to get openapi summary in pahs
 q).k8s.paths.get [] 
 q).k8s.paths.get "/containers/json"
 q).k8s.paths.get `$"/containers/json"

.k8s.paths.post0:{[path;data;mime;post] .Q.hp[;mime;post] `$.bt.print[":http://%0"] .k8s.paths.getUrl[path;data]}

d) function
 k8s
 .k8s.paths.post0
 Function to post openapi summary in pahs
 q) allProcs:.k8s.containers.summary[]
 q).k8s.paths.post0 ["/containers/{id}/stop";;.h.ty`txt;"phrase"] first select from allProcs where uid like "prx.sm.*"


.k8s.paths.post:{[path;data] .k8s.paths.post0[path;data;.h.ty`txt;""]}

d) function
 k8s
 .k8s.paths.post
 Function to post openapi summary in pahs
 q) allProcs:.k8s.containers.summary[]
 q).k8s.paths.post ["/containers/{id}/stop"] first select from allProcs where uid like "prx.sm.*"

.k8s.paths.getVal:{[path0]
 allPaths:.k8s.openapi.paths.summary[];
 if[max path0~/:(::;`);:allPaths];
 if[-11h = type path0;path0:string path0]; 
 result:select from allPaths where path like path0;
 result [0]`val
 }

d) function
 k8s
 .k8s.paths.getVal
 Function to get details from path
 q).k8s.paths.getVal [] 
 q).k8s.paths.getVal "/containers/json"
 q).k8s.paths.getVal `$"/containers/json"


.k8s.containers.summary:{
 allContainers:.k8s.paths.get "/containers/json";
 if[0=count allContainers;:()];
 allContainers:(`$ lower string cols allContainers ) xcol allContainers ;
 tmp:`name`port xasc select name:`${1_x}@'names[;0],host:hostconfig,port:ports,`$id from allContainers;
 tmp1:ungroup  select name,port:{ r:x where {all `IP`PrivatePort`PublicPort`Type in key x}@'x;if["b"$count r;:r];:flip`IP`PrivatePort`PublicPort`Type!(enlist"nohost";enlist 0ni;enlist 0ni;enlist `) }@'port,id from tmp;
 tmp2:`uid`port xasc select uid:`${ssr[x;"-";"."]}@'string name,host:{if[x~"0.0.0.0";:`localhost];`$x }@'port[;`IP],port:"j"$port[;`PublicPort],id from tmp1;
 r:`uid`id xcols update uid:.Q.dd'[uid;i],id:`$6#/:string id,user:`,passwd:count[i]#enlist"",cid:id from tmp2;
 if[x~`subl;: 0!select by host,port from r where host like "localhost" ];
 r
 }

d) function
 k8s
 .k8s.containers.summary
 Function to get details from path
 q).k8s.containers.summary [] 

.k8s.containers.top:{[ids]
 if[isDic:99h=type ids;ids:enlist ids];
 result:.k8s.containers.top0@'ids;
 if[isDic;:result 0];
 raze result
 }

.k8s.containers.top0:{[id]
 r:.k8s.paths.get0["/containers/{id}/top"] id;
 tbl:`id`cmd xcols update id:id`id from flip (`$lower r`Titles)!flip r`Processes
  }

d) function
 k8s
 .k8s.containers.top
 Function to get results of top
 q).k8s.containers.top 0!select by id from .k8s.containers.summary[]

.k8s.containers.stop:{[ids]
 if[isDic:99h=type ids;ids:enlist ids];
 result:.k8s.containers.stop0@'ids;
 if[isDic;:result 0];
 raze result
 }

.k8s.containers.stop0:{[id]
 :.k8s.paths.post ["/containers/{id}/stop"] id
 }

d) function
 k8s
 .k8s.containers.stop
 Function to get results of top
 q).k8s.containers.stop 0!select by id from .k8s.containers.summary[]

.k8s.init[]