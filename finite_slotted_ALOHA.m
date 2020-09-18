clear all; close all; clc;
i=1;
for sourceNumber=[10, 25, 50]
    j=1;
    for lambda=[0:0.2:8]
        simulationTime=1e5;
        sourceStatus = zeros(1,sourceNumber);
        % 0: idle source
        % 1: active
        attemptSource = 0;
        pcktTransmissionAttempts = 0;
        %nodeDelay = zeros(1, sourceNumber);
        %sumDelay=0;
        ackdPacketCount = 0;
        pcktCollisionCount = 0;
        currentSlot = 0;
        pr=lambda/sourceNumber;
        %fileID = fopen('lambda5.txt','w');
        
        while currentSlot < simulationTime
            currentSlot = currentSlot + 1;
            %fprintf(fileID, 'slot = %i \n', currentSlot);
            transmissionAttemptsEachSlot = 0;
            for source = 1:sourceNumber
                if sourceStatus(source) == 0 && rand(1) <= pr % new packet
                    sourceStatus(source) = 1;
                    %nodeDelay(source)=0;
                    transmissionAttemptsEachSlot = transmissionAttemptsEachSlot+1;
                    pcktTransmissionAttempts = pcktTransmissionAttempts+1;
                    attemptSource = source;
                    %fprintf(fileID, 'station %d is transmitting new packet \n', source);
                elseif sourceStatus(source)==1 % active packet
                    %nodeDelay(source) = nodeDelay(source)+1;
                    if rand(1) <= pr
                        transmissionAttemptsEachSlot = transmissionAttemptsEachSlot+1;
                        pcktTransmissionAttempts = pcktTransmissionAttempts+1;
                        attemptSource = source;
                        %fprintf(fileID, 'station %d is transmitting backlogged packet \n', source);
                    end
                end
            end
            
            if transmissionAttemptsEachSlot == 1
                ackdPacketCount = ackdPacketCount + 1;
                %sumDelay = sumDelay+nodeDelay(attemptSource);
                sourceStatus(attemptSource) = 0;
                %fprintf(fileID, 'station %d packet is successfull with delay %d \n', attemptSource, nodeDelay(attemptSource));
            elseif transmissionAttemptsEachSlot>1
                pcktCollisionCount = pcktCollisionCount+1;
                %fprintf(fileID, 'COLLISION Happens \n');
            end
        end
        
        trafficOffered(i,j) = pcktTransmissionAttempts / currentSlot;
        %     if ackdPacketCount == 0
        %         meanDelay = simulationTime; % theoretically, if packets collide continously, the delay tends to infinity
        %     else
        %         meanDelay = sumDelay/ackdPacketCount;
        %     end
        throughput(i,j) = ackdPacketCount / currentSlot;
        pcktCollisionProb(i,j) = pcktCollisionCount / currentSlot;
        %fclose(fileID);
        j=j+1
    end
    i=i+1
end
%% plot
figure(1)
plot(trafficOffered(1,:),throughput(1,:), '-x')
title('Average Throughput of Finite-Station Slotted ALOHA')
xlabel('G (Offered Traffic)')
ylabel('Average Throughput')
hold on;
G=[0:0.2:8];
S=G.*(1-G/10).^(10-1);
plot(G,S);
hold on;
plot(trafficOffered(2,:),throughput(2,:), '-s')
hold on;
S=G.*(1-G/25).^(25-1);
plot(G,S);
hold on;
plot(trafficOffered(3,:),throughput(3,:), '-o')
hold on;
S=G.*(1-G/50).^(50-1);
plot(G,S);
legend('simulation, M=10', 'analytical, M=10','simulation, M=25', 'analytical, M=25', 'simulation, M=50', 'analytical, M=50');
grid on

figure(2)
plot(trafficOffered(1,:),pcktCollisionProb(1,:), '-x')
title('Collision Probability of Finite-Station Slotted ALOHA')
xlabel('G (Offered Traffic)')
ylabel('Collision Prob')
hold on;
G=[0:0.2:8];
S=1-G.*(1-G/10).^(10-1)-(1-G/10).^(10);
plot(G,S);
hold on;
plot(trafficOffered(2,:),pcktCollisionProb(2,:), '-s')
hold on;
S=1-G.*(1-G/25).^(25-1)-(1-G/25).^(25);
plot(G,S);
hold on;
plot(trafficOffered(3,:),pcktCollisionProb(3,:), '-o')
hold on;
S=1-G.*(1-G/50).^(50-1)-(1-G/50).^(50);
plot(G,S);
legend('simulation, M=10', 'analytical, M=10','simulation, M=25', 'analytical, M=25', 'simulation, M=50', 'analytical, M=50');
grid on