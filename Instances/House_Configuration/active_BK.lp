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
% Mode bias (vars of type cabinet and thing)
% 1st call
%   p=1 c=2 t=2 
:- cabinetTOthing(V2,V1), lessthan(V1,V2).
%Increase mode bias (vars of type person)
% 2nd call
%   p=2 c=2 t=4 
:- not lessthan(V1,V2), not maxperson(V1), personTOthing(V1,V2). 
:- lessthan(V3,V1), maxthing(V2), personTOthing(V1,V2).

