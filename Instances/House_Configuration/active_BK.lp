%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lessthan(X,Y) :- cabinet(X), cabinet(Y), X <Y.
lessthan(X,Y) :- person(X), person(Y), X <Y.
lessthan(X,Y) :- thing(X), thing(Y), X <Y.

maxcabinet(X) :- cabinet(X), not cabinet(X+1).
maxperson(X) :- person(X), not person(X+1).
maxthing(X) :- thing(X), not thing(X+1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


