function [t, t_est] = estimateTransmission(D_n, w)
%ESTIMATETRANSMISSION Estimate and refine the transmission map.
%   [t, t_est] = estimateTransmission(D_n, w) returns the refined
%   transmission t and the coarse transmission t_est, given the veiling
%   ratio D_n and the adaptive removal weight w.
%
%   The coarse transmission follows the dark channel prior:
%
%       t_est = 1 - w * D_n
%
%   A hazier image has a larger w and a strongly hazed pixel has a larger
%   D_n, and both lower the transmission. Because the per-pixel minimum
%   channel contains local fluctuations, t_est is smoothed with a 7x7 box
%   filter. The result is limited to a lower bound of 0.1, which prevents
%   division by a value close to zero during radiance recovery.

    boxSize = 7;
    t0 = 0.1;

    t_est = 1 - w * D_n;

    t = imboxfilt(t_est, boxSize);
    t = max(t, t0);
end
