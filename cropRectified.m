function cropRectified(rectifiedDir, croppedDir)    
    outputFormat = 'jpg';

    rectified_images = imageSet(rectifiedDir);
    center = rectified_images.Count;
    center = ceil(center/2);
    figure
    [~,rect] = imcrop(read(rectified_images,center));

    for k = 1:rectified_images.Count
        I = read(rectified_images,k);
        I = imcrop(I,rect);
        imwrite(I,strcat(croppedDir, '/',...
            num2str(k), '.', outputFormat), 'Quality', 100);
    end
end