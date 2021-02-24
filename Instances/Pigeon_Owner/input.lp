%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.
color(X-1) :- color(X), X > 1.
owner(X-1) :- owner(X), X > 1.


{assign(P,H):hole(H)}=1:- pigeon(P).
{assignColor(P,C):color(C)}=1:- pigeon(P).
{assignOwner(P,O):owner(O)}=1:- pigeon(P).


next(X,X+1) :- hole(X), hole(X+1).
:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assignColor(P1,C1), assignColor(P2,C2), C1!=C2.
:- color(C), not assignColor(_,C).
:- owner(O), not assignOwner(_,O).
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assignOwner(P1,O1), assignOwner(P2,O2), O1 != O2.

%%%%%%%
#show assign/2.
#show assignColor/2.
#show assignOwner/2.
