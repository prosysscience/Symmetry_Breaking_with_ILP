%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.
color(X-1) :- color(X), X > 1.


0{assign(P,H)}1:- pigeon(P), hole(H).
0{assignColor(P,C)}1:- pigeon(P), color(C).
:- assign(P,H1), assign(P,H2), H1 != H2.
:- assignColor(P,H1), assignColor(P,H2), H1 != H2.
:- pigeon(P), not assign(P,_).
:- pigeon(P), not assignColor(P,_).


next(X,X+1) :- hole(X), hole(X+1).
:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assignColor(P1,C1), assignColor(P2,C2), C1!=C2.
:- color(C), not assignColor(_,C).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeb(2,assign(var(pigeon),var(hole))).
#modeb(2,pigeon(var(pigeon))).
#modeb(2,hole(var(hole))).
#modeb(1,maxhole(var(hole))).
#modeb(1,maxpigeon(var(pigeon))).
#modeb(2,next(var(hole),var(hole)),(anti_reflexive)).
#modeb(2,lessthan(var(hole),var(hole)),(anti_reflexive)).
#modeb(2,lessthan(var(pigeon),var(pigeon)),(anti_reflexive)).
#modeb(2,lessthan(var(hole),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(hole))).
%%% Second Step

#max_penalty(30).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Examples and extra rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lessthan(X,Y) :- pigeon(X), pigeon(Y), X <Y.
lessthan(X,Y) :- hole(X), hole(Y), X <Y.
lessthan(X,Y) :- color(X), color(Y), X <Y.

maxhole(M) :- hole(M), not hole(M+1).
maxpigeon(P) :- pigeon(P), not pigeon(P+1).
maxcolor(C) :- color(C), not color(C+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mode bias (vars of type pigeon and hole)
% 1st call:
%   p=3 h=3 c=1 
%:- assign(V2,V3), lessthan(V1,V2), maxhole(V3). 
%:- assign(V3,V2), lessthan(V1,V2), maxpigeon(V3).
% Increase mode bias (vars of type color)
% 2nd call:
%   p=3 h=4 c=2 
%:- assignColor(V3,V1), lessthan(V1,V3), lessthan(V2,V1).
% 3rd call:
%   p=3 h=6 c=3 
%:- assignColor(V3,V2), lessthan(V1,V2), maxpigeon(V3).
% 4th call:
%   p=3 h=6 c=3
%:- assignColor(V1,V3), lessthan(V1,V3), lessthan(V2,V1).


#pos(id2_p3_h4_c1, {assign(2,2), assignColor(3,1), assignColor(2,1), assignColor(1,1), assign(1,3), assign(3,1)}, {}, {pigeon(3). hole(3). color(1).}).
#pos(id0def_p1_h1_c1,{},{},{pigeon(1). hole(1). color(1).}).
#pos(id0def_p3_h5_c3,{},{},{pigeon(3). hole(5). color(3).}).
#pos(id0def_p1_h2_c1,{},{},{pigeon(1). hole(2). color(1).}).
#pos(id0def_p2_h2_c1,{},{},{pigeon(2). hole(2). color(1).}).
#pos(id0def_p2_h3_c1,{},{},{pigeon(2). hole(3). color(1).}).
#pos(id0def_p2_h4_c1,{},{},{pigeon(2). hole(4). color(1).}).
#pos(id0def_p3_h4_c1,{},{},{pigeon(3). hole(4). color(1).}).
#pos(id0def_p3_h3_c1,{},{},{pigeon(3). hole(3). color(1).}).
#pos(id0def_p2_h3_c2,{},{},{pigeon(2). hole(3). color(2).}).
#pos(id0def_p2_h4_c2,{},{},{pigeon(2). hole(4). color(2).}).
#pos(id0def_p2_h5_c2,{},{},{pigeon(2). hole(5). color(2).}).
#pos(id0def_p3_h4_c2,{},{},{pigeon(3). hole(4). color(2).}).
#pos(id0def_p3_h5_c2,{},{},{pigeon(3). hole(5). color(2).}).
#pos(id0def_p5_h8_c4,{},{},{pigeon(5). hole(8). color(4).}).
#neg(id1_C0_p3_h4_c1@100, {assign(2,3), assign(3,1), assign(1,2)}, {assign(2,2), assign(3,3), assign(1,1), assign(3,2), assign(1,3), assign(2,1)}, {pigeon(3). hole(3). color(1).}).
#neg(id3_C0_p3_h4_c1@100, {assign(3,2), assign(1,3), assign(2,1)}, {assign(2,2), assign(3,3), assign(1,1), assign(1,2), assign(2,3), assign(3,1)}, {pigeon(3). hole(3). color(1).}).
#neg(id4_C0_p3_h4_c1@100, {assign(2,3), assign(1,1), assign(3,2)}, {assign(2,2), assign(3,3), assign(1,2), assign(1,3), assign(2,1), assign(3,1)}, {pigeon(3). hole(3). color(1).}).
#neg(id5_C0_p3_h4_c1@100, {assign(3,3), assign(1,2), assign(2,1)}, {assign(2,2), assign(1,1), assign(3,2), assign(1,3), assign(2,3), assign(3,1)}, {pigeon(3). hole(3). color(1).}).
#neg(id6_C0_p3_h4_c1@100, {assign(2,2), assign(3,3), assign(1,1)}, {assign(1,2), assign(3,2), assign(1,3), assign(2,1), assign(2,3), assign(3,1)}, {pigeon(3). hole(3). color(1).}).
