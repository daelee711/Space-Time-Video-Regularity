function [Dx_vol, Dy_vol] = regularPath_video(vidInfo,offsetInfo)
% Get parameters from vidInfo struct
blkSize=vidInfo.blkSize;
imresizeFactor=vidInfo.scaleFactor; % resize (e.g. 1/2) for faster computation
frameNo = vidInfo.frameNo;

% Open YUV file for displacement vector computation.
fp_input = fopen(vidInfo.name, 'r'); 
[frOff,dType] = frOffset(vidInfo.chroma);

for frIDX=1:frameNo-offsetInfo.frOffset(end)
    fprintf("Processing frame %i\n",frIDX)
    prevFrame = (frIDX-1)+1;
    nextFrames = (frIDX-1)+1+offsetInfo.frOffset;
    
    frame_array=[prevFrame,nextFrames];
    
    % Read frames
    for f_i=1:length(frame_array)
        fseek(fp_input,(frame_array(f_i)-1) * frOff * vidInfo.width * vidInfo.height, 'bof'); % Frame read for 8 bit
        y_stream = fread(fp_input, vidInfo.width * vidInfo.height, dType);
        y_vol(:,:,f_i) = imresize(reshape(y_stream, vidInfo.width , vidInfo.height).',imresizeFactor);
    end
    
    y_prev_planes=y_vol(:,:,1:end-1);
    y_next_planes=y_vol(:,:,2:end);
    
    % Compute block-wise motion map
    [Dx,Dy]=motionMapCompute(y_prev_planes,y_next_planes,blkSize,offsetInfo);
    
    Dx_vol(:,:,frIDX)=Dx;
    Dy_vol(:,:,frIDX)=Dy;     
end
fclose(fp_input);


function [Dx_plane,Dy_plane]=motionMapCompute(y_prev_plane,y_next_plane,blkSize,offsetInfo)
    [rr,cc,nextInd]=size(y_next_plane);
    r_part_block_no=floor(rr/blkSize);
    c_part_block_no=floor(cc/blkSize);
    
    r_offset=floor((rr-(r_part_block_no)*blkSize)/2)+1;
    c_offset=floor((cc-(c_part_block_no)*blkSize)/2)+1; 
    
    progressCounter=1;
    for rr_i=r_offset:blkSize:(r_part_block_no*blkSize)
        for cc_i=c_offset:blkSize:(c_part_block_no*blkSize)
            for n_i=1:nextInd
                y_prev_blk=y_prev_plane(rr_i:rr_i+blkSize-1,cc_i:cc_i+blkSize-1,n_i); 
                y_next_blk=y_next_plane(rr_i:rr_i+blkSize-1,cc_i:cc_i+blkSize-1,n_i);             
                kldMapTemp=block_match_gaussian(y_prev_blk,y_next_blk,offsetInfo.pixOffset,offsetInfo.pixJump); % Statistical regularity map
                kldMap(:,:,n_i)=imresize(kldMapTemp(1:offsetInfo.pixJump:end,1:offsetInfo.pixJump:end),[offsetInfo.pixOffset*2+1,offsetInfo.pixOffset*2+1]);

            end

            kldMap=sum(kldMap,3); % sum up KLD map of three consecutive frames for stable vector extraction 
            marker=100;
            prctl_kl=prctile(kldMap(:),10);% 90 percentile
            kldMap(kldMap>prctl_kl)=marker;          
            
           % Predicted MV for the patch
           [Dy_pred,Dx_pred]=find(kldMap~=marker);
           
           % Coordinate processing & forward direction
           Dy_pred=mean(-1*(Dy_pred-offsetInfo.pixOffset-1)); 
           Dx_pred=mean(-1*(Dx_pred-offsetInfo.pixOffset-1));
                      
           Dy_plane(rr_i-(r_offset-1):rr_i-(r_offset-1)+blkSize-1,cc_i-(c_offset-1):cc_i-(c_offset-1)+blkSize-1)=Dy_pred;
           Dx_plane(rr_i-(r_offset-1):rr_i-(r_offset-1)+blkSize-1,cc_i-(c_offset-1):cc_i-(c_offset-1)+blkSize-1)=Dx_pred;
           
           fprintf("  Processed: %2.2f percent \n",progressCounter*100/(r_part_block_no*c_part_block_no)) 
           progressCounter=progressCounter+1;
        end %% end of rr_i 
    end %% end of cc_i
end



end % end of function



