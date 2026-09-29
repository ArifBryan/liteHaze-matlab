function [out, J] = recoverRadiance(img, A, t, g)
%RECOVERRADIANCE Recover the scene radiance and apply the contrast gain.
%   [out, J] = recoverRadiance(img, A, t, g) returns the final dehazed
%   image out and the recovered radiance J before the contrast gain.
%
%   The radiance is recovered by inverting the atmospheric scattering
%   model I = J * t + A * (1 - t):
%
%       J = (I - A) / t + A
%
%   The haze-adaptive contrast gain g = 1 + c_f * h is then applied around
%   the atmospheric light:
%
%       out = (J - A) * g + A
%
%   This is equivalent to radiance recovery with an effective transmission
%   t / g. The spatially varying map t carries the local haze variation,
%   while g sets a global restoration strength that removes the residual
%   veil left by the conservative removal weight. The output is not
%   clipped here.

    A_img = reshape(A, 1, 1, 3);

    J = (img - A_img) .* (1.0 ./ t) + A_img;

    out = (J - A_img) * g + A_img;
end
