%% Main file for opening the GUI of the adaptive filter file, which calls the recorder.m

% Main function to create and display the GUI
function filterGui()
    % Create the main figure for the GUI
    fig = uifigure('Name', 'Record GUI', 'Position', [100, 100, 500, 300]);
    
    % Create RECORD SIGNAL button and set its callback function
    btnRecord = uibutton(fig, 'push', 'Text', 'Record', ...
                         'Position', [50, 200, 100, 50], ...
                         'ButtonPushedFcn', @(btn, event) recordButtonPushed(btn, fig));
    
    % Create FILTER TYPE dropdown
    ddFilterType = uidropdown(fig, ...
                              'Position', [50, 140, 100, 50], ...
                              'Items', {'LMS', 'RLS'}, ...
                              'Value', 'LMS', ...
                              'ValueChangedFcn', @(dd, event) filterTypeChanged(dd, fig));
    
    % Create PROCESS SIGNAL button and set its callback function
    btnProcess = uibutton(fig, 'push', 'Text', 'Process', ...
                          'Position', [50, 80, 100, 50], ...
                          'ButtonPushedFcn', @(btn, event) processButtonPushed(btn, fig));
    
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
    fig.UserData.filterType = 'LMS';
end

%% Callback Functions

% Callback function to handle the button press event for recording
function recordButtonPushed(btn, fig)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;

    % Call the recorder function to get the recorded audio
    [recorded_audio, fs, rec_sec] = recorder(fig);

    % Store the recorded audio and sampling frequency in the figure's UserData
    fig.UserData.recorded_audio = recorded_audio;
    fig.UserData.fs = fs;

    % Clear any previously processed signals
    fig.UserData.noisy_signal = [];
    fig.UserData.amplifiedAudio = [];
    
    % Display message in GUI
    lbl.Text = 'Signal recorded. Choose a filter and process the signal.';
    pause(2);  % Pause to let the message be visible
    lbl.Text = '';  % Clear the message
end

% Callback function to handle the dropdown value change event for filter type
function filterTypeChanged(dd, fig)
    % Update the filter type in the figure's UserData
    fig.UserData.filterType = dd.Value;
end

% Callback function to handle the button press event for processing
function processButtonPushed(btn, fig)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;

    % Get the recorded audio and filter type from the figure's UserData
    recorded_audio = fig.UserData.recorded_audio;
    fs = fig.UserData.fs;
    filter_type = fig.UserData.filterType;

    if isempty(recorded_audio)
        lbl.Text = 'No signal recorded. Please record a signal first.';
        pause(2);  % Pause to let the error message be visible
        lbl.Text = '';  % Clear the message
        return;
    end

    % Display message in GUI
    lbl.Text = 'Processing the recorded signal...';
    pause(1);  % Pause to let the message be visible
    
    % Call the adaptive filter function to get the signals
    [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig, filter_type);
    
    % Store the signals and sampling frequency in the figure's UserData
    fig.UserData.noisy_signal = noisy_signal;
    fig.UserData.amplifiedAudio = amplifiedAudio;

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
