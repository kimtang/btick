\l qlib.q

.import.module`qtest;

curve:{[syms;start;end];
  v:select vol: sum size by sym, date, time.minute from trade where date within `date$(start;end), sym in syms, time within `time$(start;end);
  tv: exec sum vol by sym from v;
  numDates:exec count distinct date from v;
  `sym`minute xasc select avgBucket: sum[vol]%numDates, pctDaily:sum[vol]%tv[first sym] by sym,minute from v
  }

gen:{[syms;prices;nums;start;days];
  raze (enlist each flip `sym`date!flip syms cross start + til days) cross' {[num;price]
    invAbs:{(count[x]?1 -1)*x};
    n:`int$num + first invAbs 1?(1?1f)*num; / Adjust num to generate within 0-100% of base num up or down
    freqs:0f, sums .8 .1 .05 .01 .01 .01 .016 .001 .001 .001;
    sizes:100 200 300 400 500 1000 10000 20000 30000 40000 50000;
    ([]time:asc 09:30t + n?16t - 09:30t;price:price + invAbs n?first 1?.1;size:sizes freqs bin n?1f)
    } .' raze days#'enlist each nums,'prices
  }

.qtest.suit"Volume curves"

/ .qtest.data.set `trade set gen[`IBM`MSFT`AAPL;100 30 200f;1000 2000 10000;2009.11.01;30]



.qtest.should["have percentage values that add to 1"]{
  .qtest.data.get `trade;
  c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
  .qtest.musteq[1 1f]value exec first sum pctDaily by sym from c;
  c:curve[`IBM`MSFT;2009.11.01T12:00;2009.11.15T15:00];
  .qtest.musteq[1 1f]value exec first sum pctDaily by sym from c;
  }


.qtest.should["have the sum of average bucket volumes be equal to the average daily volume"]{
  .qtest.data.set `trade;
  `adv set exec avg vol by sym from select vol:sum size by sym, date from trade where date within 2009.11.01 2009.11.30,time within 09:30 16:00;  
  c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
  .qtest.musteq[adv`MSFT`IBM](exec first sum avgBucket by sym from c)`MSFT`IBM;
  }


.qtest.should["have the percentage of daily volume match the average bucket column divided by ADV"]{
      c:curve[`IBM`MSFT;2009.11.01T09:30;2009.11.30T16:00];
      .qtest.mustmatch[ pd[key pd;]](exec avgBucket%adv[first sym] by sym from c)[key pd:exec pctDaily by sym from c] ;
      };


.qtest.outputShort[];