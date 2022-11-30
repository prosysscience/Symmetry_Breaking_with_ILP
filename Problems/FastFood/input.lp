{ depot(RN,RK) : restaurant(RN,RK) } = X :- number_depots(X).

 :~  restaurant(RN,RK), Dist = #min{|DK-RK| : depot(DN,DK)}. [Dist@1,RN]
