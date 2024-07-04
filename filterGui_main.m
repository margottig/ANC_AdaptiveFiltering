%% Main file for opening the GUI of the adaptive filter file, which calls the recorder.m
 
function filterGui()
    % Create the figure
    fig = uifigure('Name', 'Record GUI', 'Position', [100, 100, 300, 200]);
    %%
    % 
    
    %% Create RECORD button
    btn = uibutton(fig, 'push', 'Text', 'Record', ...
                   'Position', [100, 100, 100, 50], ...
                   'ButtonPushedFcn', @(btn, event) recordButtonPushed(btn, fig));
    
    % Create a label to display text
    lbl = uilabel(fig, 'Text', '', ...
                  'Position', [50, 150, 200, 50], ...
                  'FontSize', 14, ...
                  'HorizontalAlignment', 'center');
    
    % Store the label handle in the figure's UserData for later access
    fig.UserData.lbl = lbl;
end

%% Callback Function

% Create the callback function that handles the button press event. 

function recordButtonPushed(btn, fig)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;

    % Call adaptive Filter Function
    [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter;
    
    pause((length(recorded_audio)/fs) +2); 
    

    % Display some text in the label
    lbl.Text = 'Playing original signal...';
    sound(recorded_audio, fs);
    pause(length(recorded_audio)/fs + 2); 
    
    % Display some text in the label
    lbl.Text = 'Playing noisy signal...';
    sound(noisy_signal, fs); 
    pause(length(noisy_signal)/fs + 2); 

    % Display some text in the label
    lbl.Text = 'Playing cleaned signal...';
    sound(cleaned_signal, fs); 
    pause(length(cleaned_signal)/fs + 2);
   
    % Display some text in the label
    lbl.Text = 'Playing CUTTED and amplified cleaned signal...';
    sound(amplifiedAudio, fs); 
  
end

