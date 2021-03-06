function [tforms] = createTransformMatrixLF_Checkerboard(checkerboardDir)    
    images = imageSet(checkerboardDir);
    centerIndex = ceil(images.Count/2);
    checkerboardImagesPath = images.ImageLocation;
    
    [imagePoints, ~] = detectCheckerboardPoints(checkerboardImagesPath);
    I = read(images,centerIndex);
    centerGrayImage = rgb2gray(I);
    
    tforms(images.Count) = projective2d(eye(3));
    
    % Compute transforms with respect to the central image
    for n = 1:images.Count
        if n == centerIndex
            continue;
        end
        
        I = read(images,n);
        grayImage = rgb2gray(I);
        
        [tforms(n), inlierPointsCurrent, inlierPointsCenter] =...
            estimateGeometricTransform(imagePoints(:,:,n),...
            imagePoints(:,:,centerIndex),'projective','Confidence',...
            99.9, 'MaxNumTrials', 2000,'MaxDistance',100);
    
        %showMatchedFeatures(centerGrayImage,grayImage,inlierPointsCenter,inlierPointsCurrent)
    end
    
end