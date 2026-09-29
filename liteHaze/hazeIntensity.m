function [h, D_n] = hazeIntensity(darkChannel, A)
%HAZEINTENSITY Estimate the haze intensity of an image.
%   [h, D_n] = hazeIntensity(darkChannel, A) returns the haze intensity h
%   in [0, 1] and the per-pixel veiling ratio D_n.
%
%   The veiling ratio is the minimum channel normalized by the largest
%   component of the atmospheric light. It is clipped to 1 so that pixels
%   brighter than the atmospheric light, such as headlights or specular
%   reflections, do not produce a negative transmission.
%
%   In a clear scene, dark regions stay close to 0 and bright regions stay
%   close to 1, so D_n has a wide spread. Haze raises dark pixels toward
%   the atmospheric light more than bright ones, so the spread narrows as
%   the haze becomes thicker. The spread is measured with the 5th and 95th
%   percentiles, which are robust to outlier pixels, and the haze
%   intensity is its complement:
%
%       h = clip(1 - (P95(D_n) - P5(D_n)), 0, 1)

    D_n = min(darkChannel ./ max(A), 1.0);

    p = prctile(D_n(:), [5, 95]);
    spread = p(2) - p(1);

    h = min(max(1 - spread, 0), 1);
end
