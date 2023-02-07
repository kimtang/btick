/ 
 q pm1.q -folder folder -cfg cfg_file -subsys subsys -trace 1 [status|start|kill|stop|restart|debug|sbl|json|info|heartbeat|tblcnt] proc[all]
 q pm1.q -folder plant  -cfg cfg_file -subsys subsys -trace 1 status proc[all]
 q pm1.q -folder plant  -cfg cfg_file -subsys subsys -trace 1 status proc[all] 
 q pm1.q -folder plant  -cfg cfg_file -subsys subsys -trace 1 status all  
 q pm1.q
\

\l qlib.q

\c 1000 1000

.import.module`util`action`behaviour`pm;
.behaviour.module`pm;

.bt.addCatch[`]{[error] .bt.stdOut0[`error;`pm] .bt.print["Please investigate the following error: %0"] enlist error;'error};
.bt.add[`.pm.os.status`.pm.os.start`.pm.os.kill`.pm.os.restart;`.pm.show]{[result]
  1 .Q.s update `$pm2 from `port xasc result
  };

.bt.addIff[`.pm.exit]{[debug] not debug};
.bt.add[`.pm.showFolder`.pm.show`.pm.os.sbl`.pm.os.sblh`.pm.os.json`.pm.os.no_cmd;`.pm.exit]{exit 0};

.bt.action[`.pm.init] .pm.parseArg .z.x;
