function [out, intermediate] = liteHaze(input, w_f, c_f)
%LITEHAZE Ultra-lightweight single-image haze removal.
%   out = liteHaze(input) dehazes the RGB image input and returns a uint8
%   image of the same size. Grayscale images are replicated to three
%   channels before processing.
%
%   out = liteHaze(input, w_f, c_f) sets the maximum removal weight w_f
%   and the contrast gain factor c_f.
%
%       w_f  Maximum removal weight, in (0, 1]. The removal weight used
%            for an image is w_f * h, where h is the estimated haze
%            intensity. Default 0.7.
%       c_f  Contrast gain factor, >= 0. The gain applied after radiance
%            recovery is 1 + c_f * h. Default 0.4.
%
%   [out, intermediate] = liteHaze(...) also returns a structure with the
%   intermediate results of each stage, with the following fields:
%
%       A            Atmospheric light, 1x3 RGB vector
%       h            Estimated haze intensity, in [0, 1]
%       w            Adaptive removal weight, w_f * h
%       g            Adaptive contrast gain, 1 + c_f * h
%       darkChannel  Per-pixel minimum channel
%       D_n          Veiling ratio, the minimum channel normalized by
%                    the atmospheric light
%       t_est        Coarse transmission
%       t            Refined transmission after box filtering and
%                    the lower bound
%       J            Recovered radiance before the contrast gain
%
%   The method consists of the following stages:
%       1. Minimum channel             (minChannel)
%       2. Atmospheric light           (atmosphericLight)
%       3. Haze intensity estimation   (hazeIntensity)
%       4. Transmission estimation     (estimateTransmission)
%       5. Radiance recovery and
%          haze-adaptive contrast gain (recoverRadiance)
%
%   Example:
%       img = imread('images/0086.jpg');
%       [out, intermediate] = liteHaze(img);
%       fprintf('Estimated haze intensity: %.3f\n', intermediate.h);
%       imshow([img, out]);
%
%   See also minChannel, atmosphericLight, hazeIntensity,
%   estimateTransmission, recoverRadiance.

    %% Parameters
    if nargin < 2 || isempty(w_f)
        w_f = 0.70;
    end
    if nargin < 3 || isempty(c_f)
        c_f = 0.40;
    end

    validateattributes(input, {'numeric'}, {'nonempty', 'real'}, mfilename, 'input', 1);
    validateattributes(w_f, {'numeric'}, {'scalar', 'real', '>', 0, '<=', 1}, mfilename, 'w_f', 2);
    validateattributes(c_f, {'numeric'}, {'scalar', 'real', '>=', 0}, mfilename, 'c_f', 3);

    if ndims(input) > 3 || ~any(size(input, 3) == [1, 3])
        error('liteHaze:invalidInput', 'Input must be an RGB or grayscale image.');
    end
    if size(input, 3) == 1
        input = repmat(input, 1, 1, 3);
    end

    input = im2double(input);

    %% 1. Minimum channel
    darkChannel = minChannel(input);

    %% 2. Atmospheric light
    A = atmosphericLight(input, darkChannel);

    %% 3. Haze intensity
    [h, D_n] = hazeIntensity(darkChannel, A);

    %% Adaptive parameters
    w = w_f * h;
    g = 1 + c_f * h;

    %% 4. Transmission
    [t, t_est] = estimateTransmission(D_n, w);

    %% 5. Radiance recovery and contrast gain
    [out, J] = recoverRadiance(input, A, t, g);

    out = im2uint8(min(max(out, 0), 1));

    %% Intermediate results
    if nargout > 1
        intermediate = struct('A', A, 'h', h, 'w', w, 'g', g, ...
            'darkChannel', darkChannel, 'D_n', D_n, ...
            't_est', t_est, 't', t, 'J', J);
    end
end
