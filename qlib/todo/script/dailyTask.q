args:.Q.def[`name`port!("name";8899);].Q.opt .z.x

/ remove this line when using in production
/ name:localhost:8899::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8899"; } @[hopen;`:localhost:8899;0];

\l qlib.q


.import.repository `name`path!(`life1;"C:\\Users\\kuent\\Google Drive\\main\\life");


.import.module`util;
.import.module`todo;


.util.radnomSeed[];

workout:`7ea4d431
coldshower:`782c5346
noAlcohol:`245f5516
earlySleep:`e30bab29
livingUid:`6b543e16
investmentUid:`386206c0
familyUid:`2d8d8309
appDevUid:`0636d4ed
read30m:`6f576841
financeUid:`b73342e5

.todo.subtask `puid`task`description`priority`deadline!(workout;`workout;"workout for 30min";`normal;`today)
.todo.subtask `puid`task`description`priority`deadline!(coldshower;`coldshower;"cold shower for 1min";`normal;`today)
.todo.subtask `puid`task`description`priority`deadline!(noAlcohol;`noAlcohol;"no alcoohol";`normal;`today)
.todo.subtask `puid`task`description`priority`deadline!(earlySleep;`earlySleep;"sleep before 9pm";`normal;`today)
.todo.subtask `puid`task`description`priority`deadline!(read30m;`read30m;"read 30min";`normal;`today)
.todo.subtask `puid`task`description`priority`deadline!(financeUid;`bankStatement;"enter bank statement";`normal;`today)

exit 0