function [data_output] = at_generateMatrix_2IFC(catchtrials, congruent_mstrials, incongruent_mstrials, stimtrials, audInfo, visInfo, right_var, left_var, catch_var, cued_nature)
% Adam J. Tiesman - 1/24/24
% Revised version for 2IFC AV trials matrix generation
% Each row = a trial, columns 1-4 = first interval stimulus info, 5-8 = second interval stimulus info
% Column 9 = participant response (1 = first interval, 2 = second interval), Column 10 = reaction time (initialized to 0)

% Catch trials
catchs = [catch_var, catch_var, catch_var, catch_var];
catchmat = repmat(catchs, catchtrials, 1);

% Prepare congruent and incongruent stimulus trials (for AV stimuli)
AV_r_cong_trials = zeros(congruent_mstrials * length(audInfo.cohSet), 4);
AV_l_cong_trials = zeros(congruent_mstrials * length(audInfo.cohSet), 4);
AV_rA_incong_trials = zeros(incongruent_mstrials * length(audInfo.cohSet), 4);
AV_lA_incong_trials = zeros(incongruent_mstrials * length(audInfo.cohSet), 4);

% Populate congruent and incongruent trials
for i = 1:length(audInfo.cohSet)
    cohAud = audInfo.cohSet(i);
    cohVis = visInfo.cohSet(i);

    % Congruent trials
    AV_r_cong_trials((i-1)*congruent_mstrials+1:i*congruent_mstrials, :) = ...
        [repmat([right_var, cohAud, right_var, cohVis], congruent_mstrials, 1)];
    AV_l_cong_trials((i-1)*congruent_mstrials+1:i*congruent_mstrials, :) = ...
        [repmat([left_var, cohAud, left_var, cohVis], congruent_mstrials, 1)];

    % Incongruent trials
    AV_rA_incong_trials((i-1)*incongruent_mstrials+1:i*incongruent_mstrials, :) = ...
        [repmat([right_var, cohAud, left_var, cohVis], incongruent_mstrials, 1)];
    AV_lA_incong_trials((i-1)*incongruent_mstrials+1:i*incongruent_mstrials, :) = ...
        [repmat([left_var, cohAud, right_var, cohVis], incongruent_mstrials, 1)];
end

% Combine all trials (catch + AV congruent + AV incongruent)
all_trials = [catchmat; AV_l_cong_trials; AV_r_cong_trials; AV_rA_incong_trials; AV_lA_incong_trials];

% Randomize trials
rng('shuffle');
nbtrials = size(all_trials, 1);
order = randperm(nbtrials);
trialOrder = all_trials(order, :);

% Initialize additional columns (response, reaction time)
resp = zeros(nbtrials, 1); % Response left or right (1 = first interval, 2 = second interval)
rt = zeros(nbtrials, 1); % Reaction time
keys = zeros(nbtrials, 1); % Keypress value
trial_status = zeros(nbtrials, 1); % Trial correctness

% Generate final output matrix
if cued_nature
    % If cued nature is set, add cued variable to each trial
    auditory_cue = 1; visual_cue = 2; audiovisual_cue = 3; no_cue = 0;
    cues = [auditory_cue, visual_cue, audiovisual_cue, no_cue];
    catchmat(:, 5) = no_cue;
    AV_l_cong_loop_length = length(AV_l_cong_trials)/length(cues);
    for i = 1:AV_l_cong_loop_length
        AV_l_cong_trials(4*i-3,5) = auditory_cue;
        AV_l_cong_trials(4*i-2,5) = visual_cue;
        AV_l_cong_trials(4*i-1,5) = audiovisual_cue;
        AV_l_cong_trials(4*i,5) = no_cue;
    end
    AV_r_cong_loop_length = length(AV_r_cong_trials)/length(cues);
    for i = 1:AV_r_cong_loop_length
        AV_r_cong_trials(4*i-3,5) = auditory_cue;
        AV_r_cong_trials(4*i-2,5) = visual_cue;
        AV_r_cong_trials(4*i-1,5) = audiovisual_cue;
        AV_r_cong_trials(4*i,5) = no_cue;
    end
    AV_lA_incong_loop_length = length(AV_lA_incong_trials)/length(cues);
    for i = 1:AV_lA_incong_loop_length
        AV_lA_incong_trials(4*i-3,5) = auditory_cue;
        AV_lA_incong_trials(4*i-2,5) = visual_cue;
        AV_lA_incong_trials(4*i-1,5) = audiovisual_cue;
        AV_lA_incong_trials(4*i,5) = no_cue;
    end
    AV_rA_incong_loop_length = length(AV_rA_incong_trials)/length(cues);
    for i = 1:AV_rA_incong_loop_length
        AV_rA_incong_trials(4*i-3,5) = auditory_cue;
        AV_rA_incong_trials(4*i-2,5) = visual_cue;
        AV_rA_incong_trials(4*i-1,5) = audiovisual_cue;
        AV_rA_incong_trials(4*i,5) = no_cue;
    end
    % Add no cue to other trial types
    A_l_trials(:, 5) = no_cue;
    A_r_trials(:, 5) = no_cue;
    V_l_trials(:, 5) = no_cue;
    V_r_trials(:, 5) = no_cue;
end

% Create final output matrix
data_output = [trialOrder(:,1:4), trialOrder(:,1:4), resp, rt, keys, trial_status]; % Columns 1-8 = first and second interval, 9 = response, 10 = rt

end