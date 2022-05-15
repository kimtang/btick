args:.Q.def[`name`port!("test_util.q";2301);].Q.opt .z.x

/ remove this line when using in production
/ test_util.q:localhost:2301::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 2301"; } @[hopen;`:localhost:2301;0];

\l qlib.q

.import.module`qtest;

.qtest.suit"test util";

.qtest.should["test .util.deepMerge"]{ 
  default:`a`b`c!(1;2;`a`b`c! (6 ; `a`b`c!5 6 7 ;8));
  arg:`b`c!(2;`a`b`c! (6 ; `b`c!6 7 ;18));
  .qtest.mustmatch[`a`b`c!(1j;2j;`a`c`b!(6j;18j;`a`b`c!5 6 7j))] .util.deepMerge[default]arg;
  };

.qtest.outputShort[];