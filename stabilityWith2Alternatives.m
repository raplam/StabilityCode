clear all
close all
path(genpath(cd),path);
path(genpath('C:\Users\rlamotte\Documents\PhD\Matlab\simulations\github'),path);

set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultTextInterpreter','latex');

%% Illustrations of my analytical results
N=1;
n1=0:N/1000:N;

% N<2S\delta t
S=0.6;
T1=max(0,(n1-S)/(2*S));
T2=(n1<N-S).*(N-n1-S)/(2*S)+(n1>S).*(n1-S)./(S-N+n1).*(n1-S)/(2*S);

figure
subplot(121)
plot(n1,T1);
hold on
plot(n1,T2);
plot(n1,T2-T1);
title('$N<2S\delta t$')
legend({'$T_1$','$T_2$','$T_2-T_1$'});
% N>2S\delta t
S=0.4;
T1=max(0,(n1-S)/(2*S));
T2=(n1<S).*(N-n1-S)/(2*S)+(n1>=S).*(N+n1-3*S)/(2*S);

subplot(122)
plot(n1,T1);
hold on
plot(n1,T2);
plot(n1,T2-T1);
title('$N>2S\delta t$')
legend({'$T_1$','$T_2$','$T_2-T_1$'});


%% Numerical investigations
S=0.6;
departureTimes=[0.5,1.5];
ud0=0;
ud1=1.02;
population=generateSPlinear(ud0,ud1);
T1=zeros(size(n1));
T2=zeros(size(n1));
U1=zeros(size(n1));
U2=zeros(size(n1));
for i=1:length(n1)
    [Utilities,tin,queue,avgArrivalTimes,cumUsers]=BottleneckDynamicsAndUtilityEvaluation(departureTimes,[n1(i),N-n1(i)],S,population);
    T1(i)=avgArrivalTimes(1)-departureTimes(1);
    T2(i)=avgArrivalTimes(2)-departureTimes(2);
    U1(i)=Utilities(1);
    U2(i)=Utilities(2);
end
figure
subplot(121)
plot(n1,T1);
hold on
plot(n1,T2);
plot(n1,T2-T1);
title('$N<2S\delta t$')
legend({'$T_1$','$T_2$','$T_2-T_1$'});

subplot(122);
plot(n1,U1-U2);
