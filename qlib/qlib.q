/ placeholder for this qlib 

.d.conFunc:3!flip`folder`module`func`desc`example`body!()
.d.conMod:2!flip`folder`module`desc`example!()

.d.folder:`qlib
.d.isSummary:0b

.d.e:{
 .d.e0[`$first a] 1_a:"\n" vs x
 }

.d.e0:()!()
.d.e0[`function]:{[x]
 body:$[.d.folder=`qlib;@[get;`$x 1;{`notavail}];.bt.repository[(`.hopen.add;`behaviour)]`fnc]; 
 result:`folder`module`func`desc`example`body!(.d.folder;`$x 0;`$x 1;x 2;"\n"sv 3_x ; body );
 `.d.conFunc upsert enlist result;
 }

.d.e0[`variable]:{[x]
 `.d.conFunc upsert enlist `folder`module`func`desc`example`body!(.d.folder;`$x 0;`$x 1;x 2;"\n"sv 3_x ; `notavail );
 } 

.d.e0[`module]:{[x]
 `.d.conMod upsert enlist `folder`module`desc`example!(.d.folder;`$x 0;x 1;"\n" sv 2_x);
 }


/ `.d.conText upsert / not sure what to add here


.d.e0[`text]:{[x]
 if[.d.isSummary;:()];
 result:{.bt.print[r 0] get last {2#x,enlist"()!()"}r:"||" vs x }@'x;
 1 result:"\n"sv result;
 1"\n";
 }



system"l ",getenv[`BTSRC],"/qlib/os/os.q";
system"l ",getenv[`BTSRC],"/qlib/import/import.q";