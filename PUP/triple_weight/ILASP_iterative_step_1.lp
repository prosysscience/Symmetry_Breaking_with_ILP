
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%#modeb(1,comUnit(var(unit))).
%#modeb(1,zone(var(unit))).
%#modeb(1,sensor(var(unit))).
%#modeb(2,middlezone(var(unit))).
#modeb(1,partnerunits(var(unit),var(unit)),(symmetric,anti_reflexive)).
#modeb(1,zone2sensor(var(unit),var(unit))).
%#modeb(1,unit2zone(var(unit),var(unit))).
%#modeb(2,unit2sensor(var(unit),var(unit))).
#modeb(2,unit2zoneGEQ(var(unit),var(unit))).
#modeb(2,unit2sensorGEQ(var(unit),var(unit))).
#modeb(1,closezones(var(unit),var(unit)),(symmetric,anti_reflexive)).
#modeb(1,closesensors(var(unit),var(unit)),(symmetric,anti_reflexive)).
%#modeb(2,lessthan(var(unit),var(unit)),(anti_reflexive)).
%#modeb(1,maxzone(var(unit))).
%#modeb(1,maxsensor(var(unit))).
%#modeb(1,maxcomUnit(var(unit))).
%#modeb(2,next(var(unit),var(unit)),(anti_reflexive)).

#max_penalty(30).

