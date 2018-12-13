%Code has two modes: Input parameter or input soundfiles
%Output is user respose
clear;clc;
KbName('UnifyKeyNames');
responseKeys = {'0'};     
dummyTimer = GetSecs;
Screen('Preference', 'VisualDebuglevel', 1);
Screen('Preference', 'Verbosity', 2);

%Prompt user input subject number

prompt = {'Enter subject number:'}; %description of fields
defaults = {''};%you can put in default responses
answer = inputdlg(prompt, 'Subject Number',1.2,defaults); %opens dialog
SUBJECT = answer{1,:}; %Gets Subject Name
resultsFolder = 'data';

%Store data to "data" folder in txt form
% outputfile = fopen([resultsFolder '/tt1dat_' num2str(SUBJECT) '.txt'],'wt+');
% fprintf(outputfile, 'SUBJECT\t TRIAL\t VEL\t TTC\t RT\n'); 

%START TO READ CONFIG.TXT FILE
inputconfig = 'config.txt';
C = dlmread(inputconfig,'',5,0);%Read to C

if C==1%input variables method
    outputfile = fopen([resultsFolder '/tt1data_' num2str(SUBJECT) '.txt'],'wt+');
    fprintf(outputfile, 'SUBJECT\t TRIAL\t VEL\t TTC\t RT\n'); 
end
if C==2%play sound files method
    outputfile = fopen([resultsFolder '/tt1data_' num2str(SUBJECT) '.txt'],'wt+');
    fprintf(outputfile, 'SUBJECT\t TRIAL\t SOUND\t RT\n'); 
end


%START TO READ SOUND.TXT

inputsound = 'tt1sound.txt';

S = textread(inputsound, '%s', 'delimiter', '\n', 'whitespace', '');
S = string(S);
numSound = length(S);%Read to S
PS = string(textread('tt1soundpractice.txt', '%s', 'delimiter', '\n', 'whitespace', ''));
numPractice = length(PS);



%START TO READ ORDER.TXT FILE
filename = 'order.txt';%%%%%%%%%
M = dlmread(filename,'',1,0); %Read input to M
numTrials = length(M);
PM = dlmread('orderPractice.txt','',1,0);

if C ==2
    numTrials=numSound;
    numPractice = length(PS);
else
    numTrials = length(M);
    numPractice = length(PM);

end

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
[img1, ~, ~] = imread('intro.png');
texture_intro = Screen('MakeTexture', w, img1);
[img2, ~, ~] = imread('midvib.png');
texture_midvib = Screen('MakeTexture', w, img2);
[img3, ~, ~] = imread('lowvib.png');
texture_lowvib = Screen('MakeTexture', w, img3);
[img4, ~, ~] = imread('highvib.png');
texture_highvib = Screen('MakeTexture', w, img4);
[img5, ~, alpha] = imread('instruction.png');
texture_instruction = Screen('MakeTexture', w, img5);
[img6, ~, ~] = imread('arrow.png');
texture_arrow = Screen('MakeTexture', w, img6);
[img7, ~, ~] = imread('endpractice.png');
texture_endpractice = Screen('MakeTexture', w, img7);
[img8, ~, ~] = imread('thankyou.png');
texture_thankyou = Screen('MakeTexture', w, img8);
[img9, ~, ~] = imread('cross.png');
texture_cross = Screen('MakeTexture', w, img9);
[img10, ~, ~] = imread('ready.png');
texture_ready = Screen('MakeTexture', w, img10);
[img11, ~, ~] = imread('startpractice.png');
texture_startpractice = Screen('MakeTexture', w, img11);
[img12, ~, ~] = imread('startreal.png');
texture_startreal = Screen('MakeTexture', w, img12);
[img13, ~, ~] = imread('check.png');
texture_check = Screen('MakeTexture', w, img13);
%END OF MAKE TEXTURES


smImSq = [0 0 1000 1000];
[smallIm, xOffsetsigS, yOffsetsigS] = CenterRect(smImSq, rect);

%BEGIN EXPERIMENT
%SHOW WELCOME SCREEN

Screen('DrawTexture', w, texture_arrow, [], smallIm);
Screen('Flip', w);
KbStrokeWait;

Screen('DrawTexture', w, texture_intro, [], smallIm);
Screen('Flip', w);
KbStrokeWait;


Screen('DrawTexture', w, texture_midvib, [], smallIm);
Screen('Flip', w);
KbStrokeWait;
[y,Fs] = audioread('halfvib.wav');
sound(y,Fs);
KbStrokeWait;

