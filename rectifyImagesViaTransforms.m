function rectifyImagesViaTransforms(tforms, originalDir, ...
    rectifiedDir)

    scaleFactor = 1;
    outputFormat = 'jpg';

    % Load images
    imageDir = fullfile(originalDir);
    images = imageSet(imageDir);

    % Find the minimum and maximum output limits
    imageSize = size(read(images, 1));
    for i = 1:numel(tforms)
        [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), ...
            [1 imageSize(2)], [1 imageSize(1)]);
    end

    xMin = min([1; xlim(:)]);
    xMax = max([imageSize(2); xlim(:)]);

    yMin = min([1; ylim(:)]);
    yMax = max([imageSize(1); ylim(:)]);

    % Final dimensions of each image
    width  = round(xMax - xMin);
    height = round(yMax - yMin);
    imageDimensions = [height width];

    digits = numel(num2str(images.Count));

    for imageNum = 1:images.Count
        I = read(images,imageNum);

        realWorldCoord = imref2d(imageDimensions, [xMin xMax], ...
            [yMin yMax]);
        warpedImage = imresize(imwarp(I, tforms(imageNum),...
            'OutputView', realWorldCoord), scaleFactor);

        imwrite(warpedImage,strcat(rectifiedDir, '/',...
            sprintf(strcat('%0', num2str(digits), 'd'),...
            imageNum), '.', outputFormat),'Quality',100);
    end

end