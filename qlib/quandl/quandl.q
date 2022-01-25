d) module
 quandl
 Library to query quandl data
 q).import.module`quandl

.quandl.hp:"https://docs.data.nasdaq.com/docs/getting-started"

.quandl.db:`:quandlDB

.bt.addIff[`.quandl.addDb]{`quandl in key .import.config}
.bt.add[`.import.ljson;`.quandl.addDb]{ .quandl.db:hsym `$.import.config . `quandl`db;}

.bt.action[`.quandl.addDb] ()!();

.quandl.hkex_meta:{
 ("s**p";", ")0: .Q.dd[.quandl.db]`HKEX_metadata.csv
 }

d) function
 todo
 .quandl.hkex_meta
 Function to get meta data from HKEX
 q).quandl.hkex_meta[]

/


result:system .bt.print["curl -v \"%query%\" "] .bt.md[`query]"https://data.nasdaq.com/api/v3/datasets/HKEX/40819?api_key=An8MEygdAp3CzAv2GjPt"

(:)result:.j.k "\n"sv result

result`dataset







