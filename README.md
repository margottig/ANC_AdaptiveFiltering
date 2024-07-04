# Active NoiseCancelling - Adaptive Filter App

## Description
This program provides a graphical user interface (GUI) for implementing ANC methods using two adaptive algorithms (LMS and RLS) and a filtered adaptive algorithm (FxLMS). The performance of these implementations is evaluated through listening comparisons. 

The application records an audio signal, adds noise to create a noisy signal, and then cleans the noisy signal using the previously mentioned algorithms. The cleaned signal is amplified and played back. Both the original and the cleaned signals are saved as audio files. The GUI also displays time domain plots and spectrograms of the signals.

## Info
Authors
- Marcelo Argotti Gomez
- Juliette Naumann

Date:
July 4, 2024

## Usage
### Requirements
- MATLAB
- DSP System Toolbox (for `dsp.LMSFilter` and `dsp.RLSFilter`)

### How to Run
1. Open MATLAB.
2. Navigate to the directory containing the program files.
3. Run the `filterGui_main.m` script to launch the GUI.

### GUI Overview
The GUI contains the following components:
- **Record Button**: Starts recording an audio signal.
- **Filter Method Dropdown**: Allows the user to select the filter type (LMS, RLS or FxLMS).
- **Process Button**: Processes the recorded signal with the selected filter.
- **Play Original Button**: Plays the original recorded audio signal.
- **Play Noisy Button**: Plays the noisy version of the recorded audio signal.
- **Play Filtered Button**: Plays the cleaned and amplified version of the recorded audio signal.
- **Label**: Displays messages indicating the current operation being performed.

<p align="center">
  <img src="image-GUI.png" alt="GUI" width="50%">
</p>


### Steps to Use the Program
1. **Start the GUI**: Run the `filterGui_main.m` script.
2. **Record an Audio Signal**:
   - Click the "Record" button.
   - The GUI will display a message indicating that recording is in progress.
   - The recording will last for a specified duration (default is 3 seconds).
3. **Process the Recorded Signal**:
   - Select the filter method (LMS, RLS or FxLMS) using the dropdown menu labeled "Filter Method".
   - Click the "Process" button to process the signal with the selected filter.
   - Messages will be displayed in the GUI during each step of the processing.
4. **Play Processed Signals**:
   - Use the "Play Original" button to hear the original recorded signal.
   - Use the "Play Noisy" button to hear the noisy signal.
   - Use the "Play Filtered" button to hear the filtered signal.
   - The label will display messages indicating which signal is being played.

### Signal Visualization
The program visualizes the signals in two ways: 
1. Time-domain plots display the original signal, the noisy signal, and the cleaned signal. Additionally, the initial pulse during the filter's attack phase is removed in the final processing steps.
2. Spectrograms showing the frequency content of the signals as a function of time.

<p align="center">
  <img src="image-Signals.png" alt="GUI" width="50%">
</p>

### Functions
#### filterGui_main
- **Description**: Main script for creating and displaying the GUI. Handles user interactions through buttons to record and play various signals.
- **Usage**: Run the script to open the GUI. Use the buttons to record and play signals.

#### recorder
- **Description**: Function to record an audio signal for a specified duration. Stores the recorded audio and sampling frequency for further processing.
- **Inputs**: 
  - `fig`: The GUI figure handle to display messages.
- **Outputs**:
  - `recorded_audio`: The recorded audio signal.
  - `fs`: The sampling frequency of the recorded audio.
  - `rec_sec`: The duration of the recording in seconds.
- **Usage**: `[recorded_audio, fs, rec_sec] = recorder(fig);`

#### adaptFilter
- **Description**: Function for applying adaptive filtering to a recorded audio signal. Generates a noisy signal, cleans it using LMS, RLS, and FxLMS adaptive filtering, and amplifies the cleaned signal. Plots the original, noisy, cleaned, and amplified signals, and saves the filtered signal to a file.
- **Inputs**: 
  - `recorded_audio`: The recorded audio signal.
  - `fs`: The sampling frequency of the recorded audio.
  - `fig`: The GUI figure handle to display messages.
  - `filter_type`: The type of adaptive filter to use ('LMS' or 'RLS').
- **Outputs**:
  - `recorded_audio`: The recorded audio signal (unchanged).
  - `noisy_signal`: The generated noisy signal.
  - `cleaned_signal`: The cleaned signal after filtering.
  - `amplifiedAudio`: The amplified cleaned signal (only for LMS).
  - `fs`: The sampling frequency of the signals.
- **Usage**: `[recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig, filter_type);`

#### playSignalHelper
- **Description**: This function is called by the main GUI script to handle the playback of different audio signals and to display corresponding messages in the GUI. It ensures that the correct signal is played while showing a message to the user for a brief moment before the playback starts. This function is used internally by the main script and is not called directly by the user. The function is invoked by the playSignal callback based on user interactions with the GUI.
- **Inputs**: 
  - `fig`: The GUI figure handle to access shared data and display messages.
  - `signal`: The audio signal to be played.
  - `fs`: The sampling frequency of the audio signal.
  - `message`: The message to be displayed in the GUI before the playback starts.

#### getRLS
- **Description**: Implements the RLS adaptive filter.
- **Inputs**: 
  - `d`: The vector of desired signal samples (reference signal).
  - `x`: The vector of input signal samples.
  - `lamda`: The weight parameter (forgetting factor).
  - `M`: The number of taps (filter order).
- **Outputs**:
  - `e`: The output error vector.
  - `y`: The output coefficients.
  - `w`: The filter parameters.
- **Usage**: `[e, y, w] = getRLS(d, x, lamda, M);`


#### getFXLMS
- **Description**: Implements the Filtered-X Least Mean Squares (FXLMS) algorithm using MATLAB's dsp.FilteredXLMSFilter System object, typically used for adaptive noise cancellation.
- **Inputs**:
  - `x`: Input signal vector (recorded signal).
  - `n`: Noise signal vector.
- **Outputs**:
  - `y`: Filtered output signal.
  - `e`: Output error vector.
- **Usage**: `[y, e] = getFXLMS(x, n);`

## Notes
- Ensure that your sound system is turned on to hear the playback of the recorded and processed signals.
- Make sure the microphone is turned on to record the audio signal.