
/ createsystem.q:localhost:8888::


/ 
 q createsystem.q
\

\l qlib.q


.cs.input:{ -2 x; read0 0}

.cs.process:(!) . flip 2 cut (
	`bus;`library`arg!("randomSeed,setPort,hopen,bus.server,heartbeat.client,berror.client";enlist[`setPort]!enlist "%basePort% + 1" );
	`tick;`library`arg!("randomSeed,setPort,hopen,bus.client,tick.stream,tick.hft,heartbeat.client,berror.client";enlist[`setPort]!enlist "%basePort% + 2");
	`replay;`library`arg!("randomSeed,setPort,hopen,bus.client,tick.replay,heartbeat.client,berror.client";enlist[`setPort]!enlist "%basePort% + 3");
	`rdb;`library`arg!("randomSeed,setPort,hopen,bus.client,tick.sub,heartbeat.client,berror.client";enlist[`setPort]!enlist "%basePort% + 4");
	`cdb;`library`arg!("randomSeed,setPort,hopen,bus.client,tick.cdb,heartbeat.client,berror.client";enlist[`setPort]!enlist "%basePort% + 5");
	`gateway;`library`arg!("randomSeed,setPort,hopen,bus.client,gw.server,heartbeat.client,usage.client,berror.client";enlist[`setPort]!enlist "%basePort% + 6");
	`ctp;`library`arg!("randomSeed,setPort,hopen,bus.client,tick.sub,tick.cep,tick.ctp,heartbeat.client,usage.client,berror.client";enlist[`setPort]!enlist "%basePort% + 7");
	`dynamicHdb;`library`instance`arg!("randomSeed,dynamicPort,hopen,bus.client,gw.client,tick.hdb,heartbeat.client,usage.client,berror.client";4;enlist[`dynamicPort]!enlist "%basePort% + 20")
	)

.cs.schema:(!) . flip 2 cut (
	`tname;"ex1";
	`column;"time,uid,used,heap,peak,wmax,mmap,mphy,syms,symw,symw0";
	`tipe;"psjjjjjjjjj";
	`rattr;"sg*********";
	`hattr;"Sp*********";
	`tick;"default";
	`rsubscriber;"default";
	`hsubscriber;"default";
  	`addTime; 1b;
  	`ocolumn; "time,uid,used,heap,peak,wmax,mmap,mphy,syms,symw";
  	`upd; "{update symw0:symw from x}"  			
	)

.bt.add[`;`.createsystem.init]{[allData]
 -2 "Welcome!!!\nWe will create a kdb+ system based on btick for you.\n"
 }


.bt.add[`.createsystem.init;`.createsystem.getSystemName]{[allData]
 systemName:`$.cs.input"What is your kdb+ system called?: ";
 -2"Now you need to tell me the different subsystems";
 .bt.md[`systemName]systemName
 }

.bt.add[`.createsystem.getSystemName;`.createsystem.getSubsystems]{[allData]
 subsystems:enlist"asd";
 while[not` ~last subsystems;
 	subsystem:`$.cs.input .bt.print["What is your %0 subsystem?(Blank for skipping)"] enlist count subsystems;
 	if[subsystem in subsystems;-2"Duplicated names is not allowed"];
 	if[not subsystem in subsystems;subsystems:subsystems,enlist subsystem]; 	
 	]; 
 .bt.md[`subsystems] -1 _ 1 _ subsystems
 }

.bt.add[`.createsystem.getSubsystems;`.createsystem.getBaseport]{[allData]
 -2"Now you need to setup the baseport for different subsystems";
 subsystems:`admin`backfill,allData`subsystems;
 baseports:0#0;
 ind:0; 
 while[count[baseports] < count subsystems;
 	baseport:"J"$.cs.input .bt.print["What is the baseport of your %0 subsystem?"] enlist subsystems ind;
 	if[baseport~0nj ;-2"This is not a number"];
 	if[not baseport~0nj ;baseports:baseports,enlist baseport;ind:ind+1]; 	
 	];
 .bt.md[`global] ([]subsystem:subsystems; baseport:baseports)  
 }

.bt.add[`.createsystem.getBaseport;`.createsystem.createJson]{[allData;subsystems]
 -2"Now we will create the json file";
 system0:``global!enlist[{};] enlist[`] _ (.bt.md[`env]subsystems),raze enlist[enlist[`]!enlist{}],{(enlist x`subsystem)!enlist enlist[`basePort]!enlist x`baseport}@' allData`global;
 system0:enlist[`] _ system0,raze {enlist[x]!enlist enlist[`process]!enlist .cs.process}@'allData`subsystems;
 (`$.bt.print[":plant/%systemName%.json"] allData) 0: enlist .j.j system0;
 }

.bt.add[`.createsystem.createJson;`.createsystem.createSchema]{[allData]
 -2"Now we will create example json schema file";
 {[allData;subsystem]  (`$.bt.print[":plant/%systemName%/schemas/%subsystem%/%subsystem%.json"] (enlist[`subsystem]!enlist subsystem),allData) 0: enlist .j.j @[.cs.schema;`tname;:;string subsystem] }[allData]@'allData`subsystems
 }

.bt.add[`.createsystem.createSchema;`.createsystem.qlib;]{[allData]
 -2"Now we will create qlib file";
 (`$.bt.print[":qlib/.dignore"]allData)0:();
 (`$.bt.print[":qlib/%systemName%/%systemName%.q"]allData)0:{[allData;x] .bt.print[x]allData}[allData]@'("d) module";" %systemName%";" Library for %systemName%";" q).import.module`%systemName%";"";".%systemName%.summary:{}";"";"d) function";" %systemName%";" .%systemName%.summary";" Function to show summary";" q).%systemName%.summary[]");

 } 

.bt.add[`.createsystem.qlib;`.createsystem.exit]{[allData]
 -2"Everything created. We will exit now";	
 exit 0;
 } 

allData:.bt.action[`.createsystem.init] ()!();

/