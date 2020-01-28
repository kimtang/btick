# Btick

Btick is another kdb+ tick system. It incorporates as many best practices as possible with focus on extensibility, maintainability, performance, process management and diagnostic information. This platform will be suitable for those people looking to create a new kdb+ system. 

Btick is implemented very modular so it is very easy to be extended and modified as required. Also it uses a programming design pattern called 'behavioral design patterns' to unified the implementation. See https://github.com/kimtang/behaviourTag.

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

