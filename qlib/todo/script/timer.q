args:.Q.def[`name`port!("kaizen/timer.q";9909);].Q.opt .z.x

/ remove this line when using in production
/ kaizen/timer.q:localhost:9909::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 9909"; } @[hopen;`:localhost:9909;0];

\l qlib.q

.import.repository `name`path!(`life1;"C:\\Users\\kuent\\Google Drive\\main\\life");
.import.module`todo;
.import.module`rlang;

r)library(beepr)


.timer.wsize0:{ lst where not null lst:"J"$ " " vs system["powershell -command \"&{(get-host).ui.rawui.WindowSize;}\""] 3}
.timer.wsize:.timer.wsize0[]

.timer.con:flip`mode`task`stime`etime`comment!"sspp*"$\:()

.timer.summary:{0!select description:description 0 by task from .todo.summaryRaw[]}

/.bt.scheduleIn[.bt.action[`.timer.init];;00:00:01] ()!();

.bt.add[`;`.timer.init]{}

.bt.addDelay[`.timer.set.wsize]{ `tipe`time!(`in;00:00:10) }
.bt.add[`.timer.init`.timer.set.wsize;`.timer.set.wsize]{
 old:.timer.wsize0[];if[old~.timer.wsize;:()];
 .timer.wsize:old;
 system .bt.print["c %0 %1"] .timer.wsize;
 }




.bt.addDelay[`.timer.count.print]{ `tipe`time!(`in;00:00:03) }
.bt.add[`.timer.init`.timer.count.print;`.timer.count.print]{}

.bt.addIff[`.timer.print]{ 1=count .timer.con }
.bt.add[`.timer.count.print;`.timer.print]{
 con:.timer.con 0;
 con[`duration]:`second$ $[`countUp = con`mode;.z.P - con`stime ;con[`etime] - .z.P ];
 msg:.bt.print["%mode%|%task%|%duration% "] con;
 -1 "\n"sv {reverse[2#x] ,2_x}(first .timer.wsize) cut msg,count[msg] _ prd [.timer.wsize]#" " 
 }


.bt.addIff[`.timer.check.stop]{ (1=count .timer.con) and (`countDown = .timer.con[0]`mode) and  .z.P >= .timer.con[0]`etime }
.bt.add[`.timer.count.print;`.timer.check.stop]{}


.bt.addIff[`.timer.count.Noaction]{[allData] not all `task`time`comment in key allData }
.bt.add[`.timer.count;`.timer.count.Noaction]{
 .bt.md[`msg] "Missing argument"
 }

.bt.addIff[`.timer.count.alreadyCount]{[allData] (all `task`time`comment in key allData) & not 0=count .timer.con}
.bt.add[`.timer.count;`.timer.count.alreadyCount]{
 .bt.md[`msg] "Only one job is allowed"
 }

.bt.addIff[`.timer.count.action]{[allData] (all `task`time`comment in key allData) & 0=count .timer.con }
.bt.add[ `.timer.count;`.timer.count.action]{[task;time;comment] `.timer.con insert ($[null time;`countUp;`countDown];task;.z.P;$[null time;0np;.z.P + time];comment);}


-1 "Hello User";
-1 "This process is to mark your activity using a timer.";
-1 "Just enter the task like break,work,learning,... ";
-1 "It will ask you for a time for a count down. If you enter nothing then it is a count up.";
-1 .Q.s .timer.summary[];

.z.pi:{[x]
 task:`$-1_x;
 if[null task;:""];
 if[task~`stop;:(.bt.action[`.timer.stop]()!())`msg ];
 if[task~`summary;:.Q.s .timer.summary[] ];
 -1 "Got task ",string[task],"\n";
 -1 "Enter time for count down or nothing for count down\n";
 time:"N"$ read0 0;
 -1 "Enter comment\n";
 comment:read0 0;
 r:.bt.action[`.timer.count] `task`time`comment!(task;time;comment);
 r`msg 
 }

.bt.add[`.timer.check.stop;`.timer.stop]{
 msg:"Nothing to stop";
 if[0=count .timer.con;:.bt.md[`msg] msg ];
 con:.timer.con 0;
 con[`etime]:.z.P;
 con[`duration]:con[`etime] - con`stime;
 .todo.activity . con`task`stime`etime`comment;
 "r" "beep(3)";
 msg:.bt.print["Task %task% added with duration %duration%"] con;
 .timer.con:0#.timer.con
 }


.bt.action[`.timer.init] ()!()

/

select from .bt.history where not null error
select cnt:count i by action from .bt.history






