clear all;close all; clc;

T = 1e6; % simulation time
load_scale = 0.1; % step size
G = 0:load_scale:18; % this is the offered load
request = zeros(T+1, length(G)); % create 3D matrix with size = [simulation time, channel, offered load)
slotted_ALOHA_success = zeros(1,length(G));
slotted_ALOHA_collision = zeros(1,length(G));

for g = 1:length(G) % iterate at each offered load
    request(:,g) = poissrnd(G(g),T+1,1); % the number of requests at an instant offered load at all time
end
for g = 1:length(G)
    for t = 1:T
        if request(t, g) == 1
            slotted_ALOHA_success(g) = slotted_ALOHA_success(g) + 1;
        end
        if request(t, g) > 1
            slotted_ALOHA_collision(g) = slotted_ALOHA_collision(g) + 1;
        end
    end
end

%% calculate
% slotted ALOHA
S_slotted_ALOHA = slotted_ALOHA_success / T;
collision_prob =  slotted_ALOHA_collision /T;
%% plot
% slotted
figure(1)
plot(G,S_slotted_ALOHA, '-x')
title('Average Throughput of Slotted ALOHA')
xlabel('G')
ylabel('Average Throughput')

hold on;
S=G.*exp(-G);
plot(G,S);
legend('simulation', 'analytical');
grid on

figure(2)
plot(G,collision_prob, '-s')
title('Collision Probability of Slotted ALOHA')
xlabel('G')
ylabel('Collision Probability')

hold on;
collision_prob_ana=1-exp(-G)-G.*exp(-G);
plot(G,collision_prob_ana);
legend('simulation', 'analytical');
grid on