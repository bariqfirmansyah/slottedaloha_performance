clear all
clc
traffic=zeros(1,28);
tp=zeros(1,28);
delay=zeros(1,28);
collision=zeros(1,28);
i=1;
backoff=15000;
while backoff>30
[throughput,meanDelay,trafficOffered,pcktCollisionProb]=slottedaloha(100,0.0057,backoff,2000);
    if backoff>1000
        backoff=backoff-2000;
    elseif backoff>100
        backoff=backoff-100;
    elseif backoff>50
        backoff=backoff-10;
    else
        backoff=backoff-3;
    end
    
    collision(i) = pcktCollisionProb;
    delay(i)=meanDelay;
    traffic(i)=trafficOffered;
    tp(i)=throughput;
    i=i+1;
end

subplot(3,1,1);
plot(traffic,tp, '-o');
hold on;

% Analytical Throughput of slotted ALOHA

L=0:0.1:5;
T=L.*exp(-L);
plot(L,T);
title('Slotted ALOHA Protocol');
xlabel('traffic load');
ylabel('corresponding throughput');

subplot(3,1,2);
semilogx(delay, tp);
xlabel('mean delay');
ylabel('corresponding throughput');

subplot(3,1,3);
plot(traffic, collision);
xlabel('traffic offered');
ylabel('collision probability');
