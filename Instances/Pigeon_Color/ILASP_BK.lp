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

