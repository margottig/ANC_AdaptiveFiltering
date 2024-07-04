%% playSignalHelper.m - Helper function to play a signal and display a message in the GUI.
%
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024
%
% Usage: playSignalHelper(fig, signal, fs, message)
%
% Inputs:
% fig     - The GUI figure handle to access shared data and display messages.
% signal  - The audio signal to be played.
% fs      - The sampling frequency of the audio signal.
% message - The message to be displayed in the GUI before playback.
%
% ------------------------------------------------------------------------

function playSignalHelper(fig, signal, fs, message)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;
    
    if ~isempty(signal)
        % Display message 1 second before playing the sound
        lbl.Text = message;
        pause(1);  % Pause to let the message be visible
        sound(signal, fs);
        pause(length(signal)/fs + 0.2);  % Pause to let the sound play
        lbl.Text = '';  % Clear the message
    else
        % Display an error message if the signal is not available
        lbl.Text = 'No signal available.';
        pause(2);  % Pause to let the error message be visible
        lbl.Text = '';  % Clear the message
    end
end
