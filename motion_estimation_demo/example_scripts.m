clear all; clc; close all
%% Input video information here
vidInfo=struct;

vidInfo.name='Football_1080p_60hz.yuv';
vidInfo.width=1920;
vidInfo.height=1080;
vidInfo.frameRate=60;
vidInfo.chroma='yuv420p';

%% Example 1: Searching statistically regular (motion) vector
fprintf('[Example 1]\n')
fprintf('We grab a block from frame 1, and track where it moves to on frame 3 using statistical regularity.\n')
% Extract Y components of frame 1 and frame 3
frameIdx=[1,3]; % frame 1 and frame 3
frameVol = frameExtract(vidInfo,frameIdx);
fr1=frameVol(:,:,1);
fr2=frameVol(:,:,2);

% Bounding box coordinate from first frame
bbox=struct;
bbox.x=1300; bbox.y=200; % Left top corner coordinate
bbox.size=200; % Box width/height
figure(1); imshow(fr1(bbox.y:bbox.y+bbox.size,bbox.x:bbox.x+bbox.size)./255); % Uncomment to see bounding box contents

% Search statistically regular displacement vector
[Dx, Dy] = regularPath(fr1,fr2,bbox);

fprintf('The statistically regular path for the block shown in figure 1 is (dx,dy)=(%.2f,%.2f)\n\n',Dx,Dy)

%% Example 2: Getting SDN (eq.5) coefficients from displaced frame differences (with given displacement vector)
fprintf('[Example 2]\n')
fprintf('Given a block and its corresponding displacement vector, we compute the SDN coefficients.\n')
Dx=2; Dy=0; % Given displacement vector

% Block extraction
fr1_block=fr1(bbox.y:bbox.y+bbox.size,bbox.x:bbox.x+bbox.size); % block from frame1
fr2_block=fr2(bbox.y:bbox.y+bbox.size,bbox.x:bbox.x+bbox.size); % block from frame2

% Take displaced frame difference
fd=displacedDifferencing(fr2_block,fr1_block,-1*Dy,-1*Dx); % Note: -1 multiplied for directional reason

% Compute SDN coefficients
SDNplane=SDN(fd);
SDNcoeff=SDNplane(:);

figure(2); imshow(SDNplane); title('SDN coefficients')
fprintf('Figure 2 visualizes the SDN coefficients of the displaced frame differences.\n')
fprintf('The SDN coefficients are stored in SNDcoeff array.\n')

