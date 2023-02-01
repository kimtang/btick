d) module
 rselenium
 rselenium provides connections selenium from r
 q).import.module`rselenium

.import.require`rlang;
.import.require`remote;

.rselenium.config: (``remoteDriver)!enlist[::;] `browserName`port`remoteServerAddr!("chrome";4444f;"localhost")

.rselenium.init:{[x]
 if[`rselenium in key .import.config;.rselenium.config:(.bt.md[`]{}), .util.deepMerge[.rselenium.config] .import.config`rselenium ];
 update port:"j"$port from `.rselenium.config.remoteDriver;
 "r" "library(RSelenium)";
 "r" "library(rvest)";
 "r" "library(tidyverse)";
 netstat: `proto`local`address`foreign`port xcol ("ssssJ";"  ")0: {1_ssr[;"  ";" "]/[x]}@'3_ .remote.qthrow[`self] .s.q "netstat -ano";
 if[0<count select from netstat where local like ("*:",string .rselenium.config.remoteDriver.port);:() ];
 server:key .Q.dd[;`bin] folder:first ` vs first exec file from .import.module0 where module=`rselenium;
 server:server where server like "*server*";
 sfolder:ssr[;"/";"\\"] ssr[;"./";""]1_ string folder;
 cmd:.bt.print["start \"rselenium-server\" /d %folder%\\bin java -jar %server%"] `server`folder!(server;sfolder);
 system cmd;
 }


.rselenium.summary:{[x]
 if[max x~/:(::;`);:0!.rselenium.con];
 0!select from .rselenium.con where uid = x
 }

 
d) function
 rselenium
 .rselenium.summary
 Function to give a summary of available connection
 q) .rselenium.summary[]  / show all available repository

.rselenium.remoteDriver:{[name]
 allVar:`$"r" "ls()";
 if[name in allVar;
   class:"r" .bt.print["class(%0)"]name;
   if[`RSelenium~`$class[ 0]`package;.rselenium.conClose name ];
   ];
 driver:"r" .bt.print["%name%<-remoteDriver(browserName = \"%browserName%\")"] (.bt.md[`name]name),.rselenium.config`remoteDriver;
 name
 }

d) function
 rselenium
 .rselenium.remoteDriver
 Create remote driver
 q) remDir:.rselenium.remoteDriver `remDir 
 

.rselenium.conClose:{[x] "r" .bt.print["%name%$close()"] (.bt.md[`name]x)}

d) function
 rselenium
 .rselenium.conClose
 Close a connection
 q) .rselenium.conClose[]  / show all available repository


.rselenium.conOpen:{[x] {(`$x`names)!y } .  "r" .bt.print["%name%$open()"] .bt.md[`name]x }

d) function
 rselenium
 .rselenium.conOpen
 Close a connection
 q) .rselenium.conOpen[]  / show all available repository


.rselenium.conGetStatus:{[x] "r" .bt.print["%name%$getStatus()"] .bt.md[`name]x }

d) function
 rselenium
 .rselenium.conGetStatus
 Close a connection
 q) .rselenium.conGetStatus[]  / show all available repository

.rselenium.conNavigate:{[x;url] "r" .bt.print["%name%$navigate('%url%')"] `name`url!(x;url)}

d) function
 rselenium
 .rselenium.conNavigate
 navigate to a page
 q) .rselenium.conNavigate[remDir]"http://google.de"


.rselenium.conGetCurrentUrl:{[x]first "r" .bt.print["%name%$getCurrentUrl()"] .bt.md[`name]x}

d) function
 rselenium
 .rselenium.conGetCurrentUrl
 navigate to a page
 q) .rselenium.conGetCurrentUrl remDir

.rselenium.conGoForward:{[x]"r" .bt.print["%name%$goForward()"] .bt.md[`name]x}

d) function
 rselenium
 .rselenium.conGoForward
 navigate to a page
 q) .rselenium.conGoForward remDir

.rselenium.conGoBack:{[x]"r" .bt.print["%name%$goBack()"] .bt.md[`name]x}

d) function
 rselenium
 .rselenium.conGoBack
 navigate to a page
 q) .rselenium.conGoBack remDir

.rselenium.conRefresh:{[x]"r" .bt.print["%name%$refresh()"] .bt.md[`name]x}

