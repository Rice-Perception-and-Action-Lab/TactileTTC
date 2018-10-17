KbName('UnifyKeyNames');
responseKeys = {'1'}; %num pad only for QWERTY use 1!,2@,3# etc..     

prompt = {'Enter subject number:'}; %description of fields
defaults = {''};%you can put in default responses
answer = inputdlg(prompt, 'Subject Number',1.2,defaults); %opens dialog
SUBJECT = answer{1,:}; %Gets Subject Name
resultsFolder = 'data';
outputfile = fopen([resultsFolder '/data_' num2str(SUBJECT) '.txt'],'wt+');
fprintf(outputfile, 'SUBJECT\t TRIAL\t VEL\t TTC\t RT\n'); 

%START TO READ ORDER.TXT FILE

filename = 'order.txt';%%%%%%%%%
M = dlmread(filename,'',1,0); %Read input to M
numTrials = length(M);

%numTrials = 1;
%END OF READ ORDER.TXT FILE



PsychDefaultSetup(2);
Screen('Preference', 'VisualDebuglevel', 1);
Screen('Preference', 'Verbosity', 2);

HideCursor();
[window, rect]=Screen('OpenWindow',0);  % open screen


% Choosing the display with the highest display number is
% a best guess about where you want the stimulus displayed.
screens=Screen('Screens');
screenNumber=max(screens);

% Open window with default settings:
w=Screen('OpenWindow', screenNumber);

%START TO MAKE TEXTURES
[img1, ~, ~] = imread('welcome.png');
texture_welcome = Screen('MakeTexture', w, img1);
[img2, ~, ~] = imread('Instruction1.png');
texture_instr1 = Screen('MakeTexture', w, img2);
[img3, ~, ~] = imread('continue.png');
texture_continue = Screen('MakeTexture', w, img3);
[img4, ~, ~] = imread('cross.png');
texture_cross = Screen('MakeTexture', w, img4);
[img5, ~, alpha] = imread('thank.png');
texture_thank = Screen('MakeTexture', w, img5);
%END OF MAKE TEXTURES


smImSq = [0 0 250 250];
[smallIm, xOffsetsigS, yOffsetsigS] = CenterRect(smImSq, rect);

%BEGIN EXPERIMENT
%SHOW WELCOME SCREEN
Screen('DrawTexture', w, texture_welcome, [], smallIm);
Screen('Flip', w);
KbStrokeWait;

Screen('DrawTexture', w, texture_instr1, [], smallIm);
Screen('Flip', w);
KbStrokeWait;    

Screen('DrawTexture', w, texture_continue, [], smallIm);
Screen('Flip', w);
KbStrokeWait;


for i = 1:numTrials 
    %-----play the trial--
    rt = 0;
    resp = 0;
    respMade = false;
    trial(M(i,2), M(i,3));
    %CALL SCREEN TO FILL BUFFER WITH FIXATION TEXTURE
    Screen('DrawTexture', w, texture_cross, [], smallIm);
    startTime = Screen('Flip', w); %FLIPS TO FIXATION IMAGE


   %Get keypress response
    while GetSecs - startTime < 10 %arbitrary cutoff time of 10s to respond
        [keyIsDown,secs,keyCode] = KbCheck;
        respTime = GetSecs;
        pressedKeys = find(keyCode);

        % ESC key quits the experiment
        if keyCode(KbName('ESCAPE')) == 1
        %    clear all
            close all
            sca
            return;
        end
        
        % Check for response keys
        if ~isempty(pressedKeys)
            for j = 1:length(responseKeys)
                if KbName(responseKeys{j}) == pressedKeys(1)

                    Screen('DrawTexture', w, texture_continue, [], smallIm);
                    Screen('Flip', w);
                    KbStrokeWait;

                    resp = responseKeys{j};
                    rt = (respTime - startTime) + 0.5;
                    %there is a constant delay of 0.5 between the start of
                    %the timer (when the screen flips) and when the tactile
                    %code runs, so we add 0.5 to get the correct RT. The
                    %participants perceived TTC is RT minus actual TTC.
                    pressedKeys = 0;

                end
            end
        end

        % Exit loop once a response is recorded
        if rt > 2.0
            break;
        end

    end
    
    Screen(window, 'FillRect', 255); %%PRESS SPACEBAR TEXTURE
    Screen('Flip', window); %%FLIP TO SPACEBAR TEXTURE

    fprintf(outputfile, '%s\t %i\t %i\t %.2f\t %f\n',... 
        SUBJECT,i,M(i,2),M(i,3),rt);  
    
end
%END EXPERIMENT

Screen('DrawTexture', w, texture_thank, [], smallIm);
Screen('Flip', w);
KbStrokeWait;
    

fclose(outputfile);
Screen(window,'Close');

close all
sca;
ShowCursor(); %shows the cursor



function trial(vIn,tIn)
    fs=44100; %sampling frequency
    nBits=16; %audio resolution
    freqSignal=250; %frequency of the vibration in Hz

    %motion parameters
    v=vIn; %velocity in m/s
    TTC=tIn; %ttc in s
    travelDuration=2; %duration of the simulated motion in seconds

    Dfinal=TTC*v; %the motion stops here
    D0=Dfinal+travelDuration*v;   %distance at trial start

    %sound level parameters
    Dcalib=2; %calibration distance in m
    % %ALTERNATIVE: fix digital amplitude at final sample
    % Dcalib=Dfinal; %calibration distance in m

    calibdBFS=-3; %digital level at the calibration distance

    %create sine wave
    nsignal=(0:round(travelDuration*fs))'; %vector of increasing numbers. Each number represents one sample. Time steps: 1/fs
    signal=sin(2*pi*freqSignal/fs*nsignal); %this creates a pure tone 

    %simulate "looming" approach motion at constant speed on the midsaggital plane (monaural signal, no interaural differences, only intensity change)
    distanceSamples=D0-v.*nsignal./fs; %at each instant t, the distance from the observer is D0-v*t. The distance is computed for each sample
    signal=signal.*Dcalib./distanceSamples; %For each sample, the amplitude is divided by the distance (inverse law for sound pressure). At Dcalib, the digital level is unaltered (multiplied by 1)

    %set the digital level so that calibdBFS is produced at Dcalib
    signal=signal*(10^((calibdBFS)/20));

    % apply cos-squared ramps
    rampMs=20; %ramp duration in ms
    cos2Ramp=cosineSquaredRamps(nsignal/fs*1000,rampMs,length(nsignal)/fs*1000-2*rampMs);
    signal=cos2Ramp.*signal;

    sound(signal,fs,nBits) %this should play the sound
    %plot(signal)
    %xlabel('sample')
    %ylabel('amplitude')

    %audiowrite('trial.wav',signal,fs,'BitsPerSample',nBits);
end
