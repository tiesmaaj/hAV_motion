%% HUMAN VISUAL MOTION DISCRIMINATION TASK CODE %%%%%%%%%%%%%
% Wallace Multisensory Lab - Vanderbilt University
% written by Kalina Stoyanova - kalina.stoyanova@vanderbilt.edu
% Block for skewing prior 
clear;
close all;
clc;

%% FOR RESPONSE CODING: 1 = RIGHTWARD MOTION; 2 = LEFTWARD MOTION
right_var = 1; left_var = 2; catch_var = 0;

%% Specify parameters of the block
task_nature = 2;
vel_stair = 0;
stim_matching_nature = 3;
selfinit_nature = 0;
all_noise_nature = 0;
training_nature = 0;
aperture_nature = 1;
sliderResp_nature = 0;
sliderResp = NaN;
noise_jitter_nature = 0;
EEG_nature = 0;
outlet = NaN;
visInfo.vel = 20;
data_analysis = 0; 
ExampleMatrix = 0;
OS_nature = 1;

disp('This is the main script for the VISUAL ONLY motion discrimination task.')

%% Directories created to navigate code folders throughout script
[script_directory, data_directory, analysis_directory] = define_directories(OS_nature, EEG_nature);
cd(script_directory)

%% General variables to smoothly run PTB
% Necessary for psychtoolbox to read keyboard inputs. UnifyKeyNames allows
% for portability of script. 
KbName('UnifyKeyNames');
AssertOpenGL;
% Assigned keyboard variables in Linux for left and right arrow keys and extended
% keyboard device. Change depending on what you are using to have
% participants report direction.
right_keypress = [115 13];
left_keypress = [114 12];
space_keypress = [66 14];

%% Define general values how long recording iTis for, might have been poisson distribution
% inputtype, typeInt, minNum, maxNum, and meanNum all deal with the intertrial interval, which
% is generated in the function iti_response_recording. menaNum is the mean
% time in sec that the iti will be. mMn and max time for iti defined by minNum
% and maxNum respectively.
inputtype = 1; typeInt = 1; minNum = 1.5; maxNum = 2.5; meanNum = 2;

%% General stimulus variables
% dur is stimulus duration, triallength is total length of 1 trial (this is
% currently unused in code), Fs is sampling rate, nbblocks is used to divide up num_trials 
% into equal parts to give subject breaks if there are many trials. 
% Set to 0 if num_trials is short and subject does not need break(s).
dur = 0.7; Fs = 44100; triallength = 2; nbblocks = 2; 

% Define buffersize in order to make CAM (auditory stimulus)
silence = 0.03; buffersize = (dur+silence)*Fs;

% All variables that define stimulus repetitions; num_trials defines total
% number of staircase trials, stimtrials defines number of stimulus trials
% per condition for MCS where column 1 is AO, column 2 is VO, and column 3 is AV, 
% catchtrials defines total number of catch trials for MCS.
num_trials = 450; stimtrials = [0, 20, 0]; catchtrials = 20;

% Visual stimulus properties relating to monitor (measure yourself),
% maxdotsframe is for RDK and is a limitation of your graphics card. The2

% only way you can know its limit is by trial and error. Variables monWidth
% and viewDist are measured in centimeters. Speaker distance in degrees,
% measured from center of one speaker to center of the other. Because
% speakerDistance = 29.4 and dur = 0.5, auditory velocity if not otherwise 
% specified is 58.8 deg/s. maxVel is maximum velocity that can be presented
% as an auditory stimulus with a 0.5 sec dur.
maxdotsframe = 150; monWidth = 50.8; viewDist = 120; audInfo.speakerDistance = 29.4;
audInfo.maxVel = audInfo.speakerDistance/dur;

% General drawing color used for RDK, instructions, etc.
cWhite0 = 255; fixation_color = [255 0 0];

%% Collect subject information
% Block is set to skewVis to denote skewed trial section. Function
% collect_subject_information then prompts you to fill in numbers for
% subject that will allow you to uniquely identify subjects. Variable
% filename will be also used as the save_name, so be sure to remember in
% order to access later.
block = 'RDKHoop_skewVis';
[filename, subjnum_s, group_s, sex_s, age_s] = collect_subject_information(block);
skew_direction = input('Leftward (1) or rightward (2) skew? ');
experiment_type = input('Interleaved (1) or blocked (2)? ');

