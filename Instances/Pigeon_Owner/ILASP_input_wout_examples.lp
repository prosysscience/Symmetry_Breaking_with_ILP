%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.
color(X-1) :- color(X), X > 1.
owner(X-1) :- owner(X), X > 1.

0{assign(P,H)}1:- pigeon(P), hole(H).
0{assignColor(P,C)}1:- pigeon(P), color(C).
0{assignOwner(P,O)}1:- pigeon(P), owner(O).
:- assign(P,H1), assign(P,H2), H1 != H2.
:- assignColor(P,C1), assignColor(P,C2), C1 != C2.
:- assignOwner(P,O1), assignOwner(P,O2), O1 != O2.
:- pigeon(P), not assign(P,_).
:- pigeon(P), not assignColor(P,_).
:- pigeon(P), not assignOwner(P,_).

next(X,X+1) :- hole(X), hole(X+1).
:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assignColor(P1,C1), assignColor(P2,C2), C1!=C2.
:- color(C), not assignColor(_,C).
:- owner(O), not assignOwner(_,O).
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assignOwner(P1,O1), assignOwner(P2,O2), O1 != O2.

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
%%%
#modeb(2,assignColor(var(pigeon),var(color))).
#modeb(2,color(var(color))).
#modeb(1,maxcolor(var(color))).
#modeb(2,lessthan(var(color),var(color)),(anti_reflexive)).
#modeb(2,lessthan(var(color),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(color))).
#modeb(2,lessthan(var(hole),var(color))).
#modeb(2,lessthan(var(color),var(hole))).
%%%%%%
#modeb(2,assignOwner(var(pigeon),var(owner))).
#modeb(2,owner(var(owner))).
#modeb(1,maxowner(var(owner))).
#modeb(2,lessthan(var(owner),var(owner)),(anti_reflexive)).
#modeb(2,lessthan(var(owner),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(owner))).
#modeb(2,lessthan(var(hole),var(owner))).
#modeb(2,lessthan(var(owner),var(hole))).
#modeb(2,lessthan(var(color),var(owner))).
#modeb(2,lessthan(var(owner),var(color))).
#max_penalty(30).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Examples and extra rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
