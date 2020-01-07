% John Vorhies, 11.20.19
% Convert camera gantry .tif/.jpg to st_uv.mat
function [st_uv, st_uv_rgb] = image2stuv(imageDir)
    bitDepth = 'uint8';

    images_rgb = imageSet(imageDir);
    [dimY,dimX,~] = size(read(images_rgb,1));
    lightfieldDim = sqrt(images_rgb.Count);

    images = zeros(dimY,dimX,lightfieldDim^2,bitDepth);

    for k = 1:lightfieldDim^2
        images(:,:,k) = rgb2gray(read(images_rgb,k));
    end

    %Parameterize images to (s,t,u,v)

    st_uv_rgb = zeros(lightfieldDim,lightfieldDim,dimY,dimX,3,bitDepth);
    i = 1; %images counter
    for nt = 1:lightfieldDim
        for ns = 1:lightfieldDim
            st_uv_rgb(nt,ns,:,:,:) = read(images_rgb,i);
            i = i+1;
        end
    end

    images_rgb = [];

    st_uv = zeros(lightfieldDim,lightfieldDim,dimY,dimX,bitDepth);
    i = 1;
    for nt = 1:lightfieldDim
        for ns = 1:lightfieldDim
            st_uv(nt,ns,:,:) = images(:,:,i);
            i = i+1;
        end
    end

    images = [];
end


