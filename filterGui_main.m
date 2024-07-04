%% filterGui_main
% Main script for creating and displaying the GUI for the adaptive filter project.
% Handles user interactions through buttons to record and play various signals.
%
% Usage:
% 1. Run the script to open the GUI.
% 2. Use the "Record" button to start recording a signal.
% 3. Use the "Play Original", "Play Noisy", and "Play Amplified" buttons to play the respective signals.
% 
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024

%%
% Main function to create and display the GUI
function filterGui()
    % Create the main figure for the GUI
    fig = uifigure('Name', 'Record GUI', 'Position', [100, 100, 500, 300]);
    
    % Create RECORD SIGNAL button and set its callback function
    btnRecord = uibutton(fig, 'push', 'Text', 'Record', ...
                         'Position', [50, 140, 100, 50], ...
                         'ButtonPushedFcn', @(btn, event) recordButtonPushed(btn, fig));
    
    % Create PLAY ORIGINAL SIGNAL button and set its callback function
    btnPlayOriginal = uibutton(fig, 'push', 'Text', 'Play Original', ...
                               'Position', [300, 200, 150, 50], ...
                               'ButtonPushedFcn', @(btn, event) playSignal(fig, 'original'));
    
    % Create PLAY NOISY SIGNAL button and set its callback function
    btnPlayNoisy = uibutton(fig, 'push', 'Text', 'Play Noisy', ...
                            'Position', [300, 140, 150, 50], ...
                            'ButtonPushedFcn', @(btn, event) playSignal(fig, 'noisy'));
    
    % Create PLAY AMPLIFIED SIGNAL button and set its callback function
    btnPlayAmplified = uibutton(fig, 'push', 'Text', 'Play Amplified', ...
                                'Position', [300, 80, 150, 50], ...
                                'ButtonPushedFcn', @(btn, event) playSignal(fig, 'amplified'));
    
    % Create a label to display text messages
    lbl = uilabel(fig, 'Text', '', ...
                  'Position', [50, 20, 400, 50], ...
                  'FontSize', 14, ...
                  'HorizontalAlignment', 'center', ...
                  'FontWeight', 'bold', ...
                  'FontColor', [1, 0, 0]);  % Set the text color to red
    
    % Store the label handle and signals in the figure's UserData for later access
    fig.UserData.lbl = lbl;
    fig.UserData.recorded_audio = [];
    fig.UserData.noisy_signal = [];
    fig.UserData.amplifiedAudio = [];
    fig.UserData.fs = [];
end

%% Callback Function

% Callback function to handle the button press event for recording
function recordButtonPushed(btn, fig)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;

    % Call the recorder function to get the recorded audio
    [recorded_audio, fs, rec_sec] = recorder(fig);

    % Display message in GUI
    lbl.Text = 'Processing the recorded signal...';
    pause(1);  % Pause to let the message be visible
    
    % Call the adaptive filter function to get the signals
    [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig);
    
    % Store the signals and sampling frequency in the figure's UserData
    fig.UserData.recorded_audio = recorded_audio;
    fig.UserData.noisy_signal = noisy_signal;
    fig.UserData.amplifiedAudio = amplifiedAudio;
    fig.UserData.fs = fs;

    % Play and display the signals sequentially
    playSignalHelper(fig, recorded_audio, fs, 'Playing original signal...');
    playSignalHelper(fig, noisy_signal, fs, 'Playing noisy signal...');
    playSignalHelper(fig, cleaned_signal, fs, 'Playing cleaned signal...');
    playSignalHelper(fig, amplifiedAudio, fs, 'Playing CUTTED and AMPLIFIED CLEAN SIGNAL...');
end

% Helper function to play a signal and display a message in the GUI
function playSignalHelper(fig, signal, fs, message)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;
    
    if ~isempty(signal)
        % Play and display the signal with the given message
        lbl.Text = message;
        sound(signal, fs);
        pause(length(signal)/fs + 0.2);  % Pause to let the message be visible during playback
        lbl.Text = '';  % Clear the message
    else
        % Display an error message if the signal is not available
        lbl.Text = 'No signal available.';
        pause(2);  % Pause to let the error message be visible
        lbl.Text = '';  % Clear the message
    end
end

% Callback function to play a specific signal based on the type
function playSignal(fig, signalType)
    % Access the label handle and signals from the figure's UserData
    lbl = fig.UserData.lbl;
    fs = fig.UserData.fs;
    
    switch signalType
        case 'original'
            signal = fig.UserData.recorded_audio;
            message = 'Playing original signal...';
        case 'noisy'
            signal = fig.UserData.noisy_signal;
            message = 'Playing noisy signal...';
        case 'amplified'
            signal = fig.UserData.amplifiedAudio;
            message = 'Playing CUTTED and AMPLIFIED CLEAN SIGNAL...';
        otherwise
            signal = [];
            message = 'Invalid signal type.';
    end
    
    playSignalHelper(fig, signal, fs, message);
end
