%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lessthan(X,Y) :- pigeon(X), pigeon(Y), X <Y.
lessthan(X,Y) :- hole(X), hole(Y), X <Y.

maxhole(M) :- hole(M), not hole(M+1).
maxpigeon(P) :- pigeon(P), not pigeon(P+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st call:
%   p=3 h=3 
%   p=3 h=4 
%:- assign(V1,V3), lessthan(V1,V3), lessthan(V2,V1). 
%:- assign(V3,V2), lessthan(V1,V2), maxpigeon(V1). 
%:- assign(V2,V3), lessthan(V1,V2), maxhole(V3).
% 2nd call:
%   p=3 h=3 
%   p=3 h=4 
%:- assign(V3,V2), lessthan(V1,V2), maxpigeon(V3).

