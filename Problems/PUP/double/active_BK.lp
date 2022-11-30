%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Extra Predicates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
unit2zoneGEQ(U,Z) :- unit2zone(U,Z).
unit2zoneGEQ(U,Z) :- unit2zoneGEQ(U+1,Z), 0 < U.
unit2sensorGEQ(U,Z) :- unit2sensor(U,Z).
unit2sensorGEQ(U,Z) :- unit2sensorGEQ(U+1,Z), 0 < U.

closezones(Z,Z1) :- zone2sensor(Z,S), zone2sensor(Z1,S), Z != Z1.
closesensors(S,S1) :- zone2sensor(Z,S), zone2sensor(Z,S1), S != S1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SBCs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Iteration n None
%% From files: 2-double-6-4.lp - 2-double-6-6.lp
 :- unit2sensorGEQ(V1,V1), unit2sensorGEQ(V2,V1), closezones(V1,V2).