#bias("
cost(3, partnerunits(var__(1),var__(2))) :- body(partnerunits(var__(1),var__(2))).
cost(3, partnerunits(var__(2),var__(1))) :- body(partnerunits(var__(2),var__(1))).
cost(3, partnerunits(var__(3),var__(2))) :- body(partnerunits(var__(3),var__(2))).
cost(3, partnerunits(var__(2),var__(3))) :- body(partnerunits(var__(2),var__(3))).
cost(3, partnerunits(var__(3),var__(1))) :- body(partnerunits(var__(3),var__(1))).
cost(3, partnerunits(var__(1),var__(3))) :- body(partnerunits(var__(1),var__(3))).
cost(1, zone2sensor(var__(1),var__(2))) :- body(zone2sensor(var__(1),var__(2))).
cost(1, zone2sensor(var__(2),var__(1))) :- body(zone2sensor(var__(2),var__(1))).
cost(1, zone2sensor(var__(3),var__(2))) :- body(zone2sensor(var__(3),var__(2))).
cost(1, zone2sensor(var__(2),var__(3))) :- body(zone2sensor(var__(2),var__(3))).
cost(1, zone2sensor(var__(3),var__(1))) :- body(zone2sensor(var__(3),var__(1))).
cost(1, zone2sensor(var__(1),var__(3))) :- body(zone2sensor(var__(1),var__(3))).
cost(1, zone2sensor(var__(1),var__(1))) :- body(zone2sensor(var__(1),var__(1))).
cost(1, zone2sensor(var__(2),var__(2))) :- body(zone2sensor(var__(2),var__(2))).
cost(1, zone2sensor(var__(3),var__(3))) :- body(zone2sensor(var__(3),var__(3))).
cost(3, unit2zoneGEQ(var__(1),var__(2))) :- body(unit2zoneGEQ(var__(1),var__(2))).
cost(3, unit2zoneGEQ(var__(2),var__(1))) :- body(unit2zoneGEQ(var__(2),var__(1))).
cost(3, unit2zoneGEQ(var__(3),var__(2))) :- body(unit2zoneGEQ(var__(3),var__(2))).
cost(3, unit2zoneGEQ(var__(2),var__(3))) :- body(unit2zoneGEQ(var__(2),var__(3))).
cost(3, unit2zoneGEQ(var__(3),var__(1))) :- body(unit2zoneGEQ(var__(3),var__(1))).
cost(3, unit2zoneGEQ(var__(1),var__(3))) :- body(unit2zoneGEQ(var__(1),var__(3))).
cost(2, unit2zoneGEQ(var__(1),var__(1))) :- body(unit2zoneGEQ(var__(1),var__(1))).
cost(2, unit2zoneGEQ(var__(2),var__(2))) :- body(unit2zoneGEQ(var__(2),var__(2))).
cost(2, unit2zoneGEQ(var__(3),var__(3))) :- body(unit2zoneGEQ(var__(3),var__(3))).
cost(3, unit2sensorGEQ(var__(1),var__(2))) :- body(unit2sensorGEQ(var__(1),var__(2))).
cost(3, unit2sensorGEQ(var__(2),var__(1))) :- body(unit2sensorGEQ(var__(2),var__(1))).
cost(3, unit2sensorGEQ(var__(3),var__(2))) :- body(unit2sensorGEQ(var__(3),var__(2))).
cost(3, unit2sensorGEQ(var__(2),var__(3))) :- body(unit2sensorGEQ(var__(2),var__(3))).
cost(3, unit2sensorGEQ(var__(3),var__(1))) :- body(unit2sensorGEQ(var__(3),var__(1))).
cost(3, unit2sensorGEQ(var__(1),var__(3))) :- body(unit2sensorGEQ(var__(1),var__(3))).
cost(2, unit2sensorGEQ(var__(1),var__(1))) :- body(unit2sensorGEQ(var__(1),var__(1))).
cost(2, unit2sensorGEQ(var__(2),var__(2))) :- body(unit2sensorGEQ(var__(2),var__(2))).
cost(2, unit2sensorGEQ(var__(3),var__(3))) :- body(unit2sensorGEQ(var__(3),var__(3))).
cost(1, closesensors(var__(1),var__(2))) :- body(closesensors(var__(1),var__(2))).
cost(1, closesensors(var__(2),var__(1))) :- body(closesensors(var__(2),var__(1))).
cost(1, closesensors(var__(3),var__(2))) :- body(closesensors(var__(3),var__(2))).
cost(1, closesensors(var__(2),var__(3))) :- body(closesensors(var__(2),var__(3))).
cost(1, closesensors(var__(3),var__(1))) :- body(closesensors(var__(3),var__(1))).
cost(1, closesensors(var__(1),var__(3))) :- body(closesensors(var__(1),var__(3))).
cost(1, closezones(var__(1),var__(2))) :- body(closezones(var__(1),var__(2))).
cost(1, closezones(var__(2),var__(1))) :- body(closezones(var__(2),var__(1))).
cost(1, closezones(var__(3),var__(2))) :- body(closezones(var__(3),var__(2))).
cost(1, closezones(var__(2),var__(3))) :- body(closezones(var__(2),var__(3))).
cost(1, closezones(var__(3),var__(1))) :- body(closezones(var__(3),var__(1))).
cost(1, closezones(var__(1),var__(3))) :- body(closezones(var__(1),var__(3))).
cost(3, naf(partnerunits(var__(1),var__(2)))) :- body(naf(partnerunits(var__(1),var__(2)))).
cost(3, naf(partnerunits(var__(2),var__(1)))) :- body(naf(partnerunits(var__(2),var__(1)))).
cost(3, naf(partnerunits(var__(3),var__(2)))) :- body(naf(partnerunits(var__(3),var__(2)))).
cost(3, naf(partnerunits(var__(2),var__(3)))) :- body(naf(partnerunits(var__(2),var__(3)))).
cost(3, naf(partnerunits(var__(3),var__(1)))) :- body(naf(partnerunits(var__(3),var__(1)))).
cost(3, naf(partnerunits(var__(1),var__(3)))) :- body(naf(partnerunits(var__(1),var__(3)))).
cost(1, naf(zone2sensor(var__(1),var__(2)))) :- body(naf(zone2sensor(var__(1),var__(2)))).
cost(1, naf(zone2sensor(var__(2),var__(1)))) :- body(naf(zone2sensor(var__(2),var__(1)))).
cost(1, naf(zone2sensor(var__(3),var__(2)))) :- body(naf(zone2sensor(var__(3),var__(2)))).
cost(1, naf(zone2sensor(var__(2),var__(3)))) :- body(naf(zone2sensor(var__(2),var__(3)))).
cost(1, naf(zone2sensor(var__(3),var__(1)))) :- body(naf(zone2sensor(var__(3),var__(1)))).
cost(1, naf(zone2sensor(var__(1),var__(3)))) :- body(naf(zone2sensor(var__(1),var__(3)))).
cost(1, naf(zone2sensor(var__(1),var__(1)))) :- body(naf(zone2sensor(var__(1),var__(1)))).
cost(1, naf(zone2sensor(var__(2),var__(2)))) :- body(naf(zone2sensor(var__(2),var__(2)))).
cost(1, naf(zone2sensor(var__(3),var__(3)))) :- body(naf(zone2sensor(var__(3),var__(3)))).
cost(3, naf(unit2zoneGEQ(var__(1),var__(2)))) :- body(naf(unit2zoneGEQ(var__(1),var__(2)))).
cost(3, naf(unit2zoneGEQ(var__(2),var__(1)))) :- body(naf(unit2zoneGEQ(var__(2),var__(1)))).
cost(3, naf(unit2zoneGEQ(var__(3),var__(2)))) :- body(naf(unit2zoneGEQ(var__(3),var__(2)))).
cost(3, naf(unit2zoneGEQ(var__(2),var__(3)))) :- body(naf(unit2zoneGEQ(var__(2),var__(3)))).
cost(3, naf(unit2zoneGEQ(var__(3),var__(1)))) :- body(naf(unit2zoneGEQ(var__(3),var__(1)))).
cost(3, naf(unit2zoneGEQ(var__(1),var__(3)))) :- body(naf(unit2zoneGEQ(var__(1),var__(3)))).
cost(2, naf(unit2zoneGEQ(var__(1),var__(1)))) :- body(naf(unit2zoneGEQ(var__(1),var__(1)))).
cost(2, naf(unit2zoneGEQ(var__(2),var__(2)))) :- body(naf(unit2zoneGEQ(var__(2),var__(2)))).
cost(2, naf(unit2zoneGEQ(var__(3),var__(3)))) :- body(naf(unit2zoneGEQ(var__(3),var__(3)))).
cost(3, naf(unit2sensorGEQ(var__(1),var__(2)))) :- body(naf(unit2sensorGEQ(var__(1),var__(2)))).
cost(3, naf(unit2sensorGEQ(var__(2),var__(1)))) :- body(naf(unit2sensorGEQ(var__(2),var__(1)))).
cost(3, naf(unit2sensorGEQ(var__(3),var__(2)))) :- body(naf(unit2sensorGEQ(var__(3),var__(2)))).
cost(3, naf(unit2sensorGEQ(var__(2),var__(3)))) :- body(naf(unit2sensorGEQ(var__(2),var__(3)))).
cost(3, naf(unit2sensorGEQ(var__(3),var__(1)))) :- body(naf(unit2sensorGEQ(var__(3),var__(1)))).
cost(3, naf(unit2sensorGEQ(var__(1),var__(3)))) :- body(naf(unit2sensorGEQ(var__(1),var__(3)))).
cost(2, naf(unit2sensorGEQ(var__(1),var__(1)))) :- body(naf(unit2sensorGEQ(var__(1),var__(1)))).
cost(2, naf(unit2sensorGEQ(var__(2),var__(2)))) :- body(naf(unit2sensorGEQ(var__(2),var__(2)))).
cost(2, naf(unit2sensorGEQ(var__(3),var__(3)))) :- body(naf(unit2sensorGEQ(var__(3),var__(3)))).
cost(1, naf(closesensors(var__(1),var__(2)))) :- body(naf(closesensors(var__(1),var__(2)))).
cost(1, naf(closesensors(var__(2),var__(1)))) :- body(naf(closesensors(var__(2),var__(1)))).
cost(1, naf(closesensors(var__(3),var__(2)))) :- body(naf(closesensors(var__(3),var__(2)))).
cost(1, naf(closesensors(var__(2),var__(3)))) :- body(naf(closesensors(var__(2),var__(3)))).
cost(1, naf(closesensors(var__(3),var__(1)))) :- body(naf(closesensors(var__(3),var__(1)))).
cost(1, naf(closesensors(var__(1),var__(3)))) :- body(naf(closesensors(var__(1),var__(3)))).
cost(1, naf(closezones(var__(1),var__(2)))) :- body(naf(closezones(var__(1),var__(2)))).
cost(1, naf(closezones(var__(2),var__(1)))) :- body(naf(closezones(var__(2),var__(1)))).
cost(1, naf(closezones(var__(3),var__(2)))) :- body(naf(closezones(var__(3),var__(2)))).
cost(1, naf(closezones(var__(2),var__(3)))) :- body(naf(closezones(var__(2),var__(3)))).
cost(1, naf(closezones(var__(3),var__(1)))) :- body(naf(closezones(var__(3),var__(1)))).
cost(1, naf(closezones(var__(1),var__(3)))) :- body(naf(closezones(var__(1),var__(3)))).
").
