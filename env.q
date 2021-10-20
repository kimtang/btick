


.env.plantsrc:{x:`$"/"sv -1_"/"vs string x;$[null x;`.;x]}  .env.arg`folder

/ .env.loadLib:{{@[system;;()] .bt.print["l %btsrc%/lib/%lib%/%lib%.q"] .env , enlist[`lib]!enlist x}@'x};
.env.loadBehaviour:{{
 arg:.env , `behaviour`module! (first` vs x),x;
 files:.bt.md[`bfile] .bt.print["%btsrc%/behaviour/%behaviour%/%module%.q"]arg;
 files:files,.bt.md[`ofile] .bt.print["%plantsrc%/behaviour/%behaviour%/%module%.q"]arg;
 if[f~key f:`$.bt.print[":%ofile%"]files;:@[system;;()] .bt.print["l %ofile%"]files];
 if[f~key f:`$.bt.print[":%bfile%"]files;:@[system;;()] .bt.print["l %bfile%"]files];
 }@'x};


.env.btsrc:getenv`BTSRC;
/ .env.yml2json:"yaml2json"
.env.behaviours:1#`pm;

.env.win:"w"=first string .z.o;
.env.lin:not .env.win;