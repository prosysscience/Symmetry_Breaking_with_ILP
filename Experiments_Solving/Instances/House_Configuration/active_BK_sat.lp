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
%% From files: p1_c2_t2.lp - p2_c2_t4.lp
 :- cabinetTOthing(V1,V2), lessthan(V1,V3), lessthan(V2,V1).
 :- cabinetTOthing(V2,V3), lessthan(V1,V2), maxthing(V3).

%% Iteration n 2
%% From files: p2_c3_t4.lp
 :- lessthan(V2,V1), personTOthing(V1,V2).

