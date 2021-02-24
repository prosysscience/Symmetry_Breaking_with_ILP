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
% Mode bias (vars of type pigeon and hole)
% 1st call:
%   p=3 h=3 c=1 
%:- assign(V2,V3), lessthan(V1,V2), maxhole(V3). 
%:- assign(V3,V2), lessthan(V1,V2), maxpigeon(V3).
% Increase mode bias (vars of type color)
% 2nd call:
%   p=3 h=4 c=2 
%:- assignColor(V3,V1), lessthan(V1,V3), lessthan(V2,V1).
% 3rd call:
%   p=3 h=6 c=3 
%:- assignColor(V3,V2), lessthan(V1,V2), maxpigeon(V3).
% 4th call:
%   p=3 h=6 c=3
%:- assignColor(V1,V3), lessthan(V1,V3), lessthan(V2,V1).

