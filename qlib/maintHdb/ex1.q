
args:.Q.def[`name`port!("ex1.q";8912);].Q.opt .z.x

/ remove this line when using in production
/ ex1.q:localhost:8912::
{ if[not x=0; @[x;"\\\\";()]]; value"\\p 8912"; } @[hopen;`:localhost:8912;0];

\l qlib.q
r) library(ggplot2)

.import.summary[]

.import.module`maintHdb

.maintHdb.summary `:segDB/db
.maintHdb.summary `:tmpDB

.maintHdb.deepSummary x:`:segDB/db
.maintHdb.deepSummary x:`:tmpDB


(:)x:-8!til 1000

.serialization.read -8! "f"$ til 100
.serialization.read -8!(1;2f)

.serialization.read `:segDB/db/../0/2021.08.14/T/w
.serialization.read 

.serialization.read read1(`:tmpDB/sym;14;14)

-8!get `:tmpDB/sym
0x01000000380000000b0015000000
0x010b000000000061006200630064
read1(`:tmpDB/sym;1;15)

([] -8!get `:tmpDB/sym)

([] read1`:tmpDB/sym)
            0xff 01 0b 00 00 00 00 00 6100620063006400650066006700680069006a006b006c006d006e006f0070007100780079007a007700
0x01 00 00 00 38 00 00 00 0b 00 15 00 00 00 6100620063006400650066006700680069006a006b006c006d006e006f0070007100780079007a007700
([]lst)

lst 0 / architecture

lst 1 2 3 / message type

lst 4 5 6 7 /message length

lst 8 /type

lst 9 / attributes

lst 10 11 12 13 / vector length

(256 xexp 0 1 2 3) wsum "j"$lst 10 11 12 13 / vector length




