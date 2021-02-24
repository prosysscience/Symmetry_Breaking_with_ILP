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
% Mode bias (vars of type pigeon and hole)
% 1st call:
%   p=3 h=4 c=1 o=1 -sat 
:- assign(V1,V2), lessthan(V1,V3), lessthan(V2,V1). 
:- assign(V3,V2), lessthan(V1,V3), next(V1,V2).
% Increase mode bias (vars of type color)
% 2nd call:
%   p=3 h=4 c=2 o=1 -sat 
:- assignColor(V3,V1), lessthan(V1,V3), lessthan(V2,V1).
% Increase mode bias (vars of type owner)
% 3rd call:
%   p=3 h=5 c=2 o=2 -sat 
:- assignOwner(V3,V1), lessthan(V1,V3), lessthan(V2,V1).
% 4th call:
%   p=3 h=5 c=2 o=2 -sat 
:- assignOwner(V3,V2), lessthan(V1,V2), not lessthan(V3,V2).
% 5th call:
%   p=3 h=6 c=3 o=2 -sat
:- assignColor(V3,V2), lessthan(V1,V2), not lessthan(V3,V2).
