function [out_matrix, elapsed_ms] = resample_eeglab_wrapper(signal, n_out, sr_in)
% RESAMPLE_EEGLAB_WRAPPER  Resample one or more signals using EEGLab's pop_resample.
%
%   [out_matrix, elapsed_ms] = resample_eeglab_wrapper(signal, n_out, sr_in)
%
%   signal     - 1-D vector (single window) OR 2-D matrix (n_windows x n_samples)
%   n_out      - desired number of output samples per window
%   sr_in      - input sampling rate (Hz)
%
%   out_matrix - (n_windows x n_out) matrix of resampled windows
%   elapsed_ms - mean pure-MATLAB compute time per window (ms), excluding IPC

signal = double(signal);
if isvector(signal)
    signal = signal(:)';   % ensure row vector, then treat as 1-window matrix
end
% signal is now (n_windows x n_samples)
[n_windows, n_in] = size(signal);
sr_out = sr_in * double(n_out) / double(n_in);

out_matrix = zeros(n_windows, n_out);

t0 = tic;
for i = 1:n_windows
    EEG           = eeg_emptyset();
    EEG.data      = signal(i, :);  % (1 x n_in)
    EEG.srate     = double(sr_in);
    EEG.pnts      = n_in;
    EEG.nbchan    = 1;
    EEG.trials    = 1;
    EEG.xmin      = 0;
    EEG.xmax      = (n_in - 1) / sr_in;
    EEG.times     = (0:(n_in-1)) / sr_in * 1000;
    EEG.chanlocs  = struct('labels', {'signal'});
    EEG.event     = [];
    EEG.epoch     = [];

    EEG = pop_resample(EEG, sr_out);

    row = double(EEG.data(1, :));
    if length(row) > n_out
        row = row(1:n_out);
    elseif length(row) < n_out
        row = [row, repmat(row(end), 1, n_out - length(row))];
    end
    out_matrix(i, :) = row;
end
elapsed_ms = toc(t0) * 1000 / n_windows;  % mean per-window MATLAB time

% For single-window callers: return a column vector for backward compatibility
if n_windows == 1
    out_matrix = out_matrix(:);
end
end
