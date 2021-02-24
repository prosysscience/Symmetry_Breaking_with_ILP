node(X) :- edge(X,_).
node(X) :- edge(_,X).
numNodes(N) :- N=#count{X:node(X)}.

{clique(X,1..N):numNodes(N)}=1 :- node(X).

missingEdge(X,Y):- node(X), node(Y), X<Y, not edge(X,Y).
:- clique(X,C), clique(Y,C), missingEdge(X,Y).

:~ clique(_,C). [1@2,C]
:~ clique(_,C). [C@1]
#show clique/2.