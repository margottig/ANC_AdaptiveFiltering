%% Recording
% This Function records our signal and 
% stores it for further processing

%% Record Signal
function [recorded_audio,fs,rec_sec] = recorder
    global fs;
    global recorded_audio;
    fs = 44100; 
    recObj = audiorecorder(fs, 24, 1); 
    disp('Recording sound for 5 seconds.'); 
    rec_sec = 3;        % seconds of recording, this can be changed
    recordblocking(recObj, rec_sec); 
    disp('End of Recording.'); 
    disp('Recording will be now computed for filtering.'); 
    % Get audio data 
    recorded_audio = getaudiodata(recObj); 
    
    audiowrite('Changis_RingTone.wav',recorded_audio, fs);
return
