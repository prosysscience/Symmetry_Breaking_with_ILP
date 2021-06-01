%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeb(2,assign(var(pigeon),var(pigeon))).
#modeb(2,pigeon(var(pigeon))).
#modeb(2,hole(var(pigeon))).
#modeb(1,maxhole(var(pigeon))).
#modeb(1,maxpigeon(var(pigeon))).
#modeb(2,next(var(pigeon),var(pigeon)),(anti_reflexive)).
#modeb(2,lessthan(var(pigeon),var(pigeon)),(anti_reflexive)).
#max_penalty(30).
