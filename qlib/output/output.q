d) module
 output
 output provides a set of functions to output messages in console
 q).import.module`output

.import.require`util

.output.summary:{}

d) function
 output
 .output.summary
 Show a summary 
 q) .output.summary[]

.o.e:{.output.msg::x;.output.msg:}

.output.skx:"  KX  "
.output.msg:""

.output.getBlank:{
 wsize:.util.windowSize[];
 wsize[1]#enlist wsize[0]#" " 
 }

.output.cmessage:{[msg]
 if[10h=type msg;msg:"\n"vs msg];
 blk:.output.getBlank[];
 messages:([]m:msg);
 .output.skx:-1 rotate .output.skx;
 arg:`date`time`kx!(.z.D;`second$.z.T;.output.skx);
 messages:update nm:{.bt.print[y] x  }[arg]'[m] from messages;
 bsize:count blk;
 lsize:count blk 0 ;
 messages:update line:i+ceiling[ 0.5 * bsize ] - floor  0.5 * count i,msize: count@'nm from messages;
 messages:update fpoint:{[lsize;nm] ceiling[ 0.5 * lsize ] - floor  0.5 * count nm }'[lsize;nm] from messages;
 messages:update epoint:fpoint+msize from messages  ;
 {[x;y] @[x;y`line;{[x;y] @[x;{x+til y - x} . y`fpoint`epoint;:;y`nm] };y]}/[blk;messages]
 }


.output.showScreen:{[msg]
 1 "\n"sv .output.cmessage msg
 }

.bt.add[`;`.output.init]{[allData]}

.bt.addDelay[`.output.loop]{`tipe`time!(`in;00:00:00.700)}
.bt.add[`.output.init`.output.loop;`.output.loop]{[allData]}

.bt.addIff[`.output.screen]{not 0=count .output.msg}
.bt.add[`.output.loop;`.output.screen]{ .output.showScreen .output.msg} 

.bt.action[`.output.init] ()!()