%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
person(X-1) :- person(X), X > 1.
thing(X-1) :- thing(X), X > 1.
cabinet(X-1) :- cabinet(X), X > 1.

0{cabinetTOthing(X,Y)}1 :- thing(Y),cabinet(X).
0{personTOthing(X,Y)}1 :- person(X),thing(Y).
:- person(X), not personTOthing(X,_).

:- thing(Y), cabinet(X1), cabinet(X2), X1 != X2, cabinetTOthing(X1,Y), cabinetTOthing(X2,Y).
:- thing(Y), not cabinetTOthing(_,Y).
:- thing(Y), person(X1), person(X2), X1 != X2, personTOthing(X1,Y), personTOthing(X2,Y).
:- thing(Y), not personTOthing(_,Y).
:- cabinet(X), thing(Y1), thing(Y2), thing(Y3), Y1 != Y2, Y1 != Y3, Y3 != Y2,cabinetTOthing(X,Y1), cabinetTOthing(X,Y2),  cabinetTOthing(X,Y3).
:- cabinetTOthing(C, T1), cabinetTOthing(C, T2), T1 != T2,
personTOthing(P1,T1), personTOthing(P2, T2), P1!=P2.

