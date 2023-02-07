
\l qlib.q

.import.module`action`behaviour;
.behaviour.module`action;

if[ () ~ key `.env.arg; .env.arg: .action.parseArg .z.x; ];

.bt.action[`.action.init] .env.arg;