Screen('DrawTexture', w, texture_lowvib, [], smallIm);
Screen('Flip', w);
KbStrokeWait;
[y,Fs] = audioread('lowvib.wav');
sound(y,Fs);
KbStrokeWait; 

Screen('DrawTexture', w, texture_highvib, [], smallIm);
Screen('Flip', w);
KbStrokeWait;
[y,Fs] = audioread('maxvib.wav');
sound(y,Fs);
KbStrokeWait; 

Screen('DrawTexture', w, texture_instruction, [], smallIm);
Screen('Flip', w);
KbStrokeWait;



Screen('DrawTexture', w, texture_startpractice, [], smallIm);
Screen('Flip', w);
KbStrokeWait;

Screen('DrawTexture', w, texture_check, [], smallIm);
Screen('Flip', w);
KbStrokeWait;


Screen('DrawTexture', w, texture_arrow, [], smallIm);
Screen('Flip', w);
KbStrokeWait;

%%%%%%%%%%%%%%%%%%%
%practice
%Play trials
for i = 1:numPractice 
    rt = 0;
    resp = 0;
    respMade = false;
    if C==1
        trial(PM(i,2), PM(i,3));
    else
        [y,Fs] = audioread(PS(i,1));
        sound(y,Fs);
    end
    %CALL SCREEN TO FILL BUFFER WITH FIXATION TEXTURE
    Screen('DrawTexture', w, texture_cross, [], smallIm);
    startTime = Screen('Flip', w); %FLIPS TO FIXATION IMAGE
    
    
    
   %Get keypress response
    while respMade == false %arbitrary cutoff time of 10s to respond
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

                    Screen('DrawTexture', w, texture_arrow, [], smallIm);
                    Screen('Flip', w);
                    KbStrokeWait;

                    resp = responseKeys{j};
                    rt = (respTime - startTime) - 0.4;
                    %there is a constant delay of 0.4 between the start of
                    %the timer (when the screen flips) and when the tactile
                    %code runs, so we subtract 0.4 to get the correct RT. The
                    %participants perceived TTC is RT minus actual TTC.
                    pressedKeys = 0;
                    respMade = true;
                end
            end
        end


    end
    
    Screen(window, 'FillRect', 255); %%PRESS SPACEBAR TEXTURE
    Screen('Flip', window); %%FLIP TO SPACEBAR TEXTURE

    
end
%END EXPERIMENT
%%%%%%%%%%%%%%%%%%%%


Screen('DrawTexture', w, texture_endpractice, [], smallIm);
Screen('Flip', w);
KbStrokeWait;

%End Practice
 




Screen('DrawTexture', w, texture_arrow, [], smallIm);
Screen('Flip', w);
KbStrokeWait;



   

%Play trials
for i = 1:numTrials 
    rt = 0;
    resp = 0;
    respMade = false;
    if C==1
        trial(M(i,2), M(i,3));
    else
        [y,Fs] = audioread(S(i,1));
        sound(y,Fs);
    end
    %CALL SCREEN TO FILL BUFFER WITH FIXATION TEXTURE
    Screen('DrawTexture', w, texture_cross, [], smallIm);
    startTime = Screen('Flip', w); %FLIPS TO FIXATION IMAGE
    
    
    
   %Get keypress response
    while respMade == false %arbitrary cutoff time of 10s to respond
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

                    Screen('DrawTexture', w, texture_arrow, [], smallIm);
                    Screen('Flip', w);
                    KbStrokeWait;

                    resp = responseKeys{j};
                    rt = (respTime - startTime) - 0.4;
                    %there is a constant delay of 0.4 between the start of
                    %the timer (when the screen flips) and when the tactile
                    %code runs, so we subtract 0.4 to get the correct RT. The
                    %participants perceived TTC is RT minus actual TTC.
                    pressedKeys = 0;
                    respMade = true;
                end
            end
        end

        % Exit loop once a response is recorded
%         if rt > 2.0
%             break;
%         end

    end
    
    Screen(window, 'FillRect', 255); %%PRESS SPACEBAR TEXTURE
    Screen('Flip', window); %%FLIP TO SPACEBAR TEXTURE

    if C==1%input variables method
        fprintf(outputfile, '%s\t %i\t %i\t %.2f\t %f\n',... 
            SUBJECT,i,M(i,2),M(i,3),rt);  
    end
    if C==2%play sound files method
         fprintf(outputfile, '%s\t %i\t %s\t %f\n',... 
            SUBJECT,i,S(i,1),rt);   
    end
    
    
end
%END EXPERIMENT

Screen('DrawTexture', w, texture_thankyou, [], smallIm);
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

