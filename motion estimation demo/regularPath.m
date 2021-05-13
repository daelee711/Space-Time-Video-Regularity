function [Dx_pred, Dy_pred] = regularPath(frame1,frame2,bbox)
    % Offset setting for KLD map
    offsetInfo=struct;
    offsetInfo.pixOffset=12; % search range
    offsetInfo.pixJump=3; % 1: full search. Set other values to perform coarse search(faster)
    
    % Block extraction
    fr1_block=frame1(bbox.y:bbox.y+bbox.size,bbox.x:bbox.x+bbox.size); % block from frame1
    fr2_block=frame2(bbox.y:bbox.y+bbox.size,bbox.x:bbox.x+bbox.size); % block from frame2
                 
    kldMapTemp=block_match_gaussian(fr1_block,fr2_block,offsetInfo.pixOffset,offsetInfo.pixJump);
    kldMap=imresize(kldMapTemp(1:offsetInfo.pixJump:end,1:offsetInfo.pixJump:end),[offsetInfo.pixOffset*2+1,offsetInfo.pixOffset*2+1]);
    marker=100;
    prctl_kl=prctile(kldMap(:),10);% 90 percentile
    kldMap(kldMap>prctl_kl)=marker;
            
            
    % Predicted MV for the patch
    [Dy_pred,Dx_pred]=find(kldMap~=marker);
    
    % Coordinate processing & forward direction
    Dy_pred=mean(-1*(Dy_pred-offsetInfo.pixOffset-1)); 
    Dx_pred=mean(-1*(Dx_pred-offsetInfo.pixOffset-1));
    
    
end





