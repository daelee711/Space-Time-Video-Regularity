clear all; clc; close all
%% Specify Parameters here!
% Specify output directory for the frame (with quiver) images to be stored
outputDir='football_quiver_frames\' 

% Video info input
vidInfo=struct;
vidInfo.name='Football_1080p_60hz.yuv';
vidInfo.width=1920;
vidInfo.height=1080;
vidInfo.frameRate=60;
vidInfo.chroma='yuv420p';

% Other Parameters
vidInfo.scaleFactor=1;   
vidInfo.blkSize=301;
fr_200ms=vidInfo.frameRate/5;

%Offset Parameters   
offsetInfo=struct;
offsetInfo.frOffset=[1,2,3]; % Analyze three consecutive frames for stable vector extraction.
offsetInfo.pixOffset=12; % Search range [-12 12]^2
offsetInfo.pixJump=3; % Coarse search for faster computation. Set to 1 for full search.

        
%% Extract displacement vector (once per one source video)
fprintf('1.Extracting the displacement information from %s...\n',vidInfo.name);

% File pointer for input YUV (to visualize each frame)
fp_input = fopen(vidInfo.name, 'r'); 
[frOff,dType] = frOffset(vidInfo.chroma);

% Compute total number of frames through file size.
fseek(fp_input, 0, 1);
file_length = ftell(fp_input);
frameNo = floor(file_length/vidInfo.width/vidInfo.height/frOff);
vidInfo.frameNo=frameNo;

% Compute statistically regular paths block-wise.
[Dx_vol, Dy_vol] = regularPath_video(vidInfo,offsetInfo);

for frIDX=1:frameNo-offsetInfo.frOffset(end) 
    close all
%% ################################_visualizing motion estimation #####################################################       
    rows=vidInfo.height;
    colms=vidInfo.width;
    
    % Frame read
    fseek(fp_input,(frIDX-1)*frOff*colms*rows, 'bof'); 
    y_stream = fread(fp_input, vidInfo.width * vidInfo.height, dType);
    y_plane = reshape(y_stream, [colms rows])';  
    y_plane = imresize(y_plane,vidInfo.scaleFactor);

    % Margin processing
    [rr,cc,nextInd]=size(y_plane);
    r_part_block_no=floor(rr/vidInfo.blkSize);
    c_part_block_no=floor(cc/vidInfo.blkSize);

    r_offset=floor((rr-(r_part_block_no)*vidInfo.blkSize-1)/2+1);
    c_offset=floor((cc-(c_part_block_no)*vidInfo.blkSize-1)/2+1);           
    
    % Depiction of a frame with a quiver plot overlaid
    h=figure;     
    [q_rr,q_cc,~]=size(Dy_vol);
    [Y X]   = ndgrid(1:q_rr, 1:q_cc);          
    sample=40; % Coarse depiction of quiver plots for visualization
    IndexX  = 1:sample:q_cc;
    IndexY  = 1:sample:q_rr;
    imshow(y_plane(r_offset:r_offset+q_rr-1,c_offset:c_offset+q_cc-1)./255)
    hold on
    quiverScale = 1; % Can specify to larger values for larger arrow length.
    quiver(X(IndexY,IndexX),        Y(IndexY,IndexX),...
    Dx_vol(IndexY,IndexX,frIDX), Dy_vol(IndexY,IndexX,frIDX),quiverScale,'r');
    title('Quiver plot: Block Motion')

    saveas(h,[outputDir,vidInfo.name,'_',num2str(frIDX,'%04.f'),'.png']) % Save the quiver plots of each frame to specified folder.
            

end % end of frameNo
fclose(fp_input)

