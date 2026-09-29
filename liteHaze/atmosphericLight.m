function A = atmosphericLight(img, darkChannel)
%ATMOSPHERICLIGHT Estimate the global atmospheric light.
%   A = atmosphericLight(img, darkChannel) returns the atmospheric light
%   as a 1x3 RGB vector.
%
%   Pixels with the highest minimum-channel values usually have the
%   strongest haze contribution. The top 0.1% of these pixels are
%   selected, and their mean color is used as the atmospheric light.
%   Averaging several candidates instead of taking a single pixel reduces
%   the influence of isolated bright objects such as headlights, traffic
%   lights, and reflective road surfaces.

    [H, W, ~] = size(img);
    K = floor(0.001 * H * W);

    [~, indices] = maxk(darkChannel(:), K);

    pixels = reshape(img, [], 3);
    A = mean(pixels(indices, :), 1);
end
