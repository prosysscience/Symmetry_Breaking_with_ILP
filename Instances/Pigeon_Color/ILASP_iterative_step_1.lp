%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeb(2,assign(var(pigeon),var(hole))).
#modeb(2,pigeon(var(pigeon))).
#modeb(2,hole(var(hole))).
#modeb(1,maxhole(var(hole))).
#modeb(1,maxpigeon(var(pigeon))).
#modeb(2,next(var(hole),var(hole)),(anti_reflexive)).
#modeb(2,lessthan(var(hole),var(hole)),(anti_reflexive)).
#modeb(2,lessthan(var(pigeon),var(pigeon)),(anti_reflexive)).
#modeb(2,lessthan(var(hole),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(hole))).
#max_penalty(30).