%% Coherence and trial matrix generation for Staircase and MCS
if task_nature == 2
    if stim_matching_nature == 1
        % Create coherences for participant if method of constant stimuli is to be
        % used. Coherences genereated via the same participant's staircase
        % performance. Matrix generation is randomized and determined by the number
        % of stimtrials per condition and number of catchtrials.
        % Load the visual staircase datac
        stairVis_filename = sprintf('RDKHoop_%s_%s_%s_%s_%s.mat', block, subjnum_s, group_s, sex_s, age_s);
        try
            % Load the staircase data from same participant to generate
            % coherences
            cd(data_directory)
            load(horzcat(data_directory, stairVis_filename), 'data_output');
            cd(script_directory)
    
            % Generate stimulus coherence levels based on staircase, manipulate stim coherences
            % generated by coherence_calc by changing variables in the function
            [visInfo] = coherence_calc(data_output);
    
            clear("data_output")
        catch
            warning('Problem finding staircase data for participant. Assigning general coherences for MCS.');
            cd(script_directory)
            % Generate the list of possible coherences by decreasing log values
            visInfo.cohStart = 0.5;
            visInfo.nlog_coh_steps = 8;
            visInfo.nlog_division = sqrt(2);
            visInfo = cohSet_generation(visInfo, block);
        end
    
        % Create trial matrix
        rng('shuffle')
        if ExampleMatrix == 1
            data_output = at_generateExampleMatrix(block);
        else
            data_output = at_generateMatrix(catchtrials, stimtrials, visInfo, right_var, left_var, catch_var);
        end
    elseif stim_matching_nature == 3
        % Induction phase (phase A): first 360 trials, 100% coherence, 80/20 skew by direction
        audInfo.cohSet = 1.0;
        visInfo.cohSet = 1.0;                       % 100% coherence
        L_stimtrials = [0, 0, 0];                   % [AO, VO, AV]
        R_stimtrials = [0, 0, 0];
        if skew_direction == 1                      % 1 = Left-biased (80/20)
            L_stimtrials(2) = 288;                  % Left trials in VO
            R_stimtrials(2) = 72;                   % Right trials in VO
        elseif skew_direction == 2                  % 2 = Right-biased (80/20)
            L_stimtrials(2) = 72;
            R_stimtrials(2) = 288;
        end
        phaseA = at_generateMatrixSKEW(0, 0, 0, 0, 0, L_stimtrials, R_stimtrials, audInfo, visInfo, right_var, left_var, catch_var, 0);
        rng('shuffle'); phaseA = phaseA(randperm(size(phaseA,1)), :);
    
        % Test phase (phase B): next 90 trials, randomized coh/direction + 10 catch
        audInfo.cohSet = [0.05, 0.10, 0.20, 0.40];
        visInfo.cohSet = [0.05, 0.10, 0.20, 0.40];  % 4 coherences
        stimtrials = [0, 10, 0];                    % 10 per coherence per direction (VO)
        catchtrials = 10;                           % +10 catch trials
        phaseB = at_generateMatrixALL(catchtrials, 0, 0, stimtrials, audInfo, visInfo, right_var, left_var, catch_var, 0);
        rng('shuffle'); phaseB = phaseB(randperm(size(phaseB,1)), :);
    
        % Create a blocked or interleaved condition      
        if experiment_type == 2 % blocked condition (skewed trials first)
            data_output = [phaseA; phaseB];

        elseif experiment_type == 1 % interleaved condition (skew and probe trials randomly alternate)
            nA = size(phaseA,1);   % should be 360
            nB = size(phaseB,1);   % should be 90
            schedule = [ones(nA,1); zeros(nB,1)];          % 1 = phaseA, 0 = phaseB
            schedule = schedule(randperm(numel(schedule))); % random interleave
        
            data_output = zeros(length(schedule), size(phaseA,2));
        
            a_idx = 1;
            b_idx = 1;
            for k = 1:length(schedule)
                     if schedule(k) == 1
                    data_output(k,:) = phaseA(a_idx,:);
                    a_idx = a_idx + 1;
                else
                    data_output(k,:) = phaseB(b_idx,:);
                    b_idx = b_idx + 1;
                end
            end
        end

    end
else
    error('Could not generate coherences. Task nature determines how coherences are generated.')
end

% if nbblocks > 0
%     [tt] = breaktime_var(data_output, nbblocks);
% end
% Override breaks to occur every 90 trials (5 blocks total)
tt = [90 180 270 360];
nbblocks = 5;

%% Initialize
% curScreen = 0 if there is only one monitor. If more than one monitor, 
% check display settings on PC. curScreen will probably equal 1 or 2 
% (e.g. monitor for stimulus presentation and monitor to run MATLAB code).
curScreen = 0;

% Opens psychtoolbox and initializes experiment
[screenInfo, curWindow, screenRect, xCenter, yCenter] = initialize_exp(monWidth, viewDist, curScreen);

%% Initialize Audio for Feedback
if training_nature == 1
    % Training sound properties
    correct_freq = 1046.5; incorrect_freq = 783.99; % musical notes C, G
    % Generate tones for correct and incorrect responses
    [corr_soundout, incorr_soundout] = at_generateBeep(correct_freq, incorrect_freq, dur, silence, Fs);
    % Open a pahandle
    [pahandle] = initialize_aud(curWindow, Fs);
end

