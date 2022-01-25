
d) module
 todo
 Library create a todo list
 q).import.module`todo

.todo.db:`:db/todo

.bt.addIff[`.todo.addDb]{`todo in key .import.config}
.bt.add[`.import.ljson;`.todo.addDb]{ .todo.db:.Q.dd[hsym `$.import.config . `todo`db;`todo];}

.bt.action[`.todo.addDb] ()!();

.todo.schema:1!flip `uid`puid`mode`task`stime`etime`description`priority`deadline!"ggsspp*sp"$\:()
.todo.priority:`high`low`critical`normal


.todo.new:{ get .todo.db set .todo.schema}

d) function
 todo
 .todo.new
 Function to reset the todo db
 q).todo.new[]

.todo.getRaw:{ get .todo.db}



.todo.getDeadline0:()!()
.todo.getDeadline0[`today]:{-1 + "p"$.z.D + 1}
.todo.getDeadline0[`tomorrow]:{-1 + "p"$.z.D + 2}
.todo.getDeadline0[`thisWeek]:{first -1 + "p" $ .z.D + 1+where 1=(.z.D + til 7)  mod 7} 
.todo.getDeadline0[`thisMonth]:{"p" $ -1 + `date$ 1+`month$.z.D}

.todo.getDeadline:{[x]
 if[type[ .z.P] = t:type x;:x];
 if[t = type .z.N ;:.z.D + x];
 if[t = type .z.D ;:"p"$ x];
 if[t = type .z.T ;:"p"$ .z.D + x];
 if[t = type 12:00 ;:"p"$ .z.D + x];
 if[t = type ` ;:.todo.getDeadline0[x][]];
 '`.todo.error
 }

.todo.task:{[opt]
 uid:.bt.guid1[];
 opt:(`uid`puid`stime!(uid;uid;.z.P)), @[;`deadline;.todo.getDeadline] opt;
 .todo.db insert opt;
 opt`uid
 }

d) function
 todo
 .todo.task
 Function to get all todo data
 q)uid:.todo.task `mode`task`description`priority`deadline!(`private;`todo;"add todo app";`normal;`today)
 q).todo.subtask opt:`puid`task`description`priority`deadline!(uid;`task;"add task";`normal;`today)
 q)uid:.todo.task`mode`task`description`priority`deadline!(`work;`rebalance;"add to onenote";`normal;`tomorrow)
 q).todo.subtask  `puid`task`description`priority`deadline!(uid;`rebalance;"liaise with x";`normal;`tomorrow)
 q).todo.task    `mode`task`description`priority`deadline!(`family;`hans_zimmer;"check to amend name";`normal;30D)
 q).todo.task    `mode`task`description`priority`deadline!(`privat;`activity;"add activity app";`normal;18:00 + .z.D + 2)


.todo.subtask:{[opt]
 p:0!$[-2h = type opt`puid;select from .todo.db where uid = opt`puid;select from .todo.db where (string uid) like (string[opt`puid],"*") ];
 if[0=count p;'`.todo.error];
 uid:.bt.guid1[];
 opt:update uid:uid,puid:p[0]`puid ,.todo.getDeadline deadline,stime:.z.P,etime:0np from opt;
 .todo.task (p[0]),opt
 }

d) function
 todo
 .todo.subtask
 Function to get all todo data
 q)uid:.todo.task `mode`task`description`priority`deadline!(`private;`todo;"add todo app";`normal;`today)
 q).todo.subtask opt:`puid`task`description`priority`deadline!(uid;`task;"add task";`normal;`today)
 q)uid:.todo.task`mode`task`description`priority`deadline!(`work;`rebalance;"add to onenote";`normal;`tomorrow)
 q).todo.subtask  `puid`task`description`priority`deadline!(uid;`rebalance;"liaise with x";`normal;`tomorrow)
 q).todo.task    `mode`task`description`priority`deadline!(`family;`hans_zimmer;"check to amend name";`normal;30D)
 q).todo.task    `mode`task`description`priority`deadline!(`privat;`activity;"add activity app";`normal;18:00 + .z.D + 2)


.todo.ptime:{[pnow]
 dnow:`date $ pnow;
 ptime:()!();
 ptime[`today]:"p" $  dnow + 1;
 ptime[`tomorrow]:"p" $ dnow + 2;
 ptime[`1Week]:"p" $ 6 + `week$dnow;
 ptime[`2Week]:"p" $ 13 + `week$dnow;
 ptime[`3Week]:"p" $ 20 + `week$dnow;
 ptime[`4Week]:"p" $ 27 + `week$dnow;
 ptime[`nextMonth]:"p" $ -1 + `date$ 3+`month$dnow;
 ptime[`thisHalfYear]:"p" $ -1 + `date$ 7+`month$dnow;
 ptime[`thisYear]:"p" $ -1 + 0wp;
 ptime[`ptoday]:"p" $ dnow;
 ptime[`yesterday]:"p" $ dnow - 1;
 ptime[`pastWeek]:"p" $`week$dnow;
 ptime[`pastMonth]:"p" $ `date$`month$dnow;
 ptime[`pastHalfYear]:"p" $ `date$-6+`month$dnow;
 ptime[`pastYear]:"p" $ `date$-12+`month$dnow;
 ptime[`past10Years]:"p" $ `date$-120+`month$dnow;
 ptime[`notDone]:-0wp;
 ptime[`now]:pnow;
 ptime[`1hrs]:pnow + 01:00;
 ptime[`3hrs]:pnow + 03:00;
 ptime[`6hrs]:pnow + 06:00;
 ptime[`p1hrs]:pnow - 01:00;
 ptime[`p3hrs]:pnow - 03:00;
 ptime[`p6hrs]:pnow - 06:00 ;
 t:select label:first label by time from `time xasc([]label:key ptime;time:value ptime);
 t0:`s# exec time! label from t where time<pnow;
 t1:`s# exec time! `nextYear ^ next label from t where time>=pnow;
 `s#t0,t1
 }

.todo.summaryQuick:{[x]
 allData:update headId:(puid!uid) over puid from 0!select from get[ .todo.db] where deadline  <= 2D + .z.D;
 allData:select from allData where not null deadline,null etime;
 allData: `headId`puid`uid xcols update uid:`${first "-"vs x}@'string uid,puid:`${first "-"vs x}@'string puid,headId:`${first "-"vs x}@'string headId  from allData;
 ptime:.todo.ptime[.z.P];
 `mode`task`stime`etime`description`priority`sdeadline# `headId`deadline xasc update etime:ptime etime, stime:ptime stime,sdeadline:ptime deadline,deadline from allData
 }

d) function
 todo
 .todo.summaryQuick
 Function to get a quick summary
 q).todo.summaryQuick[]

.todo.summaryLong:{
 allData:update headId:(puid!uid) over puid from 0!get .todo.db;
 allData: `headId`puid`uid xcols update uid:`${first "-"vs x}@'string uid,puid:`${first "-"vs x}@'string puid,headId:`${first "-"vs x}@'string headId  from allData;
 ptime:.todo.ptime[.z.P];
 `headId`puid`uid`mode`task`stime`etime`description`priority`sdeadline`deadline# `headId`deadline xasc update etime:ptime etime, stime:ptime stime,sdeadline:ptime deadline,deadline from allData
 }

d) function
 todo
 .todo.summaryLong
 Function to get a quick summary
 q).todo.summaryLong[]

.todo.summaryRaw:{
 allData:update headId:(puid!uid) over puid from 0!get .todo.db;
 allData
 }

d) function
 todo
 .todo.summaryRaw
 Function to get a quick summary
 q).todo.summaryRaw[]

.todo.summary1:{
 allData:update headId:(puid!uid) over puid from 0!get .todo.db;
 allData: `headId`puid`uid xcols update uid:`${first "-"vs x}@'string uid,puid:`${first "-"vs x}@'string puid,headId:`${first "-"vs x}@'string headId  from allData;
 allData:update headId:(headId!task) headId  from `headId xasc  allData;
 allData:update status:`placeholder from  allData where null etime;
 allData:update status:`notDone from  allData where etime=-0wp;
 allData:update status:`done^status from allData;
 allData
 }

d) function
 todo
 .todo.summary1
 Function to get a quick summary
 q).todo.summary1[]
 q).baum.tbaum[.todo.summary1[];"mode,headId,task,status ~~ counts:count uid,mnDate:min`date$stime,mxDate:max`date$stime"] .baum.open["mode:private"] ()


.todo.getTask:{[opt]
 if[not 99h = type opt;opt:(1#`uid)!enlist opt];
 opt:((1#`comment)!enlist"no comment"),opt;
 p:0!$[-2h = type opt`uid;select from .todo.db where uid = opt`uid;select from .todo.db where (string uid) like (string[opt`uid],"*") ];
 if[0=count p;'`.todo.error ];
 `opt`p0!(opt;p 0)    
 }

.todo.markDone:{[opt] .todo.task update etime:.z.P,description:(description,"\n",r[`opt]`comment) from (r:.todo.getTask opt)`p0 }

d) function
 todo
 .todo.markDone
 Mark task as done
 q)uid:.todo.task `mode`task`description`priority`deadline!(`private;`todo;"add todo app";`normal;14D) 
 q)suid:`$first "-" vs string uid
 q).todo.markDone uid
 q).todo.markDone suid
 q).todo.markDone `uid`comment!(uid;"my comment")
 q).todo.markDone `uid`comment!(suid;"my comment")

.todo.markNotDone:{[opt] .todo.task update etime:-0wp,description:(description,"\n",r[`opt]`comment) from (r:.todo.getTask opt)`p0 }

d) function
 todo
 .todo.markNotDone
 Mark task as done
 q)uid:.todo.task `mode`task`description`priority`deadline!(`private;`todo;"add todo app";`normal;14D) 
 q)suid:`$first "-" vs string uid
 q).todo.markNotDone uid
 q).todo.markNotDone suid
 q).todo.markNotDone `uid`comment!(uid;"my comment")
 q).todo.markNotDone `uid`comment!(suid;"my comment")


.todo.activity:{[task;stime;etime;description] .todo.task `mode`task`stime`etime`description`priority`deadline!(`activity;task;stime;etime;description;`normal;etime)}


d) function
 todo
 .todo.activity
 create an activity
 q).todo.activity[`ignore;.z.P;.z.P + 05:00;"ignore me"]


.todo.summaryToday:{select uid:`${first "-"vs x}@'string uid,mode,task,priority,sdeadline:.todo.ptime[.z.P] deadline from .todo.summaryRaw[] where .z.D >= `date$deadline, null etime, not null deadline}

d) function
 todo
 .todo.summaryToday
 get today's task
 q).todo.summaryToday[]


.todo.getLongTask:{delete headId,puid,deadline from `deadline xasc select from .todo.summaryLong[] where null etime,not null sdeadline}

d) function
 todo
 .todo.getLongTask
 get all tasks
 q).todo.getLongTask[]



