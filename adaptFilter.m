%% Adaptive Filtering
function [recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig, filter_type)
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
        [~, e, ~] = getRLS(noisy_signal, recorded_audio, lamda, filter_order);
        cleaned_signal = noisy_signal - e;
    else
        error('Unknown filter type. Choose either ''LMS'' or ''RLS''.');
    end
    
    % Plot the original, noisy, and cleaned signals 
    time = (0:length(recorded_audio)-1)/fs; % Time vector for plotting 
    
    %% Cut first noisy impulse
    cleaned_signal_cut = cleaned_signal((find(time==0.5)):end);
    time_cut = (0:length(cleaned_signal_cut)-1)/fs;
    
    %% Amplify 
    amplifiedAudio = 1.2 * cleaned_signal_cut;  % Amplify by a factor of 1.2 

    %% Save the amplified cleaned signal to a file
    audiowrite('FilteredSignal.wav', amplifiedAudio, fs);
    
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
    title('Cleaned Signal using Adaptive Filter'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    subplot(4, 2, 7); 
    plot(time_cut, cleaned_signal_cut); 
    title('Cleaned Signal Cutted from first Noise'); 
    xlabel('Time (s)'); 
    ylabel('Amplitude'); 
    grid on; 

    %% Plot Spectrograms
    signals = {recorded_audio, noisy_signal, cleaned_signal, cleaned_signal_cut};
    titles = {'Original Signal', 'Noisy Signal', 'Cleaned Signal using Adaptive Filter', 'Cleaned Signal Cutted from first Noise'};
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
