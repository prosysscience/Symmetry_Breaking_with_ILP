%%% Second Step
#modeb(2,personTOthing(var(person),var(thing))).
#modeb(2,person(var(person))).
#modeb(1,maxperson(var(person))).
#modeb(2,lessthan(var(cabinet),var(person))).
#modeb(2,lessthan(var(person),var(cabinet))).
#modeb(2,lessthan(var(person),var(person)),(anti_reflexive)).
#modeb(2,lessthan(var(person),var(thing))).
#modeb(2,lessthan(var(thing),var(person))).
