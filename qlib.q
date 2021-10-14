
if[ () ~ key `.env.arg;
 .env.arg:`folder`cfg`subsys`process`id`trace!(`$getenv[`BTSRC],"/plant";`qlib;`qlib;`qlib;0j;0j);
 system"l ",getenv[`BTSRC],"/env.q";
 ]

if[ not `bt in  key `;
 system"l ",getenv[`BTSRC],"/bt.q";
 ]


if[ not `d in key `;system"l ",getenv[`BTSRC],"/qlib/qlib.q" ];