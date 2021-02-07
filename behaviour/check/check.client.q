
/ "powershell \"Get-Process q|Select-Object Id,CPU,NPM,PM,WS,VM,StartTime|ConvertTo-Csv -Delimiter ',' -NoTypeInformation\""

.checker.ps.wstring:-9! 0x01000000840000000a0076000000706f7765727368656c6c20224765742d50726f6365737320717c53656c6563742d4f626a6563742049642c4350552c4e504d2c504d2c57532c564d2c537461727454696d657c436f6e76657274546f2d437376202d44656c696d6974657220272c27202d4e6f54797065496e666f726d6174696f6e22


.checker.ps.win:{
 tbl:system .checker.ps.wstring;
 `pid`cpu`npm`pm`ws`vm`starttime xcol("jfjjjjp";", ") 0: tbl
 }

.bt.addIff[`.checker.init.win]{ .env.win }
.bt.add[`.library.init;`.checker.init.win]{}

.bt.addDelay[`.checker.loop.win]{`tipe`time!(`in;00:00:02) }
.bt.add[`.checker.init.win`.checker.loop.win;`.checker.loop.win]{
 ps:.checker.ps.win[];
 procs:(.bt.action[`.pm.init] (`subsys`cmd`proc`debug`print!``status`all,10b),`folder`cfg#$[()~key `.proc;.env.arg;.proc])`result;
 `topic`data!enlist[`.check.receive.ps;] select time:.z.P,uid,port,pid,cpu,npm,pm,ws,vm,starttime  from procs lj 1!ps
 }

.bt.addOnlyBehaviour[`.checker.loop.win]`.bus.sendTweet 


/

flip select from .bus.con where uid = `oura.admin.tick.0

reverse select by arg[;`topic] from .bt.history where action =`.bus.sendTweet,mode=`behaviour 

reverse select from .bt.history where action =`.bus.receiveTweet

.fromInside,mode=`behaviour 

