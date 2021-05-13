function [frOff,dType] = frOffset(fmt)
% works for both 8bit and 10bit
    if strcmp(fmt, 'yuv420p')
        frOff=1.5; dType='uchar';
    elseif strcmp(fmt, 'yuv422p')
        frOff=2; dType='uchar';
    elseif strcmp(fmt, 'yuv444p')
        frOff=3; dType='uchar';
    elseif strcmp(fmt, 'yuv420p10le')
        frOff=3; dType='uint16';
    elseif strcmp(fmt, 'yuv422p10le')
        frOff=4; dType='uint16';
    elseif strcmp(fmt, 'yuv444p10le')
       frOff=6; dType='uint16';
    else % Assume yuv420p if not specified
       frOff=1.5; dType='uchar';
    end

end