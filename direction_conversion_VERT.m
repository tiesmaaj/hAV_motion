function [stimInfo] = direction_conversion_VERT(stimInfo)
% Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
% degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle

if stimInfo.dir == 1
    stimInfo.dir = 90; % Rightward conversion before RDK is generated for trial
elseif stimInfo.dir == 2
    stimInfo.dir = 270; % Leftward conversion before RDK is generated for trial
elseif stimInfo.dir == 90 
    stimInfo.dir = 1; % Rightward conversion after RDK is generated for trial
elseif stimInfo.dir == 270
    stimInfo.dir = 2; % Leftward conversion after RDK is generated for trial
end

end