.import.module `$"proto/unparse.q";

d) module
 proto
 proto provides a set of functions to implement edsl in kdb+\q
 q).import.module`proto


\d .proto

operator0:1!update tipe:type@'e,fnc:e from update e:(first first parse@)@'e from flip`e`nme!flip 2 cut ("a!b";`ExclamationMark;"a#b";`Number;"a$b";`Dollar;"a%b";`Procenttecken;"a&b";`Ampersand;"a+'b";`SingleQuote;"a*b";`Multiply;"a+b";`Plus;"a,b";`Comma;"a-b";`Hyphen;"a . b";`Dot;"a+/b";`Slash;"a:b";`Colon;"a<b";`LessThan;"a=b";`Equals;"a>b";`GreaterThan;"a?b";`QuestionMark;"a@b";`At;"a^b";`Caret;"a _ b";`Underscore;"a|b";`VerticalBar;"a~b";`Tilde;"a+/:b";`EachRight;"a+\\:b";`EachLeft;"a+':b";`EachPrior;"a::b";`GenericNull;"enlist a";`Enlist;"flip a";`Flip)

`.proto.operator0 insert (`Return;`Return;-11h;::);

atom0:1!update fnc:(::) from{`num xasc x,update num:abs num,tipe:`${(upper x[0]),1_x}@'string tipe from x} {select from x where not null tipe} update tipe:{ @[{ key x$() };x;`] }each "h"$abs num from ([]num:neg til 20)


untree:{{update ind:i,p:(ind!i) p from raze {if[1=count x`e;:enlist x];if[100h>type first x`e;:enlist x]; update p:(p[0],1 _ ind) from ungroup enlist x} @'x}/[([]ind:til count x;p:0;e:x)]}

tree:{{select ind:ind[;0],p:p[;0],e:{$[1=count x;first x;x]}@'e from`g xgroup update g:@[ind;where p=max p;:;max p]from x}/[x] . 0,`e}

addg:{[u] update g:@[ind;where p=max p;:;max p]from u}
adata:{[u;data] 1_update e:data e from (enlist`ind`p`e`g!(-1;-1;::;-1)),addg u where not prev(:)~'e,g = max g,{$[x;y;z]}'[-11h=type@'e;e;`]in\:key data }
adefine:{[k;f;op] ((enlist k)!enlist f),op}

atom:{[u;a]a:{x["j"$type y;`fnc] y} atom0 lj ([tipe:key a]fnc:value a);
 update e:a@'e from u where g = max g,100h>type@'e
 }

odefine:{[k;f;op] ((enlist k)!enlist f),op}

operator:{[u;o]
 o:{if[not y in (0!.proto.operator0)`e;:y ] ;x[y;`fnc]} operator0 lj ([nme:key o]fnc:value o);
 update e:o@'e from u where g = max g,99h<type@'e
 }

udata:{[o;data;e;r]o:(`nme xkey operator0 lj([nme:key o]fnc:value o)) ;if[not o[`Colon;`fnc]~e 0;:data];data[e 1]:r;data}
eval0:{[e]if[1=count e;:first e];0 e}

s:{[a;o;x]data:x`data;u:x`u;
 u0:adata[u]data;
 u1:atom[u0;a];
 u2:operator[u1;o];
 e:(`g xgroup u2)[p0:max u2`p;`e];
 r:eval0 e;
 data:udata[o;data;e;r];
 u:update ind:ind[;0],p:p[;0],e:e[;0] from `g xgroup u2;
 u:delete g from update e:enlist r from u where g = p0;
 `u`data!(u;data)}

getb:{exn:-1 _ 1 _ last f:get x;exn:$["["~exn 0;(1+first where "]"=exn) _ exn;exn]; `arg`exn!(f 1;exn)}

proto_:{[a;o;exn;data]
 exn:untree@'$[";"~first exn ;1 _;enlist[(+;0;1);]] exn:parse exn;
 exn:{update e:first each e from x where ((0h=type@'e) and (1={@[count;x;0]}@'e) and (11h=abs {type first x}@'e)) or (11h=type@'e) and 1=count@'e } @'exn;
 l:enlist[data] , -1_exn;
 data:{[a;o;x;y] s[a;o]/[`data`u!(x;y)] `data}[a;o]/[l];
 res:s[a;o]/[`u`data!(last exn;data )] [`u;0;`e];
 o:{x[y;`fnc]} .proto.operator0 lj ([nme:key o]fnc:value o);
 o[`Return] res
 }

proto0:()!()
proto0[1]:{[d;x0]data:((::),d[`arg])!(::;x0);proto_[d`a;d`o;d`exn;data]}
proto0[2]:{[d;x0;x1]data:((::),d[`arg])!(::;x0;x1);proto_[d`a;d`o;d`exn;data]}
proto0[3]:{[d;x0;x1;x2]data:((::),d[`arg])!(::;x0;x1;x2);proto_[d`a;d`o;d`exn;data]}
proto0[4]:{[d;x0;x1;x2;x3]data:((::),d[`arg])!(::;x0;x1;x2;x3);proto_[d`a;d`o;d`exn;data]}
proto0[5]:{[d;x0;x1;x2;x3;x4]data:((::),d[`arg])!(::;x0;x1;x2;x3;x4);proto_[d`a;d`o;d`exn;data]}
proto0[6]:{[d;x0;x1;x2;x3;x4;x5]data:((::),d[`arg])!(::;x0;x1;x2;x3;x4;x5);proto_[d`a;d`o;d`exn;data]}
proto0[7]:{[d;x0;x1;x2;x3;x4;x5;x6]data:((::),d[`arg])!(::;x0;x1;x2;x3;x4;x5;x6);proto_[d`a;d`o;d`exn;data]}

proto:{[a;o;f]d:getb[f],`a`o!(a;o);proto0[count d`arg][d]  }
prote:{[a;o;exn]d:`arg`exn`a`o!(1#`x;exn;a;o);proto0[count d`arg][d]  }


\d .

d) function
 proto
 .proto.proto
 q){@[`.;key x;:;value x]} .proto
 q)"big numbers"
 q)cns:{(til count r)!"J"$'r:reverse string x}
 q)pnum:{(x+key y)!value y}
 q)norm:{{sum pnum'[key x;cns@'value x]}/[x]}
 q)plus:{norm x + y}
 q)multiply:{ norm sum {(enlist sum x) ! enlist prd y}'[key r;value r:x cross y] }
 q)return:{r:raze string 0^x(reverse til 1+max key x);e:@[parse;r;r];if[10h~type e;:e];$[e<0wj;e;r] }
 q)(::)a:adefine[`float;cns] adefine[`long;cns]()!()
 q)(::)o:odefine[`Return;return] odefine[`Plus;plus] odefine[`Multiply;multiply]()!()
 q)p:proto[a;o]
 q)p[{1+2*x}][1]
 q)p[{b:a+x*2 + a:3*y;z+b+1}] . 1 7 8
 q)p[{[a;b;c;d]b:c*a+a*2 + a:3*b;d+b+1}][1;2;3;4]
 q)p[{2*1+x+y}][0wj - 1;0]
 q)"Logger"
 q)(::)o:odefine[`Colon;{[x;y]show .Q.s1 (x;y);y}]()!()
 q)(::)r:proto[()!();o;{b:3+a:1+x;1+b}][1]











