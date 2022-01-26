%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%lessthan(X,Y) :- sensor(X), sensor(Y), X <Y.
%lessthan(X,Y) :- zone(X), zone(Y), X <Y.
%lessthan(X,Y) :- comUnit(X), comUnit(Y), X <Y.

%maxzone(M) :- zone(M), not zone(M+1).
%maxsensor(P) :- sensor(P), not sensor(P+1).
%maxcomUnit(C) :- comUnit(C), not comUnit(C+1).

%next(M-1,M) :- maxzone(M), M>1.
%next(M-1,M) :- maxsensor(M), M>1.
%next(M-1,M) :- next(M,M+1), M>1.
unit2zoneGEQ(U,Z) :- unit2zone(U,Z).
unit2zoneGEQ(U,Z) :- unit2zoneGEQ(U+1,Z), 0 < U.
unit2sensorGEQ(U,Z) :- unit2sensor(U,Z).
unit2sensorGEQ(U,Z) :- unit2sensorGEQ(U+1,Z), 0 < U.
closezones(Z,Z1) :- zone2sensor(Z,S), zone2sensor(Z1,S), Z != Z1.
closesensors(S,S1) :- zone2sensor(Z,S), zone2sensor(Z,S1), S != S1.
%partnerunitsLT(P,U) :-  partnerunits(P,U), P < U.
%middlezone(Z) :- zone2sensor(Z,S1), zone2sensor(Z,S2), zone2sensor(Z,S3), S1 !=S2, S2 != S3, S1 != S3.

%singlesensor(S) :- sensor(S), #count{Z,S : zone2sensor(Z,S)} = 1.
%indoors(Z,C) :- zone(Z), C = #count{S,Z : zone2sensor(Z,S), singlesensor(S)}.
%outdoors(Z,C) :- zone(Z), C = #count{S,Z : zone2sensor(Z,S)}.
%alldoors(Z,C1+C2) :- outdoors(Z,C1), indoors(Z,C2).
%type(Z,N) :- zone(Z), indoors(Z,C1), outdoors(Z,C2), N = #count {C3: indoors(Z1,C3), C3 < C1; C4: indoors(Z1,C1), outdoors(Z1,C4), C4 < C2}.
%maxzone(M,T) :- type(_,T), M = #max{Z : type(Z,T)}.
