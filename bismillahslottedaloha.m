function [throughput,meanDelay,trafficOffered,pcktCollisionProb] = bismillahslottedaloha(lambda,simulationTime)
sourceNumber = 100;
sourceStatus = zeros(1,sourceNumber);
% 0: idle source
% 1: active
attemptSource = 0;
pcktTransmissionAttempts = 0;
nodeDelay = zeros(1, sourceNumber);
sumDelay=0;
ackdPacketCount = 0;
pcktCollisionCount = 0;
currentSlot = 0;
p=0.1;
pr=1-exp(-lambda/sourceNumber);
fileID = fopen('lambda5.txt','w');

while currentSlot < simulationTime
    currentSlot = currentSlot + 1;
    fprintf(fileID, 'slot = %i \n', currentSlot);
    transmissionAttemptsEachSlot = 0;
    for source = 1:sourceNumber
        if sourceStatus(source) == 0 && rand(1) <= pr % new packet
            sourceStatus(source) = 1;
            nodeDelay(source)=0;
            transmissionAttemptsEachSlot = transmissionAttemptsEachSlot+1;
            pcktTransmissionAttempts = pcktTransmissionAttempts+1;
            attemptSource = source;
            fprintf(fileID, 'station %d is transmitting new packet \n', source);
        elseif sourceStatus(source)==1 % active packet
            nodeDelay(source) = nodeDelay(source)+1;
            if rand(1) <= pr
                transmissionAttemptsEachSlot = transmissionAttemptsEachSlot+1;
                pcktTransmissionAttempts = pcktTransmissionAttempts+1;
                attemptSource = source;
                fprintf(fileID, 'station %d is transmitting backlogged packet \n', source);
            end
        end
    end

    if transmissionAttemptsEachSlot == 1
        ackdPacketCount = ackdPacketCount + 1;
        sumDelay = sumDelay+nodeDelay(attemptSource);
        sourceStatus(attemptSource) = 0;
        fprintf(fileID, 'station %d packet is successfull with delay %d \n', attemptSource, nodeDelay(attemptSource));
    elseif transmissionAttemptsEachSlot>1
        pcktCollisionCount = pcktCollisionCount+1;
        fprintf(fileID, 'COLLISION Happens \n');
    end
end

trafficOffered = pcktTransmissionAttempts / currentSlot;
if ackdPacketCount == 0
    meanDelay = simulationTime; % theoretically, if packets collide continously, the delay tends to infinity
else
    meanDelay = sumDelay/ackdPacketCount;
end
throughput = ackdPacketCount / currentSlot;
pcktCollisionProb = pcktCollisionCount / currentSlot;
fclose(fileID);
end