%% Welcome and Instrctions for the Suject
% Opens psychtoolbox instructions for participant for the specific task 
% (psyVis for all visual tasks, psyAud for all auditory only tasks, psyAV 
% for all audiovisual tasks). trainAud and trainVis have separate instructions.
if training_nature == 1
    instructions_trainVis(curWindow, cWhite0, pahandle, corr_soundout, incorr_soundout);
else
    instructions_psyVis(curWindow, cWhite0);
end

%% Stimulus Matching Across Modalities
% Generate and present a slider for participant to subjectively match
% coherence across modalities
if stim_matching_nature == 2
    % Generate a slider for the participant to respond to
    [visInfo, StopPixel_M] = at_generateSlider(visInfo, right_keypress, left_keypress, space_keypress, curWindow, cWhite0, xCenter, yCenter);
end
% Match the computed auditory displacement for a given velocity given dur
% to the size of the visual aperture.
if aperture_nature == 1
    [audInfo, visInfo] = at_generateApertureInfo(audInfo, visInfo, dur);
else
    visInfo.displaceSet = aperture_size;
end

%% Flip up fixation dot
[fix, s] = at_presentFix(screenRect, curWindow);

%% Experiment Loop
% Loop through every trial.
for ii = 1:length(data_output)

    %% Allows participant to self initiate each trial
    if selfinit_nature == 1
         instructions_InitTrial(curWindow, cWhite0, fix, data_output);
    end
    
    if task_nature == 2
        % Stimulus direction and coherence for a given trial is pre
        % determined via the output of at_generateMatrix.
        visInfo.dir = data_output(ii, 1);
        visInfo.coh = data_output(ii, 2);
    end

    % Necessary variable changing for RDK code. 1 = RIGHT, which is 0 
    % degrees on unit circle, 2 = LEFT, which is 180 degrees on unit circle
    visInfo = direction_conversion(visInfo);

    %% Create info matrix for Visual Stim. 
    % This dotInfo  output informs at_dotGenerate how to generate the RDK. 
    dotInfo = at_createDotInfo(inputtype, visInfo.coh, visInfo.dir, typeInt, ...
        minNum, maxNum, meanNum, maxdotsframe, dur, visInfo.vel, visInfo.displaceSet);
    
    %% Keypress input initialize variables, define frames for presentation
    while KbCheck; end
    keycorrect = 0;
    keyisdown = 0;
    responded = 0; %DS mark as no response yet
    resp = nan; %default response is nan
    rt = nan; %default rt in case no response is recorded

    % Create marker for EEG
    [markers] = at_generateMarkers(data_output, ii, EEG_nature, block);

    %% Dot Generation.
    % This function generates the dots that will be presented to
    % participant in accordance with their coherence, direction, and other dotInfo.
    [center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show] = at_generateDot(visInfo, dotInfo, screenInfo, screenRect, monWidth, viewDist, maxdotsframe, dur, curWindow, fix);
    
    %% Dot Presentation
    % This function uses psychtoolbox to present dots to participant.
    [resp, rt, start_time] = at_presentDot(visInfo, dotInfo, center, dotSize, d_ppd, ndots, dxdy, ss, Ls, continue_show, curWindow, fix, responded, resp, rt, EEG_nature, outlet, markers);

    %% Erase last dots & go back to only plotting fixation
    Screen('DrawingFinished',curWindow);
    Screen('DrawDots', curWindow, [0; 0], 10, [255 0 0], fix, 1);
    Screen('Flip', curWindow,0);
    
    %%  ITI & response recording
    [resp, rt] = iti_response_recording(typeInt, minNum, maxNum, meanNum, dur, start_time, keyisdown, responded, resp, rt);
    
    %% Direction conversion
    visInfo = direction_conversion(visInfo);

    %% Save data into data_output on a trial by trial basis
    [trial_status, data_output] = record_data(data_output, right_var, left_var, right_keypress, left_keypress, visInfo, resp, rt, ii, vel_stair, sliderResp);

    %% Present stimulus feedback if requested
    if training_nature == 1
        at_presentFeedback(trial_status, pahandle, corr_soundout, incorr_soundout);
    end

    %% Check if it is break time for participant
    if nbblocks > 0
        if ismember(ii, tt) == 1
            breaks = ii == tt;
            break_num = find(breaks);
            % Participant can take break given amount of blocks specified in nbblocks
            takebreak(curWindow, cWhite0, fix, break_num, nbblocks) 
        end
    end

end

%% Goodbye
cont(curWindow, cWhite0);

%% Finalize 
% Close psychtoolbox window
closeExperiment;
close all
Screen('CloseAll')

%% Data Analysis
cd(data_directory)
save(filename)

group_s = str2double(group_s);
group_s_new = group_s + 1;
group_s_new = num2str(group_s_new);
underscore = '_';
new_filename = strcat(block, underscore, subjnum_s, underscore, group_s_new, underscore, sex_s, underscore, age_s);
save(new_filename)
