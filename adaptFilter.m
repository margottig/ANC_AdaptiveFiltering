%% Adaptive Filtering
% Function to apply adaptive filtering to a recorded audio signal.
% Generates a noisy signal, cleans it using LMS or RLS adaptive filtering, 
% and amplifies the cleaned signal if LMS is used. Plots the original, noisy,
% cleaned, and amplified signals, and saves the filtered signal to a file.
%
% Authors: Marcelo Argotti Gomez, Juliette Naumann
% Date: July 4, 2024
%
% Inputs:
% - recorded_audio: The recorded audio signal.
% - fs: The sampling frequency of the recorded audio.
% - fig: The GUI figure handle to display messages.
% - filter_type: The type of adaptive filter to use ('LMS' or 'RLS').
%
% Outputs:
% - recorded_audio: The recorded audio signal (unchanged).
% - noisy_signal: The generated noisy signal.
% - cleaned_signal: The cleaned signal after filtering.
% - amplifiedAudio: The amplified cleaned signal (only for LMS).
% - fs: The sampling frequency of the signals.
%
% Usage:
% [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig, filter_type);

% ------------------------------------------------------------------------

%% Adaptive Filter
function [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig, filter_type)
    % Access the label handle from the figure's UserData
    lbl = fig.UserData.lbl;
    
    %% Generate a noisy signal by adding white Gaussian noise 
    noise_power = 0.15; % Adjust the noise power as needed 
    noise = noise_power * randn(size(recorded_audio)); 
    noisy_signal = recorded_audio + noise; 
    
    %% Filter parameters
    filter_order = 32; % Order of the adaptive filter 
    mu = 0.01; % Step size for the LMS algorithm 
    lamda = 0.99; % Forgetting factor for RLS algorithm
    
    %% Clean and amplify the signal

    %% Apply the chosen adaptive filter
    if strcmp(filter_type, 'LMS')
        % Initialize the LMS filter 
        lms_filter = dsp.LMSFilter('Length', filter_order, 'StepSize', mu); 
        % Apply the LMS filter 
        [extracted_noise, e] = lms_filter(noise, noisy_signal);
        cleaned_signal = noisy_signal - extracted_noise; 
    elseif strcmp(filter_type, 'RLS')
        % Apply the RLS filter
        [y, ~, ~] = getRLS(recorded_audio,noisy_signal, lamda, filter_order);
        cleaned_signal = y;
    else
        error('Unknown filter type. Choose either ''LMS'' or ''RLS''.');
    end
    
    % Plot the original, noisy, and cleaned signals 
    time = (0:length(recorded_audio)-1)/fs; % Time vector for plotting 
    
    %% Cut first noisy impulse
    cleaned_signal_cut = cleaned_signal((find(time==0.5)):end);
    time_cut = (0:length(cleaned_signal_cut)-1)/fs;
    
    %% Amplify if LMS, otherwise keep as is
    if strcmp(filter_type, 'LMS')
        amplifiedAudio = 1.2 * cleaned_signal_cut;  % Amplify by a factor of 1.2 
    else
        amplifiedAudio = cleaned_signal_cut;
    end

    %% Save the amplified cleaned signal to a file
    if strcmp(filter_type, 'LMS')
        audiowrite('FilteredSignal_LMS.wav', amplifiedAudio, fs);
    else
        audiowrite('FilteredSignal_RLS.wav', amplifiedAudio, fs);
    end
    
    %% Plot Time-Domain Signals
    figure; 
    subplot(4, 2, 1); 
    plot(time, recorded_audio); 
    title('Original Signal'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 2, 3); 
    plot(time, noisy_signal); 
    title('Noisy Signal'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 2, 5); 
    plot(time, cleaned_signal); 
    title(['Cleaned Signal using ', filter_type, ' Filter']); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 2, 7); 
    plot(time_cut, cleaned_signal_cut); 
    if strcmp(filter_type, 'LMS')
        title('Cleaned Signal Cutted from first Noise and Amplified');
    else
        title('Cleaned Signal Cutted from first Noise');
    end
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    %% Plot Spectrograms
    signals = {recorded_audio, noisy_signal, cleaned_signal, cleaned_signal_cut};
    titles = {'Original Signal', 'Noisy Signal', ['Cleaned Signal using ', filter_type, ' Filter'], 'Cleaned Signal Cutted from first Noise'};
    if strcmp(filter_type, 'LMS')
        titles{4} = 'Cleaned Signal Cutted from first Noise and Amplified';
    else
        titles{4} = 'Cleaned Signal Cutted from first Noise';
    end
    
    hw = hamming(256); % Window
    np = 128; % Number of overlap samples
    
    for i = 1:length(signals)
        subplot(4, 2, 2*i); % Adjust subplot position for spectrogram
        [S, F, T] = spectrogram(signals{i}, hw, np, [], fs);
        imagesc(T, F, 20*log10(abs(S)));
        set(gca,'YDir','normal');
        title(titles{i}); 
        xlabel('Time (s)'); 
        ylabel('Frequency (Hz)');
    end
end
