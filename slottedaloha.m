function [throughput,meanDelay,trafficOffered,pcktCollisionProb] = slottedaloha(sourceNumber,packetReadyProb,maxBackoff,simulationTime)
%---------------Function inputs----------
% sourceNumber : number of sources
% packetReadyProb : probability that a given sources has a new packet and
%                   ready to be transmitted at a given time slot
% maxBackoff : time that a backlogged source must wait (in time slot)
%               before a new transmission attempt
% simulationTime : duration of simulation (in time slot)


%---------------Function outputs---------
% throughput: total packet acknowledged / simulation time
% mean delay: the average delay (in slots) for a packet to be successfully
%        transmitted (acknowledge) from the moment it is ready at the source
% traffic offered: normalized traffic offered to the system,including
%        retransmissions
% packet collision probability: probability that a packet collides with others
%        at any given time slot

sourceStatus = zeros(1,sourceNumber);
% 0: source has no packet ready to be transmitted (is idle)
% 1: source has a packet ready to be transmitted, either because new data must be sent or a previously collided packet has waited the backoff time
% >1: source is backlogged due to previous packets collision, the value of the status equals the number of slots it must wait for the next transmission attempt
sourceBackoff = zeros(1,sourceNumber);
pcktTransmissionAttempts = 0;
ackdPacketDelay = zeros(1,simulationTime);
ackdPacketCount = 0;
pcktCollisionCount = 0;
pcktGenerationTimestamp = zeros(1,sourceNumber);
currentSlot = 0;

while currentSlot < simulationTime
    currentSlot = currentSlot + 1;

    for eachSource1 = 1:length(sourceStatus)
        if sourceStatus(1,eachSource1) == 0 && rand(1) <= packetReadyProb % new packet
            sourceStatus(1,eachSource1) = 1;
            sourceBackoff(1,eachSource1) = randi(maxBackoff,1);
            pcktGenerationTimestamp(1,eachSource1)=currentSlot;
        elseif sourceStatus(1,eachSource1)==1 % backlogged packet
            sourceBackoff(1,eachSource1)=randi(maxBackoff,1);
        end
    end

    pcktTransmissionAttempts = pcktTransmissionAttempts + sum(sourceStatus == 1);

    if sum(sourceStatus == 1) == 1
        ackdPacketCount = ackdPacketCount + 1;
        [~,sourceId] = find(sourceStatus == 1);
        ackdPacketDelay(ackdPacketCount) = currentSlot - pcktGenerationTimestamp(sourceId);
    elseif sum(sourceStatus == 1) > 1
        pcktCollisionCount = pcktCollisionCount + 1;
        sourceStatus  = sourceStatus + sourceBackoff;
    end

    sourceStatus = sourceStatus - 1; % decrease backoff interval
    sourceStatus(sourceStatus < 0) = 0; % idle sources stay idle (see permitted statuses above)
    sourceBackoff = zeros(1,sourceNumber);
end

trafficOffered = pcktTransmissionAttempts / currentSlot;
if ackdPacketCount == 0
    meanDelay = simulationTime; % theoretically, if packets collide continously, the delay tends to infinity
else
    meanDelay = mean(ackdPacketDelay(1:ackdPacketCount));
end
throughput = ackdPacketCount / currentSlot;
pcktCollisionProb = pcktCollisionCount / currentSlot;