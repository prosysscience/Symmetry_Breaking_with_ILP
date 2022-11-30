%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
person(X-1) :- person(X), X > 1.
thing(X-1) :- thing(X), X > 1.
cabinet(X-1) :- cabinet(X), X > 1.

1{personTOthing(X,Y):person(X)}1 :- thing(Y).
1{cabinetTOthing(X,Y):cabinet(X)}1 :- thing(Y).
:- person(X), not personTOthing(X,_).
:- cabinet(X), #count{Y :cabinetTOthing(X,Y)} >2. % only 2 things
:- cabinetTOthing(C, T1), cabinetTOthing(C, T2), T1!=T2,
personTOthing(P1,T1), personTOthing(P2, T2), P1!=P2.


 :~ personTOthing(P,T). [P@2,T]
 :~ cabinetTOthing(C,T). [C@1,T]