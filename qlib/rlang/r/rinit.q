

if[not `bt in key `;system "l bt.q"];

\d .r

dll:.bt.print["%btsrc%/qlib/rlang/r/rserver/%zo%/rserver"] `btsrc`zo!(getenv`btsrc;.z.o)

// dll:`:C:/q/r/rserver/w32/rserver
nsc:"kdb."
i:0; / index to store the anonymous variable
s:.z.o;

calc:1b;

/ Rclose:$[s~`w32;.r.dll 2:(`rclose;1);{[x]}]
/ Ropen:$[s~`w32; .r.dll  2:(`ropen;1) ;{[x]}] 
/ Rcmd:$[s~`w32; .r.dll   2:(`rcmd;1);{[x]}]  
/ Rget:$[s~`w32; .r.dll   2:(`rget;1);{[x]}]  
/ Rset:$[s~`w32; .r.dll   2:(`rset;2);{[x;y]}]

Rclose:.r.dll 2:(`rclose;1)
Ropen: .r.dll  2:(`ropen;1)
Rcmd:  .r.dll   2:(`rcmd;1)
Rget:  .r.dll   2:(`rget;1)
Rset:  .r.dll   2:(`rset;2)

Rset_      : ()!()
Rset_[1b] : { t:@[value;x;()];t:$[100h=type t ;();t];if[0<count t; .r.Rset[string x;t] ]; :x} / for symbol
Rset_[0b] : { .r.Rset[n:.r.nsc,string .r.i;x];.r.i+:1; :`$n } / for non-symbol

rset       : { :{ .r.Rset_[-11h=type x] x}each x }

con:{distinct `$ ssr[;"`";""] each res where {x like "`*"} res:{raze y vs/:x} over enlist[enlist x]," $(,~=<-)"}

e:{ if[not calc;:0N!"R turned off"]; rset t:.r.con x;.r.Rcmd str:ssr[;"`";""] x;"r)",1_str; }

conv:()!()
conv[`Date]:{`date$x[1]-10957}
conv[`levels]:{ syms: `$x . 0 0; :syms x[1] - 1 }
conv[`string]:{ `$x }
frame_:()!()
frame_[1b]:{r:raze {$[type[x] in (0 10h);`$x; x]} each x 0;
			r:$[10h=type r;`string;r];
			sym:first key[.r.conv] inter r;
			 .r.conv[sym] x}
frame_[0b]:{x}

\d .

\d .p
e:{  .r.e "print(",x,")" }
\d .

Rts:{@[.r.Rcmd;"try(system('dir', intern = FALSE, ignore.stdout = TRUE, ignore.stderr = TRUE))";()]};




$[not `bt in key `
 ;.z.ts:Rts
 ;[
  .bt.add[``.r.ts;`.r.ts]{Rts[]};
  .bt.addDelay[`.r.ts]{`tipe`time!(`in;00:00:00.400)};
  .bt.action[`.r.ts] ()!()
  ]
 ]


\t 500

r) Sys.setenv(TZ='GMT')

/turn off the device
RSet:.r.Rset
Rcmd:.r.Rcmd
Rclose:.r.Rclose
Ropen:.r.Ropen
Rget:{ .r.rset t:.r.con x:$[10h=abs type x;x;string x];.r.Rget ssr[;"`";""] x }
Rset:.r.rset
Roff:{Rcmd "dev.off()"}
Rnew:{Rcmd "dev.new()"}

/ create table from dataframe
/ Rframe:{flip (`data.frame,`$t .(0;0)) !enlist[`$t .(0;4)] ,(t:Rget x) 1}

Rframe:{ t:Rget x; nme:`$t . 0 0;rns:t . 0 2;
		 mat:{ .r.frame_[0h=type x]  x } each t[1];
		 rns:$[count[rns]=count first mat; @[(`$);rns;rns];til count first mat];
		 /(nme;rns;mat)
		 flip ((`$"row_names"),nme)!enlist[rns],mat }

Rframe1:{x:$[-11h=type x;string x;x];Rframe "as.data.frame(",x,")"}

Rplot_  : {s:string Rset y; @[Rcmd; str:string[x],"(",(1_raze ",",/:s),")";()];.r.i:0;str } 
Rplot   : Rplot_[`plot]
Rboxplot: Rplot_[`boxplot]
Rhist   : Rplot_[`hist]
Rrug    : Rplot_[`rug]
Rlines  : Rplot_[`lines]
Rtext   : Rplot_[`text]
Rmosaic   : Rplot_[`mosaicplot]

smap:{enlist[x 0 ]!enlist x 1}

cstr:{","sv key[x]{ystr:$[-11h = type y;string y; $[99h=type y; cstr y; "'",y,"'"] ];
       $[99h=type y;string[x],"(",ystr,")";$[0=count ystr;string[x],"()";string[x],"=",ystr]]
    }'value x};

ggplot:{ pmap:{key[x]{enlist[x]!enlist[y]}'value x};
    xstr:"ggplot(",("," sv cstr each pmap x),")";
    ystr: "+" sv cstr each pmap y ;cmd:"+" sv (xstr;ystr);
    "print(",cmd,")"};

Rl2d:{ (`$x . 0 0)!x 1}
Rdimnames:{ v:x 1;
 rnames:`$x . (0 2 0);
 cnames:`$x . (0 2 1); 
 :flip ((`variable,())!enlist rnames),cnames!flip v}

RSlm:{
 l:Rget "summary(",x,")";
 l1:`call`coefficients`sigma`df`r.squared`adj.r.squared`fstatistic`cov.unscaled`residuals # Rl2d l;
 l1[`residuals]:l1[`residuals] 1;
 l1[`fstatistic]: Rl2d l1 `fstatistic;
 l1[`coefficients] : Rdimnames l1 `coefficients;
 l1[`confint] : Rdimnames Rget "confint(",x,")";
 l1[`cov.unscaled] : Rdimnames l1 `cov.unscaled;l1}





/
1+5
Test function
Rplot (til 10;xexp[;first 1?1.0] til 10 )


/
1+1
\l R.q

Rcmd "library(ggplot2)"

Rframe "diamonds"