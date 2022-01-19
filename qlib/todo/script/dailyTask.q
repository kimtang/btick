

\l qlib.q


.import.repository `name`path!(`life;"C:\\Users\\kuent\\Google Drive\\main\\life");
.import.module`util;
.import.module`todo;
.import.module`activity;

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

exit 0