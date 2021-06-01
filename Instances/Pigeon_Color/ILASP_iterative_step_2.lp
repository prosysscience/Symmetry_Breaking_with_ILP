%%% Second Step
#modeb(2,assignColor(var(pigeon),var(color))).
#modeb(2,color(var(color))).
#modeb(1,maxcolor(var(color))).
#modeb(2,lessthan(var(color),var(color)),(anti_reflexive)).
#modeb(2,lessthan(var(color),var(pigeon))).
#modeb(2,lessthan(var(pigeon),var(color))).
#modeb(2,lessthan(var(color),var(hole))).
#modeb(2,lessthan(var(hole),var(color))).
