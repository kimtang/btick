args:.Q.def[`name`port!("test_import.q";9056);].Q.opt .z.x

/ remove this line when using in production
/ test_import.q:localhost:9056::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 9056"; } @[hopen;`:localhost:9056;0];
\l qlib.q

.import.module`qtest;

.qtest.suit"test import load json";

.qtest.should["Should load json"]{
 .qtest.mustmatch[`globalJson`var1`var2`var3`var4] asc key .import.config;
 };

.import.repository enlist`name`path!(`test_import;".");

.qtest.should["Should import module"]{
 .qtest.musttrue `test_import in exec name from .import.repositories;
 .import.module`test1;
 .qtest.mustfalse () ~ key`.test1;
 .qtest.musteq[1j] .test1.a;
 };


.qtest.outputShort[]; 