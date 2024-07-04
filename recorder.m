%% recorder
% Function to record an audio signal for a specified duration.
% Stores the recorded audio and sampling frequency for further processing.
%
% Inputs:
% - fig: The GUI figure handle to display messages.
%
% Outputs:
% - recorded_audio: The recorded audio signal.
% - fs: The sampling frequency of the recorded audio.
% - rec_sec: The duration of the recording in seconds.
%
% Usage:
% [recorded_audio, fs, rec_sec] = recorder(fig);
%
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024


%% Record Signal
function [recorded_audio, fs, rec_sec] = recorder(fig)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;

    % Define the sampling frequency
    fs = 44100; 
    % Create an audiorecorder object with 24 bits and 1 channel
    recObj = audiorecorder(fs, 24, 1); 

    % Display message in GUI
    lbl.Text = 'Recording sound for 5 seconds.'; 
    % Set the recording duration (in seconds)
    rec_sec = 3;        % seconds of recording, this can be changed
    % Display message in GUI
    lbl.Text = sprintf('Recording sound for %d seconds.', rec_sec);
    % Record audio for the specified duration
    recordblocking(recObj, rec_sec); 
    
    % Display message in GUI
    lbl.Text = 'End of Recording.'; 
    pause(1);  % Pause to let the message be visible
    lbl.Text = 'Recording will be now computed for filtering.'; 
    pause(1);  % Pause to let the message be visible
    
    % Get audio data 
    recorded_audio = getaudiodata(recObj); 
    
    % Save the recorded audio to a file
    audiowrite('RecordedSignal.wav', recorded_audio, fs);
return
