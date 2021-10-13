/ placeholder for this qlib 

.d.conFunc:2!flip`module`func`desc`example`body!()
.d.conMod:1!flip`module`desc`example!()

.d.isSummary:0b

.d.e:{
 .d.e0[`$first a] 1_a:"\n" vs x 
 }

.d.e0:()!()
.d.e0[`function]:{[x]
 `.d.conFunc upsert enlist `module`func`desc`example`body!(`$x 0;`$x 1;x 2;"\n"sv 3_x ; @[get;`$x 1;{`notavail}] );
 }

.d.e0[`variable]:{[x]
 `.d.conFunc upsert enlist `module`func`desc`example`body!(`$x 0;`$x 1;x 2;"\n"sv 3_x ; `notavail );
 } 

.d.e0[`module]:{[x]
 `.d.conMod upsert enlist `module`desc`example!(`$x 0;x 1;"\n" sv 2_x);
 }


/ `.d.conText upsert / not sure what to add here


.d.e0[`text]:{[x]
 if[.d.isSummary;:()];
 result:{.bt.print[r 0] get last {2#x,enlist"()!()"}r:"||" vs x }@'x;
 1 result:"\n"sv result;
 1"\n";
 result
 }



system"l ",getenv[`BTSRC],"/qlib/import/import.q";
system"l ",getenv[`BTSRC],"/qlib/os/os.q";