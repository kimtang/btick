.bt.add[`.library.init;`.setPort.init]{[allData] .bt.md[`port] get .bt.print[$[10h=type allData`setPort;::;string]allData`setPort ] allData }

.bt.add[`.setPort.init;`.setPort.setPort]{[allData]
 .bt.stdOut0[`info;`setPort] .bt.print["Setting port to %port%"] allData;
 system .bt.print["p %port%"] allData 
 }

.bt.addCatch[`.setPort.setPort]{[allData]
 .bt.stdOut0[`error;`setPort] .bt.print["Cannot set port to %port% due to error %error%"] allData; 
 } 