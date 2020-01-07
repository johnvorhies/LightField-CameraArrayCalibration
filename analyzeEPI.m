function analyzeEPI(st_uv)
    [Nt,Ns,Nv,Nu,Nc] = size(st_uv);
    st_center = ceil(Nt/2);
    u_center = ceil(Nu/2);
    v_center = ceil(Nv/2);
    
    fftsize = max(size(st_uv));
    
    if Nc == 1
        EPI = squeeze(st_uv(st_center,:,1082,:));
        EPI_fft = fftshift(fft2(EPI,fftsize,fftsize));
        EPI_fft = abs(EPI_fft);
        EPI_fft = log(EPI_fft+10e-6);
        EPI_fft = EPI_fft/max(EPI_fft(:));
        
        figure
        mesh(EPI_fft)
        xlabel('u')
        ylabel('s')
        view([90 270])
    else
        EPI = squeeze(st_uv(st_center,:,3066,:,:));
        
        figure
        image(EPI)
        
        EPI_gray = rgb2gray(EPI);
        EPI_fft = fftshift(fft2(EPI_gray,fftsize,fftsize));
        EPI_fft = abs(EPI_fft);
        EPI_fft = log(EPI_fft+10e-6);
        EPI_fft = EPI_fft/max(EPI_fft(:));
        
        figure
        mesh(EPI_fft)
        xlabel('u')
        ylabel('s')
        view([90 270])
    end
end