%% INITIAL CONFIGURATIONS
clear; clc; close all;

% Timer clock frequency (e.g., 72 MHz for STM32F1)
timerClock  = 72e6;

% Desired PWM frequency (Hz).
desiredFreq = 10e3; % Example: 10 kHz

% Prescaler (PSC) range (16-bit for STM32F1)
pscMin = 0;
pscMax = 65535;

% Relative error tolerance as a fraction. Example: 1% = 0.01
tolerance = 0.01;

%% VECTORIZED CALCULATION
% Create vector of PSC values.
pscVec = (pscMin:pscMax)';

% Compute ARR for each PSC value:
% desiredFreq = timerClock / ((PSC+1)*(ARR+1))  ==>  ARR = (timerClock/((PSC+1)*desiredFreq))-1
arrFloat = (timerClock ./ ((pscVec + 1) * desiredFreq)) - 1;
arrVec   = round(arrFloat);

% Filter valid ARR values (ARR must be between 1 and 65535).
validIndices = (arrVec >= 1) & (arrVec <= 65535);
pscValid = pscVec(validIndices);
arrValid = arrVec(validIndices);

% Calculate the actual PWM frequency for valid combinations.
freqReal = timerClock ./ ((pscValid + 1) .* (arrValid + 1));

% Calculate the relative error.
relError = abs(freqReal - desiredFreq) / desiredFreq;

% Filter configurations that are within the tolerance.
withinTolerance = relError <= tolerance;
pscFinal       = pscValid(withinTolerance);
arrFinal       = arrValid(withinTolerance);
freqFinal      = freqReal(withinTolerance);
relErrorFinal  = relError(withinTolerance);

% Approximate the bits resolution as floor(log2(ARR+1)).
bitsResolution = floor(log2(arrFinal + 1));

%% ORGANIZE RESULTS INTO A TABLE AND SORT
resultsTable = table(pscFinal, arrFinal, freqFinal, relErrorFinal, bitsResolution, ...
    'VariableNames', {'PSC','ARR','RealFrequency_Hz','RelError','BitsResolution'});

% Sort rows by relative error (from smallest to largest).
resultsTable = sortrows(resultsTable, 'RelError');

%% DISPLAY RESULTS
disp(resultsTable);

% Optionally, save to CSV:
% writetable(resultsTable, 'PWM_Configurations_Vectorized.csv');
