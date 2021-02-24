% Extract relevant variables from permutations and generate assignment

target(P,X2) :- permutation(P), permute(P,X1,X2,S).

variable(X1) :- permutation(P), permute(P,X1,X2,S).
variable(X2) :- target(P,X2).

{assign(X,1)} :- variable(X).
 assign(X,0)  :- variable(X), not assign(X,1).

% Evaluate permutations and perform symmetry breaking

index(P,X,N) :- target(P,X), N = #count{X2 : target(P,X2), X2 <= X}.
index(P,N)   :- index(P,X,N).

inspect(P,X,N) :- index(P,X,N), not index(P,N+1).
inspect(P,X,N) :- index(P,X,N), inspect(P,X2,N+1),
                  assign(X2,1).
inspect(P,X,N) :- index(P,X,N), inspect(P,X2,N+1), permute(P,X1,X2,S),
                  assign(X1,S).

:- inspect(P,X2,N), permute(P,X1,X2,S), assign(X2,1), assign(X1,S).

% Output truth assignments not mapped to smaller assignments by permutations

#show.
#show X:assign(X,1).
