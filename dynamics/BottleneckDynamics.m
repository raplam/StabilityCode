function [tex,t_mid,queue]=BottleneckDynamics(departureTimes,w,C)
% w(i) is the mass of users departing at the time slice centered in departureTimes(i).
% We assume they actually depart continuously over an interval of duration T
% centered around departureTimes(i), and compute the average exit time tex(i). 
T=departureTimes(2)-departureTimes(1);
t_mid=zeros(length(departureTimes)+1,1);% users that chose to depart at departureTimes(i) actually depart between t_mid(i) and t_mid(i+1)
tex_mid=zeros(length(departureTimes)+1,1);% times when a user departing at t_mid pass the bottleneck 
queue=zeros(size(t_mid)); % queue(i) is the queue at time t_mid(i)
tex=zeros(size(departureTimes));

t_mid(2:end)=departureTimes+T/2;
t_mid(1)=departureTimes(1)-T/2;
tex_mid(1)=t_mid(1);

for i=2:length(t_mid)
    queue(i)=max(0,queue(i-1)+w(i-1)-C*T);
    if queue(i)>0 % there was queue all along the interval
        tex_mid(i)=tex_mid(i-1)+w(i-1)/C;
        tex(i-1)=(tex_mid(i)+tex_mid(i-1))/2;
    elseif queue(i-1)==0 % there was no queue at all during the interval
        tex_mid(i)=t_mid(i);
        tex(i-1)=(tex_mid(i)+tex_mid(i-1))/2;
    else % the queue disappeared during the interval
        duration_w_queue=queue(i-1)/(C-w(i-1)/T);
        tex_mid(i)=departureTimes(i-1)+T/2;
        t_avg1=tex_mid(i-1)+duration_w_queue/2;
        t_avg2=tex_mid(i)-(T-duration_w_queue)/2;
        tex(i-1)=t_avg1*duration_w_queue/T+t_avg2*(1-duration_w_queue/T);
    end
end

