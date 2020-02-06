# Btick

Btick is another kdb+ tick system. It incorporates as many best practices as possible with focus on extensibility, maintainability, performance, process management and diagnostic information. This platform will be suitable for those people looking to create a new kdb+ system. 

Btick is implemented very modular so it is very easy to be extended and modified as required. Also it uses a programming design pattern called 'behavioral design patterns' to unify the implementation. See https://github.com/kimtang/behaviourTag.

The features of btick will include but not limited by:

* Multiple tickerplants and multiple rdb approach:
  Rdb can subscribe to multiple tickerplants.
* Intraday-EOD-Writedown:
  Tickerplant will truncate the logfile every 30 minutes such that these logfiles can be used for intraday writedown.
* Non-Rdb-EOD-Writedown:
  Rdb is not used for eod writedown but another process
* Bus-Grid-Communication:
  All processes are connected via a communication grid.
* Backfill subsystem:
  A backfill subsystem is automatically created for user to backfill data
* Admin subsystem:
  An admin subsystem is automatically created to collect health data
* Test:
  Admin and backfill tests are available

## Demo and Instatllation

```
Microsoft Windows [Version 10.0.18362.592]                                                                           
                                                                                                                     
kuent@LAPTOP-4DM6GURS C:\Users\kuent                                                                                 
> cd C:\q                                                                                                            
                                                                                                                     
kuent@LAPTOP-4DM6GURS C:\q                                                                                           
> git clone https://github.com/kimtang/btick.git                                                                     
Cloning into 'btick'...                                                                                              
remote: Enumerating objects: 100, done.                                                                              
remote: Counting objects: 100% (100/100), done.                                                                      
remote: Compressing objects: 100% (70/70), done.                                                                     
Receiving objects:  91% (91/100)eused 97 (delta 10), pack-reused 0                                                   
Receiving objects: 100% (100/100), 46.53 KiB | 196.00 KiB/s, done.                                                   
Resolving deltas: 100% (10/10), done.                                                                                
                                                                                                                     
kuent@LAPTOP-4DM6GURS C:\q
> mklink pm.q btick\pm.q
symbolic link created for pm.q <<===>> btick\pm.q

kuent@LAPTOP-4DM6GURS C:\q
> mklink createsystem.q btick\createsystem.q
symbolic link created for createsystem.q <<===>> btick\createsystem.q

kuent@LAPTOP-4DM6GURS C:\q
> set BTSRC=C:\q\btick

kuent@LAPTOP-4DM6GURS C:\q
> set BTSRC
BTSRC=C:\q\btick

kuent@LAPTOP-4DM6GURS C:\q
> mkdir tmp

kuent@LAPTOP-4DM6GURS C:\q
> cd tmp

kuent@LAPTOP-4DM6GURS C:\q\tmp
> q createsystem.q
KDB+ 3.6 2019.04.02 Copyright (C) 1993-2019 Kx Systems
w32/ 16()core 4095MB kuent laptop-4dm6gurs 192.168.56.1 NONEXPIRE

Welcome!!!
We will create a kdb+ system based on btick for you.

What is your kdb+ system called?:
demo
Now you need to tell me the different subsystems
What is your 1 subsystem?(Blank for skipping)
businessApp
What is your 2 subsystem?(Blank for skipping)

Now you need to setup the baseport for different subsystems
What is the baseport of your admin subsystem?
21000
What is the baseport of your backfill subsystem?
22000
What is the baseport of your businessApp subsystem?
30000
Now we will create the json file
Now we will create example json schema file
Everything created. We will exit now

kuent@LAPTOP-4DM6GURS C:\q\tmp
> q pm.q
KDB+ 3.6 2019.04.02 Copyright (C) 1993-2019 Kx Systems
w32/ 16()core 4095MB kuent laptop-4dm6gurs 192.168.56.1 NONEXPIRE

The folder plant contains 1 plant(s).
Use the following commands to inspect the processes.
q pm.q -folder plant -env demo status all

kuent@LAPTOP-4DM6GURS C:\q\tmp
> q pm.q -folder plant -env demo status all
KDB+ 3.6 2019.04.02 Copyright (C) 1993-2019 Kx Systems
w32/ 16()core 4095MB kuent laptop-4dm6gurs 192.168.56.1 NONEXPIRE

subsys      proc         port  pid pm2
-----------------------------------------------------------------------------------------------------------
businessApp bus.0        30001     "q pm.q -folder plant -env demo -subsys businessApp status bus.0"
businessApp cdb.0        30005     "q pm.q -folder plant -env demo -subsys businessApp status cdb.0"
businessApp ctp.0        30007     "q pm.q -folder plant -env demo -subsys businessApp status ctp.0"
businessApp dynamicHdb.0 30020     "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.0"
businessApp dynamicHdb.1 30021     "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.1"
businessApp dynamicHdb.2 30022     "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.2"
businessApp dynamicHdb.3 30023     "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.3"
businessApp gateway.0    30006     "q pm.q -folder plant -env demo -subsys businessApp status gateway.0"
businessApp rdb.0        30004     "q pm.q -folder plant -env demo -subsys businessApp status rdb.0"
businessApp replay.0     30003     "q pm.q -folder plant -env demo -subsys businessApp status replay.0"
businessApp tick.0       30002     "q pm.q -folder plant -env demo -subsys businessApp status tick.0"
admin       bus.0        21002     "q pm.q -folder plant -env demo -subsys admin status bus.0"
admin       cdb.0        21006     "q pm.q -folder plant -env demo -subsys admin status cdb.0"
admin       pm2.0        21001     "q pm.q -folder plant -env demo -subsys admin status pm2.0"
admin       rdb.0        21005     "q pm.q -folder plant -env demo -subsys admin status rdb.0"
admin       replay.0     21004     "q pm.q -folder plant -env demo -subsys admin status replay.0"
admin       tick.0       21003     "q pm.q -folder plant -env demo -subsys admin status tick.0"
backfill    bus.0        22001     "q pm.q -folder plant -env demo -subsys backfill status bus.0"
backfill    rdb.0        22002     "q pm.q -folder plant -env demo -subsys backfill status rdb.0"
backfill    replay.0     22004     "q pm.q -folder plant -env demo -subsys backfill status replay.0"
backfill    tick.0       22003     "q pm.q -folder plant -env demo -subsys backfill status tick.0"

kuent@LAPTOP-4DM6GURS C:\q\tmp
> q pm.q -folder plant -env demo start all
KDB+ 3.6 2019.04.02 Copyright (C) 1993-2019 Kx Systems
w32/ 16()core 4095MB kuent laptop-4dm6gurs 192.168.56.1 NONEXPIRE

subsys      proc         port  pid   pm2
-------------------------------------------------------------------------------------------------------------
businessApp bus.0        30001 22024 "q pm.q -folder plant -env demo -subsys businessApp status bus.0"
businessApp cdb.0        30005 20416 "q pm.q -folder plant -env demo -subsys businessApp status cdb.0"
businessApp ctp.0        30007 6808  "q pm.q -folder plant -env demo -subsys businessApp status ctp.0"
businessApp dynamicHdb.0 30020 21216 "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.0"
businessApp dynamicHdb.1 30021 8900  "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.1"
businessApp dynamicHdb.2 30022 17716 "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.2"
businessApp dynamicHdb.3 30023 3740  "q pm.q -folder plant -env demo -subsys businessApp status dynamicHdb.3"
businessApp gateway.0    30006 19588 "q pm.q -folder plant -env demo -subsys businessApp status gateway.0"
businessApp rdb.0        30004 8128  "q pm.q -folder plant -env demo -subsys businessApp status rdb.0"
businessApp replay.0     30003 18624 "q pm.q -folder plant -env demo -subsys businessApp status replay.0"
businessApp tick.0       30002 1192  "q pm.q -folder plant -env demo -subsys businessApp status tick.0"
admin       bus.0        21002 18692 "q pm.q -folder plant -env demo -subsys admin status bus.0"
admin       cdb.0        21006 15392 "q pm.q -folder plant -env demo -subsys admin status cdb.0"
admin       pm2.0        21001 720   "q pm.q -folder plant -env demo -subsys admin status pm2.0"
admin       rdb.0        21005 8244  "q pm.q -folder plant -env demo -subsys admin status rdb.0"
admin       replay.0     21004 18020 "q pm.q -folder plant -env demo -subsys admin status replay.0"
admin       tick.0       21003 22520 "q pm.q -folder plant -env demo -subsys admin status tick.0"
backfill    bus.0        22001 16804 "q pm.q -folder plant -env demo -subsys backfill status bus.0"
backfill    rdb.0        22002 12036 "q pm.q -folder plant -env demo -subsys backfill status rdb.0"
backfill    replay.0     22004 20176 "q pm.q -folder plant -env demo -subsys backfill status replay.0"
backfill    tick.0       22003 22068 "q pm.q -folder plant -env demo -subsys backfill status tick.0"

kuent@LAPTOP-4DM6GURS C:\q\tmp
> qcon :21005

:21005>.proc
folder   | `plant
env      | `demo
subsys   | `admin
process  | `rdb
library  | `randomSeed`setPort`hopen`bus.client`tick.sub`heartbeat.client`err..
arg      | (,`setPort)!,"%basePort% + 5"
global   | `audit`data`host`instance`basePort!("audit";"data";"localhost";1f;..
local    | (`symbol$())!()
instance | 1
id       | 0
mergeArg | `audit`basePort`data`host`instance`setPort!("audit";21000f;"data";..
host     | "localhost"
port     | 21005
proc     | `rdb.0
uid      | `plant.demo.admin.rdb.0
hdb      | "data/plant/demo/admin/hdb"
audit    | "audit/plant/demo/admin/rdb/0"
gData    | "data/plant/demo/admin/rdb"
data     | "data/plant/demo/admin/rdb/0"
gfile    | "plant/demo/admin/rdb/global"
lfile    | "plant/demo/admin/rdb/0"
gcorefile| "C:\\q\\btick\\core\\core\\admin\\rdb\\global"
..

:21005>.proc.uid
`plant.demo.admin.rdb.0

:21005>tables[]
`s#`afterExecution`beforeExecution`error`heartbeat

:21005>heartbeat
date       time                          uid                                 ..
-----------------------------------------------------------------------------..
2020.01.28 2020.01.28D08:13:45.079497000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:46.280488000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:47.480145000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:48.680124000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:49.879703000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:51.080128000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:52.280306000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:53.479953000 plant.demo.admin.tick.0             ..
2020.01.28 2020.01.28D08:13:54.186655000 plant.demo.businessApp.bus.0        ..
2020.01.28 2020.01.28D08:13:54.215221000 plant.demo.businessApp.cdb.0        ..
2020.01.28 2020.01.28D08:13:54.244449000 plant.demo.businessApp.ctp.0        ..
2020.01.28 2020.01.28D08:13:54.280863000 plant.demo.businessApp.dynamicHdb.0 ..
2020.01.28 2020.01.28D08:13:54.317445000 plant.demo.businessApp.dynamicHdb.1 ..
2020.01.28 2020.01.28D08:13:54.347282000 plant.demo.businessApp.dynamicHdb.2 ..
2020.01.28 2020.01.28D08:13:54.375956000 plant.demo.businessApp.dynamicHdb.3 ..
2020.01.28 2020.01.28D08:13:54.397100000 plant.demo.businessApp.gateway.0    ..
2020.01.28 2020.01.28D08:13:54.436757000 plant.demo.businessApp.rdb.0        ..
2020.01.28 2020.01.28D08:13:54.468014000 plant.demo.businessApp.replay.0     ..
2020.01.28 2020.01.28D08:13:54.492007000 plant.demo.businessApp.tick.0       ..
2020.01.28 2020.01.28D08:13:54.523986000 plant.demo.admin.bus.0              ..
..
:21005>select count i by uid from heartbeat
uid                                | x
-----------------------------------| --
plant.demo.admin.bus.0             | 31
plant.demo.admin.cdb.0             | 31
plant.demo.admin.pm2.0             | 31
plant.demo.admin.rdb.0             | 31
plant.demo.admin.replay.0          | 31
plant.demo.admin.tick.0            | 39
plant.demo.backfill.bus.0          | 31
plant.demo.backfill.rdb.0          | 31
plant.demo.backfill.replay.0       | 31
plant.demo.backfill.tick.0         | 31
plant.demo.businessApp.bus.0       | 31
plant.demo.businessApp.cdb.0       | 31
plant.demo.businessApp.ctp.0       | 31
plant.demo.businessApp.dynamicHdb.0| 31
plant.demo.businessApp.dynamicHdb.1| 31
plant.demo.businessApp.dynamicHdb.2| 31
plant.demo.businessApp.dynamicHdb.3| 31
plant.demo.businessApp.gateway.0   | 31
plant.demo.businessApp.rdb.0       | 31
plant.demo.businessApp.replay.0    | 31
plant.demo.businessApp.tick.0      | 31
:21005>select by uid from heartbeat
uid                                | date       time                         ..
-----------------------------------| ----------------------------------------..
plant.demo.admin.bus.0             | 2020.01.28 2020.01.28D08:14:35.323891000..
plant.demo.admin.cdb.0             | 2020.01.28 2020.01.28D08:14:35.348731000..
plant.demo.admin.pm2.0             | 2020.01.28 2020.01.28D08:14:35.381726000..
plant.demo.admin.rdb.0             | 2020.01.28 2020.01.28D08:14:35.413051000..
plant.demo.admin.replay.0          | 2020.01.28 2020.01.28D08:14:35.447131000..
plant.demo.admin.tick.0            | 2020.01.28 2020.01.28D08:14:35.479725000..
plant.demo.backfill.bus.0          | 2020.01.28 2020.01.28D08:14:35.506420000..
plant.demo.backfill.rdb.0          | 2020.01.28 2020.01.28D08:14:35.533005000..
plant.demo.backfill.replay.0       | 2020.01.28 2020.01.28D08:14:35.554303000..
plant.demo.backfill.tick.0         | 2020.01.28 2020.01.28D08:14:35.577255000..
plant.demo.businessApp.bus.0       | 2020.01.28 2020.01.28D08:14:34.987013000..
plant.demo.businessApp.cdb.0       | 2020.01.28 2020.01.28D08:14:35.015211000..
plant.demo.businessApp.ctp.0       | 2020.01.28 2020.01.28D08:14:35.043628000..
plant.demo.businessApp.dynamicHdb.0| 2020.01.28 2020.01.28D08:14:35.080871000..
plant.demo.businessApp.dynamicHdb.1| 2020.01.28 2020.01.28D08:14:35.116806000..
plant.demo.businessApp.dynamicHdb.2| 2020.01.28 2020.01.28D08:14:35.147817000..
plant.demo.businessApp.dynamicHdb.3| 2020.01.28 2020.01.28D08:14:35.175947000..
plant.demo.businessApp.gateway.0   | 2020.01.28 2020.01.28D08:14:35.197924000..
plant.demo.businessApp.rdb.0       | 2020.01.28 2020.01.28D08:14:35.236465000..
plant.demo.businessApp.replay.0    | 2020.01.28 2020.01.28D08:14:35.268906000..
plant.demo.businessApp.tick.0      | 2020.01.28 2020.01.28D08:14:35.292434000..
:21005>


```