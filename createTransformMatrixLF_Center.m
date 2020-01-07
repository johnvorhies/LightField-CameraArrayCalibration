function [tforms] = createTransformMatrixLF_Center(calibrationSetDir,cameraParams)    
    images = imageSet(calibrationSetDir);
    centerIndex = ceil(images.Count/2);
    sizeLF = sqrt(images.Count);
    
    % Detect features of central image
    I = read(images,centerIndex);
    I = undistortImage(I,cameraParams);
    centerGrayImage = rgb2gray(I);
    centerPoints = detectSURFFeatures(centerGrayImage);
    [centerFeatures, centerPoints] = extractFeatures(centerGrayImage, centerPoints);
    
    tforms(images.Count) = projective2d(eye(3));
    
    tic
    % Compute transforms with respect to the central image
    for n = 1:images.Count
        if n == centerIndex
            continue;
        end
        
        I = read(images,n);
        grayImage = rgb2gray(I);
        points = detectSURFFeatures(grayImage);
        [features, points] = extractFeatures(grayImage, points);
        
        indexPairs = matchFeatures(features, ...,
            centerFeatures, 'Unique', true, 'MaxRatio', 0.25);
        matchedPoints = points(indexPairs(:,1), :);
        matchedPointsCenter = centerPoints(indexPairs(:,2), :);
        
        [tforms(n), inlierPointsCurrent, inlierPointsCenter] =...
            estimateGeometricTransform(matchedPoints,matchedPointsCenter,...
            'projective','Confidence', 99.9, 'MaxNumTrials', 2000,...
            'MaxDistance', 100);
    
        %showMatchedFeatures(centerGrayImage,grayImage,inlierPointsCenter,inlierPointsCurrent)
    end
    toc
    
end