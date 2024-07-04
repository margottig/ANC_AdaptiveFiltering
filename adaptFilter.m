%% Adaptive Filtering
function [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter
    
    %% Record Signal
    % Call RecorderFunction
    [recorded_audio, fs] = recorder;
    
    %% Generate a noisy signal by adding white Gaussian noise 
    noise_power = 0.7; % Adjust the noise power as needed 
    noise = noise_power * randn(size(recorded_audio)); 
    [noiseHall,fs]=audioread("Noise Orang.wav");
    noiseHall_resize = imresize(noiseHall, [size(recorded_audio, 1), size(recorded_audio, 2)]);

    %noisy_signal = recorded_audio + noiseHall_resize; 
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

    
    %% Plot
    disp('Turn your sound on!'); 
    disp('Analysis of original and processed signal will be shown.'); 
    pause(length(recorded_audio)/fs); 
    
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