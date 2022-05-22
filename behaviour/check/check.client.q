
/ "powershell \"Get-Process q|Select-Object Id,CPU,NPM,PM,WS,VM,StartTime|ConvertTo-Csv -Delimiter ',' -NoTypeInformation\""

/ .checker.ps.wstring:-9! 0x01000000840000000a0076000000706f7765727368656c6c20224765742d50726f6365737320717c53656c6563742d4f626a6563742049642c4350552c4e504d2c504d2c57532c564d2c537461727454696d657c436f6e76657274546f2d437376202d44656c696d6974657220272c27202d4e6f54797065496e666f726d6174696f6e22

.checker.ps.wstring:"powershell \"Get-Process q|Select-Object MainWindowTitle,Id,CPU,NPM,PM,WS,VM,StartTime|ConvertTo-Csv -Delimiter ',' -NoTypeInformation\""

.checker.ps.win:{
 tbl:system .checker.ps.wstring;
 tbl:update { "P"$ ("."sv reverse "/"vs first x),"D",last x:" " vs x}@'starttime from `cmd`pid`cpu`npm`pm`ws`vm`starttime xcol("*jfjjjj*";", ") 0: tbl;
 wmic:system"wmic path win32_perfformatteddata_perfproc_process get Name, Caption, PercentProcessorTime, IDProcess /format:csv";
 wmic:select pid,cpu from flip`host`nouse`pid`name`cpu !("**J*F";",") 0: 2_ {ssr[x ;"c"$ 0x00;""] }@'wmic;
 tbl lj 1!wmic
 }


.bt.addIff[`.checker.init.win]{ .util.isWin }
.bt.add[`.library.init;`.checker.init.win]{
 folder:`$last "/" vs string .env.arg`folder;
 .checker.procs:(.bt.action[`.pm.init] (`subsys`cmd`proc`debug`print!``statusAll`all,10b),`folder`cfg!(folder;.env.arg`cfg))`result;
 }

.bt.addDelay[`.checker.loop.win]{`tipe`time!(`in;00:00:02) }
.bt.add[`.checker.init.win`.checker.loop.win;`.checker.loop.win]{
 ps:.checker.ps.win[];
 `topic`data!enlist[`.check.receive.ps;] select time:.z.P,uid,port,pid,cpu,npm,pm,ws,vm,starttime from  .checker.procs lj 1!ps
 }

.bt.addOnlyBehaviour[`.checker.loop.win]`.bus.sendTweet 


/