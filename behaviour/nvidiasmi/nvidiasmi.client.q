
.nvidiasmi.cmd:"nvidia-smi.exe --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv";

.nvidiasmi.loopTime:`second$5;

.bt.add[`.library.init;`.nvidiasmi.init]{}

.bt.addDelay[`.nvidiasmi.loop]{`tipe`time!(`in;.nvidiasmi.loopTime)}

.bt.add[`.nvidiasmi.init`.nvidiasmi.loop;`.nvidiasmi.loop]{
 r:`time`name`pci_bus_id`driver_version`pstate`pcie_link_gen_max`pcie_link_gen_current`temperature_gpu`utilization_gpu`utilization_memory`memory_total`memory_free`memory_used xcol ("PSN*SJJF*****";", ") 0: system .nvidiasmi.cmd;
 tbl:update "F"$-2_/:utilization_gpu,"F"$-2_/:utilization_memory,"F"$-4_/:memory_total,"F"$-4_/:memory_free,"F"$-4_/:memory_used from r;
 `topic`data!enlist[`.nvidiasmi.receiveNvidiasmi;] tbl
 }

.bt.addOnlyBehaviour[`.nvidiasmi.loop]`.bus.sendTweet