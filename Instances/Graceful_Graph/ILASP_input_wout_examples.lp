%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Background Knowledge
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nodes and values
node(X) :- edge(X,Y).
node(Y) :- edge(X,Y).

num(0).
num(N) :- num(N1), N=N1+1, num_edges(E), N<=E.

% assignment to nodes
0{value(X,N)}1 :- num(N),node(X).
:- node(X), not value(X,_).
:- node(X), value(X,N1), value(X,N2), N1 != N2.
% assignment to edges
0{edge_value(edge(X,Y),N)}1 :- edge(X,Y),num(N), N>0.
:- edge(X,Y), not edge_value(edge(X,Y),_).
:- edge(X,Y), edge_value(edge(X,Y),N1), edge_value(edge(X,Y),N2), N1 != N2.


% relates node values with edge values
:- not edge_value(edge(X,Y),M-N), edge(X,Y), value(X,M), value(Y,N), N < M.
:- not edge_value(edge(X,Y),N-M), edge(X,Y), value(X,M), value(Y,N), N > M.

% alldifferent values
:- value(X,N), value(Y,N), num(N), X<Y.
:- edge_value(X,N), edge_value(Y,N), num(N), X<Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Search Space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeb(2,edge(var(node),var(node))).
#modeb(2,value(var(node),var(num))).
#modeb(2,node(var(node))).
#modeb(2,num(var(num))).
#modeb(2,num_edges(var(num))).
#modeb(2,maxC(var(node))).
#modeb(2,minC(var(node))).
#modeb(2,clique(var(node),var(num))).
#modeb(2,next(var(node),var(node))).
%#modeb(2,edge_value(var(edge),var(num))).
%#modeb(2,edge_value(edge(var(node),var(node)),var(num))).
#modeb(2,lessthan(var(node),var(node)),(anti_reflexive)).
#modeb(2,lessthan(var(node),var(num))).
#modeb(2,lessthan(var(num),var(node))).
#modeb(2,lessthan(var(num),var(num)),(anti_reflexive)).
%#modeb(2,lessthan(var(edge),var(edge)),(anti_reflexive)).
%#constant(node,1).
%#constant(num,0).
#max_penalty(30).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Examples and extra rules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
