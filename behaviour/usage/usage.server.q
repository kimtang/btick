

.bt.add[`.library.init;`.usage.init]{}

.bt.add[`;`.usage.receivePg.beforeExecution]{[data] upd[`beforeExecution;`uid`etime`guid`user`hdl`host`arg#data] }

.bt.add[`;`.usage.receivePg.afterExecution]{[data] upd[`afterExecution;`uid`ftime`guid`error#data] }

/ 

select from .bt.history where action like ".usage.receivePg*"

.z.pg