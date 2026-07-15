function instructions_EEG(curWindow, cWhite0)

% Instructions 2
Screen('DrawText', curWindow, '...Welcome to this motion experiment...',500,300,cWhite0);
Screen('DrawText', curWindow, 'Press any key to continue...',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;

% Instructions 3
Screen('DrawText', curWindow, 'On each trial we will present a patch of visual dots and/or a burst of auditory noise.',300,300,cWhite0);
Screen('DrawText', curWindow, 'Your task is to REMAIN STILL and LIMIT EYE BLINKS while paying attention to the stimulus ',300,400,cWhite0);
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
Screen('DrawText', curWindow, 'There will be ample breaks to rest your eyes and adjust your position',500,500,cWhite0);
Screen('DrawText', curWindow, 'WHEN YOU ARE READY: PRESS ANY KEY TO START THE EXPERIMENT.',300,650,cWhite0);
Screen('Flip',curWindow);
keytest_unbound;
