%cd('Z:\forschung\time_to_contact\TTCauditory\pat_auditory1')

%start random number generator
randn('state',sum(100*clock));
randn(round(rand*200000)+1,1);    

%set some technical parameters
fs=48000; %sampling frequency of the sound card (in Hz)
nBits=24;  %resolution in bits of the sound card

%properties of the sound source
finalLevel=-6; %digital level (in dBFS) of the sound source at the position of the listener (distance = Dfinal = 0.1 m). NOTE: -15 dBFS is the maximum level for Gaussian noise, for pure tones we can use -6 dBFS
tonefreq=1000;
rampMs=5;   %ramp duration in ms

%motion parameters
vList=[100 300]*25; %List: velocity in ft/frame * frames/s
TTClist=[2.5]; %List: TTCfinal in s
tVis=1;     %time the object is audible

counter=0;
for vInd=1:length(vList)
    for TTCind=1:length(TTClist)
        v=vList(vInd);
        TTC=TTClist(TTCind);
        Dfinal=TTC*v; %the motion stops here
        D0=Dfinal+tVis*v;   %distance at trial start
        travelDuration=min((D0-0.1)/v,(D0-Dfinal)/v); %duration of the simulated motion in seconds. NOTE: the script needs to take care that the sound source stops before reaching the observer (minmal distance = 10 cm)

        %create the sound
        nsignal=(0:round(travelDuration*fs))'; %vector of increasing numbers. Each number represents one sample. Time steps: 1/fs

        % %broadband noise
        % signal=randn(length(nsignal),1)*(Dfinal*10^((finalLevel)/20)); %this creates a broadband noise with the maximal level (the level that is obtained when the sound source reaches the listener)
        %
        %pure tone
        
        %--------
        %!!!
        %set the final level
        % Dcalib=Dfinal;     %distance at which the sound has finalLevel. If Dcalib=Dfinal, finalLevel is always reached at the final distance - trajectories do not differ in final level
        Dcalib=500;     %distance at which the sound has finalLevel.  
        
        signal=sin(2*pi*tonefreq/fs*nsignal)*(Dcalib*10^((finalLevel)/20)); %this creates a pure tone with the level (finalLevel) that was selected for the Dfinal= 500 - trajectories differ in final level
        % apply cos-squared ramps
        cos2Ramp=cosineSquaredRamps(nsignal/fs*1000,rampMs,length(nsignal)/fs*1000-2*rampMs);
        signal=cos2Ramp.*signal;

        %simulate approach motion at constant speed on the midsaggital plane (monaural signal, no interaural differences)
        distanceSamples=D0-v.*nsignal./fs; %at each instant t, the distance is D0-v*t. The distance is computed for each sample
        %plot(distanceSamples);
        signal=signal./distanceSamples; %For each sample, the amplitude is divided by the distance (inverse law for sound pressure)

        %zero-padding with 600 ms at beginning/end to avoid clicks due to "lost" samples /Windows problem)
        signal=[zeros(round((600/1000)*fs),size(signal,2));signal;zeros(round((600/1000)*fs),size(signal,2))];

        %sound(signal,fs,nBits) %this should play the sound
        filename=['av1t',num2str(TTC),'_', num2str(v),'.wav']; %filename: "av1tTTC"
        %wavwrite(signal,fs,nBits,filename); %save the sound in wav format
        audiowrite(filename,signal,fs);
        %write parameter values to the structrure parameterList;
        counter=counter+1;
        parameterList.v(counter)=v;
        parameterList.TTC(counter)=TTC;
        parameterList.D0(counter)=D0;
        parameterList.tVis(counter)=tVis;
        parameterList.travelDuration(counter)=travelDuration;
        parameterList.Dfinal(counter)=Dfinal;
        parameterList.finalLevel(counter)=20*log10(Dcalib*10^((finalLevel)/20)/Dfinal);
        parameterList.levelChange(counter)=20*log10(D0/Dfinal);

    end %for TTC
end %for v

save('parameterList.mat', 'parameterList')