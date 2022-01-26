
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