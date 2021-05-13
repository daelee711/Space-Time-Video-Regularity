function fd = displacedDifferencing(y_next_blk,y_prev_blk,ii,jj)
% input
%  y_next_blk : luminance block at later time instance (e.g. t+1)
%  y_prev_blk : luminance block at previous time instance (e.g. t)
%  ii, jj = displace vector

% output
%  fd: displaced frame difference

    window = fspecial('gaussian',5,5/6);
    window = window/sum(sum(window)) ;
    
    [width,height,~]=size(y_next_blk);
    n_width=width-abs(jj); n_height=height-abs(ii);
    corner=[min(ii,0),min(jj,0)];

    % corner coord def
    n_corner_next=[0-corner(1),0-corner(2)]+1; 
    n_corner_prev=[ii-corner(1),jj-corner(2)]+1;

    % coord range grab for ref & prev
    next_h_sweep=n_corner_next(1):(n_corner_next(1)+n_height-1);
    prev_h_sweep=n_corner_prev(1):(n_corner_prev(1)+n_height-1);    
    next_w_sweep=n_corner_next(2):(n_corner_next(2)+n_width-1);
    prev_w_sweep=n_corner_prev(2):(n_corner_prev(2)+n_width-1);

    % compute displaced frame differences
    fd=y_next_blk(next_h_sweep,next_w_sweep)-y_prev_blk(prev_h_sweep,prev_w_sweep);
    
end

