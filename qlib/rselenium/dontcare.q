args:.Q.def[`name`port!("dontcare1.q";9081);].Q.opt .z.x

/ remove this line when using in production
/ dontcare1.q:localhost:9081::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 9081"; } @[hopen;`:localhost:9081;0];

\l qlib.q

.import.summary[]
.import.module`kxplatform 
.import.module`tidyq
.import.module`rselenium


(::)remDir:.rselenium.remoteDriver `remDir 

(::)conOpen:.rselenium.conOpen remDir
(::)conGetStatus:.rselenium.conGetStatus remDir
/ (::)conClose:.rselenium.conClose remDir

.rselenium.conNavigate[remDir]"http://google.de"
.rselenium.conNavigate[remDir]"http://google.com"

.rselenium.conGoBack remDir
.rselenium.conGoForward remDir
.rselenium.conGetCurrentUrl remDir
.rselenium.conRefresh remDir



// .rselenium

/
.kxplatform.summary[]



(::)allRunning:.kxplatform.getRunningInformation `local.1
(::)allDetails:.kxplatform.view.processdetails `local.1

(::)allTP:select from allDetails where template like "DS_TP"

(::)x:`local.1

.kxplatform.getTP:{[x]
 allTP:.kxplatform.view.processdetails x;
 allTP:1!select uid:.Q.dd[x]@'name,name,containers,package,parameters from allTP where template like "DS_TP";
 allTPParams:raze exec uid{[uid;parameters] `uid`parameter`pvalue`description`ptype#update uid:uid from parameters }'parameters from allTP;
 .tidyq.dcast[select uid,parameter,pvalue from allTPParams;"uid";"parameter_%parameter% ~~ pvalue "]
 }

.kxplatform.getTP x

select by template from .kxplatform.view.processdetails x


select from allTPParams where parameter in `EOIOffset`bufferEnabled`bufferFunct`bufferLimit`consumerAlertSize`consumerDisconnectSize`dc_additionalFiles`dc_host`dc_ispermissioned`dc_port`dc_reusePort`dc_schemagroups`dc_schemas`dc_taskset`dsLsInstance`eodTime`includeColumns`initialStateFunct`intradayFreq`intradayTables`logDirectory`logRecoveryFunct`logUpdError`messagingServer`multiPublish`pubFreq`publishChannel`retryInterval`subscriptionChannel`subscriptionTableList`timeOffset`timeType 6







select from allTPParams where uid = `local.1.ds_tp_ops_a


select from allProcs where template like "DS_TP"

`ds_tp_alert_a

(::)allProcs:.kxplatform.getAllProcs `local.1

.remote.add allProcs
.remote.summary[]
.remote.sbl[]



(::).f.proc:`local.1.ds_rdb_alert_a.1

f) .z.X