traffic=zeros(1,28);
tp=zeros(1,28);
collision=zeros(1,28);
delay=zeros(1,28);
i=1;
lambda=0;
while lambda<5
 [throughput,meanDelay, trafficOffered,pcktCollisionProb]=bismillahslottedaloha(lambda, 100000);  
    collision(i) = pcktCollisionProb;
    delay(i)=meanDelay;
    traffic(i)=trafficOffered;
    tp(i)=throughput;
    i=i+1;
    lambda=lambda+0.1
end

figure(1);
%subplot(3,1,1);
plot(traffic,tp, '-o');
title('throughput vs offered load');
xlabel('offered load');
ylabel('throughput');
hold on;

% Analytical Throughput of slotted ALOHA

L=0:0.1:5;
S=L.*exp(-L);
plot(L,S);
legend('simulation', 'analytical');


figure(2);
%subplot(3,1,2);
plot(delay(2:51), tp(2:51), '-o');
title('throughput vs mean delay');
xlabel('mean delay');
ylabel('throughput');
hold on;

% Analytical mean delay of markov chain slotted aloha
pr=L/100;
D=1-(1./pr)+(100./S);
plot(D,S);
legend('simulation', 'analytical');

figure(3);
%subplot(3,1,3);
plot(traffic, collision, '-o');
title('collision probability vs offered load');
xlabel('offered load');
ylabel('collision probability');
hold on;

% Analytical collision probability
probOfCollision = 1-exp(-L)-L.*exp(-L);
plot(L,probOfCollision);
legend('simulation', 'analytical');