d) function
 rselenium
 .rselenium.conRefresh
 navigate to a page
 q) .rselenium.conRefresh remDir


.rselenium.toTbl:{[t]
 a:t 0;
 cls:`$a`names;
 cnt:neg last a`row.names;
 mat:t 1;
 mat:@[;where not cnt = count@'mat;{[x;y]y#enlist x};cnt]mat;
 flip cls ! mat
 }

.rselenium.nodes_text:{[remDir;selector]
 "r" .bt.print["%remDir%$getPageSource()[[1]] %pipe% read_html() %pipe% html_nodes('%selector%') %pipe% html_text"] `remDir`selector`pipe!(remDir;selector;"%>%")
 }

d) function
 rselenium
 .rselenium.nodes_text
 select all nodes from a page and return as text
 q) .rselenium.nodes_text[ remDir] "#selectId > option"


.rselenium.node_text:{[remDir;selector]
 "r" .bt.print["%remDir%$getPageSource()[[1]] %pipe% read_html() %pipe% html_node('%selector%') %pipe% html_text"] `remDir`selector`pipe!(remDir;selector;"%>%")
 } 

d) function
 rselenium
 .rselenium.node_text
 select the first node and return as text
 q) .rselenium.node_text[remDir] ""


.rselenium.node_table:{[remDir;selector]
 .rselenium.toTbl "r" .bt.print["%remDir%$getPageSource()[[1]] %pipe% read_html() %pipe% html_node('%selector%') %pipe% html_table(fill=TRUE)"] `remDir`selector`pipe!(remDir;selector;"%>%")
 }

d) function
 rselenium
 .rselenium.node_table
 select a table
 q) .rselenium.node_table[remDir] "#innerContent > div.localResults.commContent > div.f_clear.top_races > table"

.rselenium.getTitle:{[x]first "r" .bt.print["%name%$getTitle()"] .bt.md[`name]x}

d) function
 rselenium
 .rselenium.getTitle
 navigate to a page
 q) .rselenium.getTitle remDir


.rselenium.wetest:{[name;maxTry;sec;selector]
 wetest:{[name;selector] not "b"$ first "r" .bt.print["tryCatch({%name%$findElement(using = 'css', \"%selector%\")},error = function(e){NULL}) %pipe% is.null "] `name`selector`pipe!(name;selector;"%>%") };
 while[maxTry-:1;
  if[wetest[name]selector;:1b];
  .util.sleep sec;
 ];
 :0b
 }

d) function
 rselenium
 .rselenium.wetest
 test for element
 q) .rselenium.wetest[remDir;3;"#selectId > option"]
 q) if[not .rselenium.wetest[remDir;3;"#selectId > option"];'`.rselenium.not_ready];


.rselenium.sendKeysToElement:{[remDr;selector;text]
 "r" .bt.print[".rselenium.inputTmp <- %remDr%$findElement(using = 'css', value = '%selector%')"] arg:`remDr`selector`text!(remDr;selector;text);
 "r" .bt.print[".rselenium.inputTmp$sendKeysToElement(list(\"%text%\"))"] arg;
 remDr
 }

d) function
 rselenium
 .rselenium.sendKeysToElement
 sendKeysToElement
 q) .rselenium.sendKeysToElement[remDr;"#ui-id-1 > div:nth-child(2) > span:nth-child(2) > input";"Administrator"]
 q) .rselenium.sendKeysToElement[remDr;"#ui-id-1 > div:nth-child(3) > span:nth-child(2) > input";"password"]


.rselenium.clickElement:{[remDr;selector]
 "r" .bt.print[".rselenium.inputTmp <- %remDr%$findElement(using = 'css', value = '%selector%')"] arg:`remDr`selector!(remDr;selector);
 "r" .bt.print[".rselenium.inputTmp$clickElement()"] arg; 
 remDr
 }


d) function
 rselenium
 .rselenium.clickElement
 clickElement
 q) .rselenium.clickElement[remDr] "body > div.ui-dialog.ui-widget.ui-widget-content.ui-corner-all.ui-front.quick-base.login-dialog.ui-dialog-buttons > div.ui-dialog-buttonpane.ui-widget-content.ui-helper-clearfix > div > button > span"




.rselenium.init[] 

/


remDir<-remoteDriver(browserName = "chrome")