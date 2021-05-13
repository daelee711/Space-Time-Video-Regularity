function SDNcoeff = SDN(fd)
%% Stabilization constant
    C=0.5;

%% Window definition      
    window_2d = fspecial('gaussian',5,5/6); % L=M=5
    window_2d = window_2d/sum(sum(window_2d)); % 2D Gaussian rescaled to unit volume

%% Divisive normalization
    fd_sq=fd.*fd; % X^2
    mu_fd = imfilter(fd,window_2d,'replicate');% E[X]
    
    fd_sq= imfilter(fd_sq,window_2d,'replicate');% E[X^2]                
    mu_sq=mu_fd.*mu_fd; % (E[X])^2
    
    sigma=sqrt(abs(fd_sq-mu_sq));% std = sqrt( E[X^2]-(E[X])^2)  
    SDNcoeff=(fd)./(sigma+C);


end

