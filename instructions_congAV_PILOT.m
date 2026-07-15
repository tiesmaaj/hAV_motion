function instructions_congAV_PILOT(curWindow, cWhite0)

% Instructions 2
Screen('DrawText', curWindow, '...Welcome to this experiment...',500,300,cWhite0);
Screen('DrawText', curWindow, 'This is a motion discrimination task. Your job is to report',300,400,cWhite0);
Screen('DrawText', curWindow, 'if the direction of motion is the SAME between what you see and what you hear',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 3
Screen('DrawText', curWindow, 'On each trial we will present a patch of visual dots and burst of auditory noise.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to indicate the if the direction of motion is the SAME on each trial by',300,400,cWhite0);
Screen('DrawText', curWindow, 'pressing D on the box for different motion directions or S on the box for same motion directions',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 4
Screen('DrawText', curWindow, 'During each trial, a red dot will appear on the center of',300,300,cWhite0);
Screen('DrawText', curWindow, 'the screen. Please FIXATE the red dot,',300,400,cWhite0);
Screen('DrawText', curWindow, 'throughout the trial.',300,500,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 5
Screen('DrawText', curWindow, 'If the motion stimulus is ambiguous, make a decision as best as you can.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Please try to respond as QUICKLY as possible on EACH TRIAL',300,400,cWhite0);
Screen('DrawText', curWindow, '...WE WILL START NOW!...',500,500,cWhite0);
Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;
