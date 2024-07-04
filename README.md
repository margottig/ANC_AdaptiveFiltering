# Adaptive Filter GUI

## Description
This program offers a graphical user interface (GUI) for recording audio signals and processing them with adaptive filtering. It records an audio signal, adds noise to create a noisy signal, and then cleans the noisy signal using an LMS adaptive filter. The cleaned signal is amplified and played back. Both the original and filtered signals are saved as audio files.

## Authors:	Marcelo Argotti Gomez
		Juliette Naumann

## Date:	July 4, 2024

__________________________________________________________________

## Usage

### Requirements
- MATLAB
- Signal Processing Toolbox (for `dsp.LMSFilter`)

### How to Run
1. Open MATLAB.
2. Navigate to the directory containing the program files.
3. Run the `filterGui_main.m` script to launch the GUI.

### GUI Overview
The GUI contains the following components:
- **Record Button**: Starts recording an audio signal.
- **Play Original Button**: Plays the original recorded audio signal.
- **Play Noisy Button**: Plays the noisy version of the recorded audio signal.
- **Play Amplified Button**: Plays the cleaned and amplified version of the recorded audio signal.
- **Label**: Displays messages indicating the current operation being performed.

### Steps to Use the Program
1. **Start the GUI**: Run the `filterGui_main.m` script.
2. **Record an Audio Signal**:
   - Click the "Record" button.
   - The GUI will display a message indicating that recording is in progress.
   - The recording will last for a specified duration (default is 5 seconds).
3. **Process the Recorded Signal**:
   - After recording, the program will automatically process the signal by:
     - Adding noise to the recorded signal.
     - Cleaning the noisy signal using LMS adaptive filtering.
     - Amplifying the cleaned signal.
   - Messages will be displayed in the GUI during each step of the processing.
4. **Play Processed Signals**:
   - Use the "Play Original" button to hear the original recorded signal.
   - Use the "Play Noisy" button to hear the noisy signal.
   - Use the "Play Amplified" button to hear the cleaned and amplified signal.
   - The label will display messages indicating which signal is being played.

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
- **Description**: Function to apply adaptive filtering to a recorded audio signal. Generates a noisy signal, cleans it using LMS adaptive filtering, and amplifies the cleaned signal. Plots the original, noisy, cleaned, and amplified signals.
- **Inputs**: 
  - `recorded_audio`: The recorded audio signal.
  - `fs`: The sampling frequency of the recorded audio.
  - `fig`: The GUI figure handle to display messages.
- **Outputs**:
  - `recorded_audio`: The recorded audio signal (unchanged).
  - `noisy_signal`: The generated noisy signal.
  - `cleaned_signal`: The cleaned signal after filtering.
  - `amplifiedAudio`: The amplified cleaned signal.
  - `fs`: The sampling frequency of the signals.
- **Usage**: `[recorded_audio, noisy_signal, cleaned_signal, amplifiedAudio, fs] = adaptFilter(recorded_audio, fs, fig);`

## Notes
- Make sure the microphone is turned on to record the audio signal.
- Ensure that your sound system is turned on to hear the playback of the recorded and processed signals.
- The amplified cleaned signal is saved as `FilteredSignal.wav` in the working directory.
