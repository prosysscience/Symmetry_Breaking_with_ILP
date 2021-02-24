%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lessthan(X,Y) :- sensor(X), sensor(Y), X <Y.
lessthan(X,Y) :- zone(X), zone(Y), X <Y.
lessthan(X,Y) :- comUnit(X), comUnit(Y), X <Y.

maxzone(M) :- zone(M), not zone(M+1).
maxsensor(P) :- sensor(P), not sensor(P+1).
maxcomUnit(C) :- comUnit(C), not comUnit(C+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

