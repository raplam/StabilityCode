function Utilities = utilityEvaluationBottleneck(departureTimes,arrivalTimes,population)
Utilities=zeros(population.N,length(departureTimes));
for i=1:population.N
    Utilities(i,:)=population.H{i}(departureTimes)+population.W{i}(arrivalTimes);
end
end

