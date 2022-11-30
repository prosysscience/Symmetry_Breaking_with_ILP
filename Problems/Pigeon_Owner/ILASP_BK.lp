%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.
color(X-1) :- color(X), X > 1.
owner(X-1) :- owner(X), X > 1.

0{assign(P,H)}1:- pigeon(P), hole(H).
0{assign_color(P,C)}1:- pigeon(P), color(C).
0{assign_owner(P,O)}1:- pigeon(P), owner(O).
:- assign(P,H1), assign(P,H2), H1 != H2.
:- assign_color(P,C1), assign_color(P,C2), C1 != C2.
:- assign_owner(P,O1), assign_owner(P,O2), O1 != O2.
:- pigeon(P), not assign(P,_).
:- pigeon(P), not assign_color(P,_).
:- pigeon(P), not assign_owner(P,_).

next(X,X+1) :- hole(X), hole(X+1).
:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assign_color(P1,C1), assign_color(P2,C2), C1!=C2.
:- color(C), not assign_color(_,C).
:- owner(O), not assign_owner(_,O).
:- assign(P1,H1), assign(P2,H2), P1 != P2, next(H1,H2), assign_owner(P1,O1), assign_owner(P2,O2), O1 != O2.

 :~ assign_owner(P,O). [O@3,P]
 :~ assign_color(P,C). [C@2,P]
 :~ assign(P,H). [H@1]
