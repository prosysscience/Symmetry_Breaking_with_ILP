%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pigeon(X-1) :- pigeon(X), X > 1.
hole(X-1) :- hole(X), X > 1.

0{assign(P,H)}1:- pigeon(P), hole(H).

:- assign(P1,H), assign(P2,H), P1 != P2.
:- assign(P,H1), assign(P,H2), H1 != H2.
:- pigeon(P), not assign(P,_).

 :~ assign(P,H). [H@1]