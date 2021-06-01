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
%% Iteration n 1
%% From files: p1_c2_t4.lp
 :- cabinetTOthing(V1,V2), not lessthan(V1,V2), not maxcabinet(V1).


%% Iteration n 2
%% From files: p2_c2_t4.lp
 :- lessthan(V3,V1), maxthing(V2), personTOthing(V1,V2).
 :- cabinetTOthing(V3,V2), lessthan(V3,V1), personTOthing(V1,V2).


