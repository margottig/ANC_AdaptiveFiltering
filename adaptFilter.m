%% adaptFilter
% Function to apply adaptive filtering to a recorded audio signal.
% Generates a noisy signal, cleans it using LMS adaptive filtering, and amplifies the cleaned signal.
% Plots the original, noisy, cleaned, and amplified signals.
%
% Inputs:
% - recorded_audio: The recorded audio signal.
% - fs: The sampling frequency of the recorded audio.
% - fig: The GUI figure handle to display messages.
%
% Outputs:
% - recorded_audio: The recorded audio signal (unchanged).
% - noisy_signal: The generated noisy signal.
% - cleaned_signal: The cleaned signal after filtering.
% - amplifiedAudio: The amplified cleaned signal.
% - fs: The sampling frequency of the signals.
%
% Usage:
% [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig);
%
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024

%% Adaptive Filter
function [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;

    %% Display message in GUI
    lbl.Text = 'Turn your sound on!'; 
    pause(2);  % Pause to let the message be visible
    lbl.Text = '';  % Clear the message
    
    %% Generate a noisy signal by adding white Gaussian noise 
    noise_power = 0.15; % Adjust the noise power as needed 
    noise = noise_power * randn(size(recorded_audio)); 
    noisy_signal = recorded_audio + noise; 
    
    %% LMS filter parameters 
    filter_order = 32; % Order of the adaptive filter 
    mu = 0.01; % Step size for the LMS algorithm 
    % Initialize the LMS filter 
    lms_filter = dsp.LMSFilter('Length', filter_order, 'StepSize', mu); 
    
    %% Clean and amplify the signal
 
    %% Apply the LMS filter 
    [extracted_noise, e] = lms_filter(noise, noisy_signal);
    cleaned_signal = noisy_signal - extracted_noise; 
    % Plot the original, noisy, and cleaned signals 
    time = (0:length(recorded_audio)-1)/fs; % Time vector for plotting 
    
    %% Cut first noisy impulse
    cleaned_signal_cut = cleaned_signal((find(time==0.5)):end);
    time_cut = (0:length(cleaned_signal_cut)-1)/fs;
    
    %% Amplify 
    amplifiedAudio = 1.2 * cleaned_signal_cut;  % Amplify by a factor of 1.2 

    %% Save the amplified cleaned signal to a file
    audiowrite('FilteredSignal.wav', amplifiedAudio, fs);
    
    %% Plot
    figure; 
    subplot(4, 1, 1); 
    plot(time, recorded_audio); 
    title('Original Signal'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 1, 2); 
    plot(time, noisy_signal); 
    title('Noisy Signal'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 1, 3); 
    plot(time, cleaned_signal); 
    title('Cleaned Signal using LMS Adaptive Filter'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 1, 4); 
    plot(time_cut, cleaned_signal_cut); 
    title('Cleaned Signal Cutted from first Noise'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 
end
