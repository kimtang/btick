
.test.t:flip`time`nsp`msg`result!()



.test.add:{[nsp;msg;result] `.test.t insert r:(.z.p;nsp;msg;result); .bt.stdOut0[`test;nsp] .bt.print["%0| %2 |%3"] r}

.test.sleep0:()!()
.test.sleep0[1b]:{system .bt.print["timeout %0 /nobreak"] enlist x; }
.test.sleep0[0b]:{system .bt.print["sleep %0"] enlist x; }

.test.sleep:{[secs] .test.sleep0[.env.win] secs }