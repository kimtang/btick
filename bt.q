

\d .bt

/ timer functions
tme:enlist`id`fnc`arg`res`scheduleAt`runAt!(0;{};{};{};0np;.z.P)
ts:{
  / dirty hack to avoid :noamend error
  runId:exec id from`.bt.tme where scheduleAt<=.z.P ,null runAt;
  update runAt:.z.P from`.bt.tme where id in runId;  
  .bt.tme:.bt.tme lj 1!select id,res:{[fnc;arg] @[{[fnc;arg] `result`error!(fnc . arg;`) }fnc;arg;{`result`error!(()!();`$x)}] }'[fnc;arg] from `.bt.tme where id in runId;
 }

scheduleAt:{[fnc;arg;scheduleAt] `.bt.tme insert `id`fnc`arg`res`scheduleAt`runAt!(count .bt.tme;fnc;arg;{};scheduleAt;0np);}
scheduleIn:{[fnc;arg;scheduleIn] `.bt.tme insert `id`fnc`arg`res`scheduleAt`runAt!(count .bt.tme;fnc;arg;{};.z.P + scheduleIn;0np);}

.z.ts:.bt.ts

system "t 300";

/ helper function for parsing formulas
parseC:{(parse .bt.print["select from t where %0"] enlist x) 2}
parseB:{(parse .bt.print["select by %0 from t"] enlist x) 3}
parseA:{(parse .bt.print["select %0 from t"] enlist x) 4}



cfg0:()!()
cfg0[0nh]:{x}
cfg0[10h]:{ t:type r:@[get;x;x]; $[t>=98h;x;r] }
cfg0[99 98 0h]:3#{ cfg@'x }
cfg:{ cfg0[type x]x }

loadBehaviour:{[path;file]
 system .bt.print["l %path%\\%file%.q"] `path`file!(path;file);
 }


stdOut:{[level;msg] level: (`info`error!("INFO ";"ERROR")) level;1 .bt.print["%level%|%time%|%msg%\n"] `level`msg`time!(level;msg;.z.t) }
stdOut0:{[level;library;msg] level: (`info`error!("INFO ";"ERROR")) level;1 .bt.print["%level%|%time%|%library%|%msg%\n"] `level`msg`time`library!(level;msg;.z.t;library) }

/ debug functions

putAction:{
 seq0:max exec seq from .bt.history where action=x,mode = `behaviour;
 .bt.putArg seq0
 }

putArg:{
 h:exec from .bt.history where seq=x;
 b:.bt.repository h`action`mode;
 {x set' y } . (b;h)@\:`arg
 }

putResult:{
 h:exec from .bt.history where seq=x;
 {x set' y } . (key;value)@\:enlist[`] _ h`result
 }

reloadZf:{system"l ",string .z.f }

/ utility functions to get printfn function

parse0:{raze .Q.s2 x}
printf0:{""sv enlist[first s],{(parse0 x"J"$first y),1_y}[1_x]each 1_s:"%"vs x 0};
printf2:{raze@[s;t;:;]{$[10h = abs type x;x;parse0 x]}@'x[1]`$s t:t where"b"$mod[;2]t:til count s:"%"vs x 0}
printf:{$[10h=t:abs type x;(::);not 0h=t;parse0;99h=type x 1;printf2;printf0] x}
guid0:{x?0ng}
guid1:{first 1?0ng}
printf1:{(0 -10 10 100h!(printf;enlist;::;{x[]}))[type x] x}
print:{[x;y] printf $[99h=type y;(x;y);enlist[x],y] }

getArg0:()!()
getArg0[0nh]:{`}
getArg0[-11h]:{getArg value x}
getArg0[100h]:{last 2#get x}
getArg0[104h]:{r:getArg first arg:get x;r where (::)~'c#(1_arg),(c:count[r])#(::)}
getArg:{getArg0[type x]x }

execute:{[fnc;arg] fnc . ((enlist[ `allData]!enlist[arg]),arg) getArg fnc }

