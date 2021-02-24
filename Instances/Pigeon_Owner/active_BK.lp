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
%   p=3 h=3 c=1 o=1 
:- assign(V2,V3), lessthan(V1,V2), maxhole(V3). 
:- assign(V3,V2), lessthan(V1,V2), maxpigeon(V3).
% Increase mode bias (vars of type color)
% 2nd call:
%   p=3 h=4 c=2 o=1 
:- assignColor(V3,V1), lessthan(V1,V3), lessthan(V2,V1).
% 3rd call:
%   p=2 h=4 c=2 o=1
:- assignColor(V3,V2), lessthan(V1,V2), not lessthan(V3,V2).
% Increase mode bias (vars of type owner)
% 4th call:
%   p=3 h=4 c=1 o=2 
:- assignOwner(V3,V1), lessthan(V1,V3), lessthan(V2,V1).
% 5th call:
%   p=2 h=4 c=1 o=2
:- assignOwner(V3,V2), lessthan(V1,V2), not lessthan(V3,V2).
