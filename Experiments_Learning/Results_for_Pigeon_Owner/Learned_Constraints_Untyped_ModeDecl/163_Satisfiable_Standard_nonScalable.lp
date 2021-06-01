%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lessthan(X,Y) :- pigeon(X), pigeon(Y), X <Y.
lessthan(X,Y) :- hole(X), hole(Y), X <Y.
lessthan(X,Y) :- color(X), color(Y), X <Y.
lessthan(X,Y) :- owner(X), owner(Y), X <Y.

maxhole(M) :- hole(M), not hole(M+1).
maxpigeon(P) :- pigeon(P), not pigeon(P+1).
maxcolor(C) :- color(C), not color(C+1).
maxowner(O) :- owner(O), not owner(O+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Iteration n 1
%% From files: o1_c1_p3_h4.lp
 :- assign(V1,V2), assign(V3,V1), next(V1,V2).
 :- assign(V3,V1), lessthan(V1,V2), maxpigeon(V3).

%% Iteration n 2
%% From files: o1_c2_p3_h4.lp
 :- maxcolor(V1), not assignColor(V1,V1).

%% Iteration n 3
%% From files: o2_c1_p3_h4.lp
 :- assignOwner(V1,V1), not maxowner(V1).