md:{(`,x)!({};y)}
getDelim:{ $["\\" in string x;"\\";"/"] }

seq:0
inc:{seq+:1;seq}

behaviours:2!flip`trigger`sym`dontcare!()
repository:2!flip`sym`mode`fnc`arg!()
sel:{ s:s!s:distinct `,exec sym from .bt.repository where mode = y;.bt.repository (s x),y}



trace0:{ [h;mode;obj] `.bt.history insert data:cols[.bt.history]# h,(`mode`etime`eseq!(mode;.z.P;inc[])),obj; outputTrace data; }
trace1:{ [h;mode;obj] `.bt.history insert data:cols[.bt.history]# h,(`mode`etime`eseq!(mode;.z.P;inc[])),obj,enlist[`result]!enlist{}; outputTrace data; }
trace2:{ [h;mode;obj] `.bt.history insert data:cols[.bt.history]# h,(`mode`etime`eseq!(mode;.z.P;inc[])),obj,`result`arg!({};{}); outputTrace data; }
trace:trace0

outputTrace0:{[data] .bt.stdOut0[ $[ null data`error;`info;`error] ;`bt] .bt.print["%action%:%mode%:%error%"] data }
outputTrace1:{[data]  }

outputTrace:outputTrace0

eiff:{[sym;allData]
 h:hist sym;  
 r:@[{[fnc;arg] `iff`error!(fnc . arg;`) }iff`fnc;;{`iff`error!(1b;`$x)}] arg:allData (iff: .bt.sel . sym,`iff)`arg;
 if[not (r`iff) and null r`error;trace[h;`iff;(enlist[`arg]!enlist arg),`result`error!r `iff`error];];
  r
 }

ecatch:{[sym;allData;error]
 h:hist sym;  
 catch:.bt.sel[sym]`catch;
 r:@[{[fnc;arg] `result`error!(fnc . arg;`) }catch`fnc;arg:(allData,enlist[`error]!enlist error:`$error)catch`arg;{`result`error!(()!();`$x)}];
  trace[h;`catch;(enlist[`arg]!enlist arg),r];
  r
 / `result`error!(()!();error)
 }

edelay:{[sym;allData]
 h:hist sym;
 delay:.bt.sel[sym;`delay];
 r: @[{[fnc;arg] `result`error!(fnc . arg;`) }delay`fnc;arg:allData delay`arg;{`result`error!(()!();`$x)}];
 / if[(not `noDelay=r . `result`tipe) or not null r`error ;trace[h;`delay; (enlist[`arg]!enlist arg), r]];
 trace[h;`delay; (enlist[`arg]!enlist arg), r];
 / if[not null r`error ;trace[h;`delay; (enlist[`arg]!enlist arg), r]];
 r
 } 

action:{[sym;allData]
 sym:$[10h=type sym;`$sym;sym];
 h:.bt.hist sym;  
 allData0:{x,(`$string[key x],\:"0")!value x} allData,enlist[`allData]!enlist allData;
 f:.bt.eiff[sym]allData0;
 if[not (f`iff) and null f`error;:allData]; 
 r:@[{[fnc;arg] `result`error!(fnc . arg;`) }[b`fnc];;.bt.ecatch[sym;allData0] ] arg:allData0(b:.bt.sel[sym]`behaviour)`arg;
 allData:allData,$[99h=type r`result;r`result;()!()];
 allData:allData,$[null r`error;.bt.trigger[sym;allData];()!()];
 .bt.trace[h;`behaviour; (enlist[`arg]!enlist arg), r ];
 allData 
 } 

/ trigger0:`.bt.init;
/ allData:obj;syms:`symbol$()

trigger:{[trigger0;allData]
 allData0:allData,enlist[`allData]!enlist allData;
 syms:distinct exec sym from .bt.behaviours where trigger = trigger0;
 result:update sym:syms from (flip`result`error!()),.bt.edelay[;allData0]@'syms;
 result:{update sym:x`sym from (flip`tipe`time!()),x`result} exec result,sym from result where null error;
 noDelay:select from result where tipe =`noDelay;
 delayAt:update scheduleAt:time from select from result where tipe =`at;
 delayIn:update scheduleAt:.z.P + time from select from result where tipe =`in;
 delay:delayAt,delayIn;
 {[allData;x].bt.scheduleAt[`.bt.action;(x`sym;allData);x`scheduleAt]}[allData]@'delay;
 l:enlist[()!()],{[allData;sym]@[.bt.action[;allData];sym;{enlist[`error]!enlist `$x}] }[allData]@'exec sym from noDelay;
 allData,raze l where 99h=type each l
 }

hist:{[sym]`action`time`seq!(sym;.z.P;inc[])}

history:enlist`action`mode`time`etime`seq`eseq`result`arg`error!(`;`;.z.P;.z.P;0nj;0nj;()!();()!();`)

/ api

add:{[trigger0;sym;behaviour] trigger0:((),trigger0) except `;
 {`.bt.behaviours upsert x,1b}@' ((),trigger0),\:sym;
 addBehaviour[sym]behaviour;
 }

addOnlyBehaviour:{[trigger0;sym] trigger0:((),trigger0) except `;
 {`.bt.behaviours upsert x,1b}@' ((),trigger0),\:sym;
 }

addRepository:{[sym;mode;fnc]`.bt.repository upsert (sym;mode;fnc;getArg fnc)}
addBehaviour:{[sym;fnc] addRepository[sym;`behaviour;fnc]; }
addIff:{[sym;fnc] addRepository[sym;`iff;fnc]; }
addCatch:{[sym;fnc] addRepository[sym;`catch;fnc]; }
addDelay:{[sym;fnc] addRepository[sym;`delay;fnc]; }

remove:{[sym] ![;enlist (=;`sym;1#sym);0b;0#`]@'`.bt.behaviours`.bt.repository;}


always_true:{1b}
throw_error:{[error]'error}
omit_error:{[error]}
do_nothing:{[allData]}
no_delay:{[allData]`tipe`time!(`noDelay;0np)}

addRepository[`;`placeholder]{};
addBehaviour[`]`.bt.do_nothing
addIff[`]`.bt.always_true
addCatch[`]`.bt.throw_error
addDelay[`]`.bt.no_delay
