function demo(inputFile)
    addpath('liteHaze/');

    inputImg = imread(inputFile);

    outputImg = liteHaze(inputImg);

    [~, name, ext] = fileparts(inputFile);
    imwrite(outputImg, strcat(name, "_dehazed", ext), "Quality", 100);
end
