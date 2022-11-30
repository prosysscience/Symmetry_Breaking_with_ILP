%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.
color(X-1) :- color(X), X > 1.
owner(X-1) :- owner(X), X > 1.


{assign(P,H):hole(H)}=1:- pigeon(P).
{assign_color(P,C):color(C)}=1:- pigeon(P).
{assign_owner(P,O):owner(O)}=1:- pigeon(P).


next(X,X+1) :- hole(X), hole(X+1).
:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assign_color(P1,C1), assign_color(P2,C2), C1!=C2.
:- color(C), not assign_color(_,C).
:- owner(O), not assign_owner(_,O).
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assign_owner(P1,O1), assign_owner(P2,O2), O1 != O2.

 :~ assign_owner(P,O). [O@3,P]
 :~ assign_color(P,C). [C@2,P]
 :~ assign(P,H). [H@1]

