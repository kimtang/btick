.bt.add[`.library.init;`.dynamicPort.init]{[allData] .bt.md[`port] .proc.id + get .bt.print[$[10h=type allData`dynamicPort;::;string]allData`dynamicPort ] allData }

.bt.add[`.dynamicPort.init;`.dynamicPort.dynamicPort]{[allData]
 .bt.stdOut0[`info;`dynamicPort] .bt.print["Setting port to %port%"] allData;
 system .bt.print["p %port%"] allData 
 }

.bt.addCatch[`.dynamicPort.dynamicPort]{[allData]
 .bt.stdOut0[`error;`dynamicPort] .bt.print["Cannot set port to %port% due to error %error%"] allData; 
 } 