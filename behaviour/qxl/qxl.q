
.qxl.parse0:()!()
.qxl.parse0[`b]:{"B"$string x } 
.qxl.parse0[`g]:{"G"$string x } 
.qxl.parse0[`x]:{"X"$string x } 
.qxl.parse0[`h]:{"H"$string x }
.qxl.parse0[`i]:{"I"$string x }
.qxl.parse0[`j]:{"J"$string x }
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
 r:update w:(.qxl.parse0@/:k)@'v from flip `k`f`v!flip x;
 exec f!w from r
 }

.qxl.t2t:{
 format:@[;where format=`ExcelEmpty;:;`] format:x 0;
 column:x 1; 	
 ![flip column!flip 2_x;();0b;column!column{(y;x)}'.qxl.parse0 format]	
 } 

.qxl.p:{ ((`d`t!(.qxl.t2d;.qxl.t2t)) first x 0 ) 1_x} 