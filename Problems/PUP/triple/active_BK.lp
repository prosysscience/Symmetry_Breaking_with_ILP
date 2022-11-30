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
%% From files: 2-triple-9-6.lp - 2-triple-9-7.lp
 :- closezones(V2,V1), unit2sensorGEQ(V2,V1), zone2sensor(V1,V2).
 :- closesensors(V1,V2), not unit2zoneGEQ(V1,V2), unit2sensorGEQ(V1,V2).

