%%% Third Step
#modeb(2,assignOwner(var(pigeon),var(owner))).
#modeb(2,owner(var(owner))).
#modeb(1,maxowner(var(owner))).
#modeb(2,lessthan(var(owner),var(owner)),(anti_reflexive)).
#modeb(2,lessthan(var(owner),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(owner))).
#modeb(2,lessthan(var(hole),var(owner))).
#modeb(2,lessthan(var(owner),var(hole))).
#modeb(2,lessthan(var(color),var(owner))).
#modeb(2,lessthan(var(owner),var(color))).
