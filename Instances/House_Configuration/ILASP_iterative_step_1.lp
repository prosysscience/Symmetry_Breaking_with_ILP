%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeb(2,cabinetTOthing(var(cabinet),var(thing))).
#modeb(2,thing(var(thing))).
#modeb(2,cabinet(var(cabinet))).
#modeb(1,maxthing(var(thing))).
#modeb(1,maxcabinet(var(cabinet))).
#modeb(2,lessthan(var(cabinet),var(thing))).
#modeb(2,lessthan(var(cabinet),var(cabinet)),(anti_reflexive)).
#modeb(2,lessthan(var(thing),var(cabinet))).
#modeb(2,lessthan(var(thing),var(thing)),(anti_reflexive)).
#max_penalty(30).
