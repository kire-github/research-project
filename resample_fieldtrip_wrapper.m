function [out_matrix, elapsed_ms] = resample_fieldtrip_wrapper(signal, n_out, sr_in)
% RESAMPLE_FIELDTRIP_WRAPPER  Resample one or more signals using FieldTrip's ft_resampledata.
%
%   [out_matrix, elapsed_ms] = resample_fieldtrip_wrapper(signal, n_out, sr_in)
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
sr_out  = sr_in * double(n_out) / double(n_in);
times_s = (0:(n_in-1)) / double(sr_in);

cfg            = struct();
cfg.resamplefs = sr_out;
cfg.detrend    = 'no';
cfg.demean     = 'no';

out_matrix = zeros(n_windows, n_out);

t0 = tic;
for i = 1:n_windows
    data.trial   = {signal(i, :)};
    data.time    = {times_s};
    data.label   = {'signal'};
    data.fsample = double(sr_in);

    data_out = ft_resampledata(cfg, data);

    row = double(data_out.trial{1}(1, :));
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
