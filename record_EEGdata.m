function [data_output] = record_EEGdata(data_output, right_var, left_var, congruent_keypress, incongruent_keypress, audInfo, visInfo, resp, rt, ii, cong_var, incong_var, markers)

%% Save data to the initialized data_output matrix
% Each row is a trial
%
% Column 1 = direction of trial, 1 = right, 2 = left
% Column 2 = coherence of trial, 0 = 0% coherence, 0.5 = 50% coherence, etc.
% Column 3 = subject reported direction of trial, 1 = right, 2 = left
% Column 4 = subject reaction time of trial, reported in seconds
% Column 5 = subject character press, number denotes key pressed
% Column 6 = whether subject was correct (1) or incorrect (0) for trial
% Column 7 = velocity of trial (in deg/sec)

data_output(ii, 1) = audInfo.dir;
data_output(ii, 2) = audInfo.coh;
data_output(ii, 3) = visInfo.dir;
data_output(ii, 4) = visInfo.coh;
if ismember(resp, congruent_keypress)
    data_output(ii, 5) = cong_var;
elseif ismember(resp, incongruent_keypress)
    data_output(ii, 5) = incong_var;
else
    data_output(ii, 5) = nan;
end
data_output(ii, 6) = rt;
data_output(ii,7) = char(resp);
%column 8 is EEG marker name
markers_num = str2double(markers);
if isempty(markers_num)
    markers_num = 0;
end
data_output(ii,8) = markers_num;

end