function frameVol = frameExtract(vidInfo,frameIdx)
fp_input=fopen(vidInfo.name,'r'); 
[frOff,dType] = frOffset(vidInfo.chroma); %yuv420p --> (frOffset,dType)=(1.5,'uchar')

    for i=1:length(frameIdx)
        fseek(fp_input, (frameIdx(i)-1) * frOff * vidInfo.width * vidInfo.height, 'bof');% Move pointer to next frame
        y_stream = fread(fp_input, vidInfo.width * vidInfo.height, dType); 
        y_frame = reshape (y_stream,vidInfo.width , vidInfo.height).';
        frameVol(:,:,i)=y_frame;
    end

fclose(fp_input);
end

