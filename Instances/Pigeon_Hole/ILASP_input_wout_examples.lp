%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.

0{assign(P,H)}1:- pigeon(P), hole(H).

:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P,H1), assign(P,H2), H1 != H2.
:- pigeon(P), not assign(P,_).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeb(2,assign(var(pigeon),var(hole))).
#modeb(2,pigeon(var(pigeon))).
#modeb(2,hole(var(hole))).
#modeb(2,equal(var(pigeon),var(hole))).
#modeb(1,maxhole(var(hole))).
#modeb(1,maxpigeon(var(pigeon))).
#modeb(2,lessthan(var(hole),var(hole))).
#modeb(2,lessthan(var(pigeon),var(pigeon))).
#modeb(2,lessthan(var(hole),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(hole))).
#modeb(2,lessthan(var(hole),var(hole))).

#max_penalty(30).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Examples and extra rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
