d) module
 qxl
 Library to use kdb inside excel
 q).import.module`qxl


.qxl.parse0:()!()
.qxl.parse0[`b]:{"B"$string x } 
.qxl.parse0[`g]:{"G"$string x } 
.qxl.parse0[`x]:{"X"$string x } 
.qxl.parse0[`h]:{"H"$string x }
.qxl.parse0[`i]:{"I"$string x }
.qxl.parse0[`j]:{"J"$string x }
.qxl.parse0[`J]:{"J"$ " " vs string x }
.qxl.parse0[`e]:{"E"$string x }
.qxl.parse0[`f]:{"F"$string x }
.qxl.parse0[`c]:{first @'string x }
.qxl.parse0[`C]:{string x }
.qxl.parse0[`s]:{x } 
.qxl.parse0[`p]:{"p"$ .qxl.parse0[`z] x }
.qxl.parse0[`m]:{"m"$ .qxl.parse0[`d] x }
.qxl.parse0[`d]:{"d"$ ("j"$ x) - 36526 } 
.qxl.parse0[`z]:{"z"$ x  - 36526 } 
.qxl.parse0[`n]:{"n"$ .qxl.parse0[`z]x } 
.qxl.parse0[`u]:{"u"$ .qxl.parse0[`z]x } 
.qxl.parse0[`v]:{"v"$ .qxl.parse0[`z]x } 
.qxl.parse0[`t]:{"t"$ .qxl.parse0[`z]x }
.qxl.parse0[`]:{x}

.qxl.t2d:{
 r:update w:(.qxl.parse0 k)@'v from flip `k`f`v!flip x;
 exec f!w from r
 }

d) function
 qxl
 .qxl.t2d
 Function to give a sumnmary of the rlang module
 q) .qxl.t2d ((`b;`old;"10");(`b;`old1;"01"))


.qxl.t2t:{
 format:@[;where format=`ExcelEmpty;:;`] format:x 0;
 column:x 1; 	
 ![flip column!flip 2_x;();0b;column!column{(y;x)}'.qxl.parse0 format]	
 } 

d) function
 qxl
 .qxl.t2t
 Deprecated, dont use
 q) .qxl.t2t[]
 q) .qxl.t2t`


.qxl.pc:{first parse["select from t where ",x]2}
.qxl.pb:{parse["select by ",x," from t"]3}
.qxl.pa:{parse["select ",x," from t"]4}

.qxl.s:{
 x:.qxl.t2d x;
 x:(``s`d`c`b`a!({};();();();0b;())),x;
 if[-11h=type x`c;x:@[x;`c;string]];
 if[-11h=type x`b;x:@[x;`b;string]];
 if[-11h=type x`a;x:@[x;`a;string]];
 if[-11h=type x`s;x:@[x;`s;string]];
 if[-11h=type x`d;x:@[x;`d;string]];  
 if[10h=abs type x`c;x:@[x;`c;.qxl.pc]];
 if[10h=abs type x`b;x:@[x;`b;.qxl.pb]];
 if[10h=abs type x`a;x:@[x;`a;.qxl.pa]];
 if[10h=abs type x`s;x:@[x;`s;{key .qxl.pa
  x }]]; 
 if[10h=abs type x`d;x:@[x;`d;get]];  
 r:?[get string x`t;x`c;x`b;x`a];
 if[(()~x`d) or ()~x`s;:r];
 x[`d][x[`s];0!r]
 }

d) function
 qxl
 .qxl.s
 Function to give a select statement in excel
 q) .qxl.s (`s`t`performance;(`C`c,`$"date=max date, index =1");`C`ba`ExcelEmpty;`C`ab`ExcelEmpty;`s`s`place;`s`d`xasc)
 q) tmp:([]a:1 2 3 4;b:2*1 2 3 4);.qxl.s (`s`t,`tmp;(`C`c,`$"a=max a");`C`ba`ExcelEmpty;`C`ab`ExcelEmpty;`s`s`a;`s`d`xasc)


.qxl.u:{
 .qxl.x:x;
 x:.qxl.t2d x;	
 x:(``s`d`c`b`a!({};();();();0b;())),x;
 if[-11h=type x`c;x:@[x;`c;string]];
 if[-11h=type x`b;x:@[x;`b;string]];
 if[-11h=type x`a;x:@[x;`a;string]];
 if[-11h=type x`s;x:@[x;`s;string]];
 if[-11h=type x`d;x:@[x;`d;string]];  
 if[10h=abs type x`c;x:@[x;`c;.qxl.pc]];
 if[10h=abs type x`b;x:@[x;`b;.qxl.pb]];
 if[10h=abs type x`a;x:@[x;`a;.qxl.pa]];
 if[10h=abs type x`s;x:@[x;`s;{key .qxl.pa x }]]; 
 if[10h=abs type x`d;x:@[x;`d;get]];  

 r:![get string x`t;x`c;x`b;x`a];
 if[(()~x`d) or ()~x`s;:r];
 x[`d][x[`s];r]
 } 

d) function
 qxl
 .qxl.u
 Function to give an update statement in excel
 q) tmp:([]a:1 2 3 4;b:2*1 2 3 4);.qxl.s (`s`t,`tmp;(`C`c,`$"a=max a");`C`ba`ExcelEmpty;`C`ab`ExcelEmpty;`s`s`a;`s`d`xasc)