#const n=2.
% add n occurence for each restaurant 
restaurant(RK,RK,n)  :- rest(RN,RK), 0 < n.
restaurant(r(RN),RK,N) :- restaurant(RN,RK,N+1), 0 < N.
restaurant(RN,RK) :- restaurant(RN,RK,N).
#show restaurant/2.
#show number_depots/1.