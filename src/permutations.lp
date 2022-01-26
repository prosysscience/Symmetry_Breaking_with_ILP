% Evaluate permutations and perform symmetry breaking
index(P,N)   :- index(P,X,N).

inspect(P,X,N) :- index(P,X,N), not index(P,N+1).
inspect(P,X,N) :- index(P,X,N), inspect(P,X2,N+1), assign(X2,1).
inspect(P,X,N) :- index(P,X,N), inspect(P,X2,N+1), permute(P,X1,X2,S), assign(X1,S).

dominated(P) :- inspect(P,X2,N), permute(P,X1,X2,S), assign(X2,1), assign(X1,S).

:- not dominated(_).

#show dominated/1.