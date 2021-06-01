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

%% Iteration n 1
%% From files: c1_p3_h5.lp
 :- assign(V2,V3), lessthan(V1,V2), maxhole(V3).
 :- assign(V3,V2), maxpigeon(V3), next(V1,V2).

