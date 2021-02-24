%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zone(Z) :- zone2sensor(Z,D).
sensor(D) :- zone2sensor(Z,D).

0{unit2zone(U,Z)}1 :- zone(Z), comUnit(U).
0{ unit2sensor(U,S) }1 :- sensor(S), comUnit(U).
:- unit2zone(U1,Z), unit2zone(U2,Z), comUnit(U1), comUnit(U2), U1 != U2.
:- unit2sensor(U1,S), unit2sensor(U2,S), comUnit(U1), comUnit(U2), U1 != U2.
:- not unit2zone(_,Z), zone(Z).
:- not unit2sensor(_,S), sensor(S).
%:- comUnit(U), maxElements(M), M+1 { unit2zone(U,Z): zone(Z) }.
:- comUnit(U), unit2zone(U,Z1), unit2zone(U,Z2), unit2zone(U,Z3), Z1 != Z2, Z2 != Z3, Z1 != Z3.
%:- comUnit(U), maxElements(M), M+1 { unit2sensor(U,S): sensor(S) }.
:- comUnit(U), unit2sensor(U,Z1), unit2sensor(U,Z2), unit2sensor(U,Z3), Z1 != Z2, Z2 != Z3, Z1 != Z3.
partnerunits(U,P) :- unit2zone(U,Z), zone2sensor(Z,S), unit2sensor(P,S), U!=P.
partnerunits(U,P) :- partnerunits(P,U), comUnit(U), comUnit(P).
%:- comUnit(U), maxPU(M), M+1 { partnerunits(U,P): comUnit(P) }.
:- comUnit(U), partnerunits(U,Z1), partnerunits(U,Z2), partnerunits(U,Z3), Z1 != Z2, Z2 != Z3, Z1 != Z3.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#modeb(2,unit2zone(var(unit),var(zone))).
%#modeb(2,unit2sensor(var(unit),var(sensor))).
%#modeb(2,unit(var(unit))).
%#modeb(2,sensor(var(sensor))).
%#modeb(2,partnerunits(var(unit),var(unit))).
%#modeb(2,lessthan(var(unit),var(unit)),(anti_reflexive)).
%#modeb(2,lessthan(var(sensor),var(sensor)),(anti_reflexive)).
%#modeb(2,lessthan(var(zone),var(zone)),(anti_reflexive)).
%#modeb(2,lessthan(var(unit),var(sensor))).
%#modeb(2,lessthan(var(sensor),var(unit))).
%#modeb(2,lessthan(var(zone),var(sensor))).
%#modeb(2,lessthan(var(sensor),var(zone))).
%#modeb(2,lessthan(var(zone),var(unit))).
%#modeb(2,lessthan(var(unit),var(zone))).
#modeb(1,unit2zone(var(unit),var(unit))).
#modeb(1,unit2sensor(var(unit),var(unit))).

#modeb(1,lessthan(var(unit),var(unit)),(anti_reflexive)).

#max_penalty(30).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Examples and extra rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
