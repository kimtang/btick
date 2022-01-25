args:.Q.def[`name`port!("kaizen/markTask.q";9908);].Q.opt .z.x

/ remove this line when using in production
/ kaizen/markTask.q:localhost:9908::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 9908"; } @[hopen;`:localhost:9908;0];

\l qlib.q

.import.repository `name`path!(`life;"C:\\Users\\kuent\\Google Drive\\main\\life");

.import.module`util;
.import.module`todo;

\c 1000 1000

-1 "Hello User";
-1 "This process is to mark task from today as markDone or markNotDone.";
-1 .Q.s .todo.getLongTask[];
-1 "Just enter the suid from the task or just summary to get summary again";
-1 "Mode is set to markDone";

/ .z.pi:{(.Q.s1 value x),"\n"}

.markTask.mode:`markDone

.z.pi:{[x]
 suid:`$-1_x;
 tasks:.todo.getLongTask[];
 if[suid~`summary;:.Q.s[ .todo.getLongTask[]],"\nMode is marked as ",string[.markTask.mode],"\n" ];
 if[suid in `markNotDone`markDone;.markTask.mode:suid; :.bt.print["Mode is marked as %mode%\n"] .markTask ];
 if[suid in tasks`task;suid: first exec uid from tasks where task = suid; ];
 if[suid in tasks`uid;
    (.todo  .markTask.mode) suid;
    :.bt.print["%suid% is marked as %mode%\n"] `suid`mode !(first exec task from tasks where uid = suid;.markTask.mode)
    ];
 (.Q.s value x),"\n"
 }

.timer.con:.todo.getLongTask[];

.bt.add[`;`.timer.init]{}

.bt.addDelay[`.timer.summary.loop]{`tipe`time!(`in;`second$3)}
.bt.add[`.timer.init`.timer.summary.loop;`.timer.summary.loop]{
 con:.todo.getLongTask[];
 if[con~.timer.con;:()];
 .timer.con:con;
 -1 .Q.s[ .todo.getLongTask[]],"\nMode is marked as ",string[.markTask.mode],"\n" ;
 }




