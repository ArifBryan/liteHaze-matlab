function darkChannel = minChannel(img)
%MINCHANNEL Per-pixel minimum over the RGB channels.
%   darkChannel = minChannel(img) returns the minimum of the three color
%   channels at each pixel of the double image img.
%
%   The original dark channel prior takes the minimum over the color
%   channels and over a local patch around each pixel. liteHaze keeps the
%   channel minimum but removes the patch minimum, so each pixel is
%   processed independently without buffering neighboring pixels. For an
%   image with N pixels this requires about 2N comparisons instead of
%   3Nk^2 for a k x k patch.

    darkChannel = min(img, [], 3);
end
