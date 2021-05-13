function kldMap=block_match_gaussian(y_prev_blk,y_next_blk,pixOffset,pixJump)
  bin_width=0.2; % Histogram bin width
    for ii=-pixOffset:pixJump:pixOffset % displacement search ranges
        for jj=-pixOffset:pixJump:pixOffset
                fd=displacedDifferencing(y_next_blk,y_prev_blk,ii,jj);
                %% Construct canonical Gaussian
                GAUSS01=normrnd(0,1,[length(fd(:)),1]);
                [count_ref,edge_ref] = histcounts(GAUSS01(:),'BinWidth',bin_width);
                %% Compute KLD of the empirical distribution w.r.t. canonical Gaussian                
                SDNcoeff=SDN(fd);
                SDNcoeff=unitVarNorm(SDNcoeff);
                [count_emp,edge_emp] = histcounts(SDNcoeff(:),edge_ref);           
                kld=histDist(count_emp,count_ref);            
                kldMap(ii+pixOffset+1,jj+pixOffset+1)=kld;
        end %% end of ii
    end %% end of jj
end % end of function


