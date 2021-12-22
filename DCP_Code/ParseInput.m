% Written by S. Hossein Khatoonabadi (skhatoon@sfu.ca)
%
% define some constant parameters for an input video sequence
% 
% Input
%     SEQ_DIR: (string) root directory
%     FORMAT: (string) format of encoding
%     SEQ_NAME: (string) input sequence
%     
% Output
%     OUT_VDO: (string) file name of output YUV video sequence
%     IN_VDO: (string) file name of input YUV video sequence
%     IN_FRAME: (string) path of types.txt containing frame types
%     IN_MV: (string) path and prefix file name of motion vectors
%     IN_MBTYPE: (string) path and prefix file name of macroblock types
%     IN_MBTYPE: (string) path and prefix file name of DCT values
%     FRMS_CNT: (integer value) number of frames in the sequence
%     FRM_RATE: (integer value) frame rate of the sequence
%     IMG_H: (integer value) number of horizontal pixels (height)
%     IMG_W: (integer value) number of vertical pixels (width)
%     BLK_SZ: (integer value) block size
%     HALFPIX: (integer value) indicating 1/n-pel motion compensation

function [OUT_VDO,IN_VDO,IN_FRAME,IN_MV,IN_MBTYPE,IN_DCT,FRMS_CNT,FRM_RATE,IMG_W,IMG_H,BLK_SZ,PEL_MC] = ParseInput(SEQ_DIR,FORMAT,SEQ_NAME)

OUT_VDO = [SEQ_DIR SEQ_NAME filesep FORMAT filesep 'seq.yuv'];
IN_VDO = [SEQ_DIR SEQ_NAME filesep 'seq.yuv'];
IN_FRAME = [SEQ_DIR SEQ_NAME filesep FORMAT filesep];
IN_MV = [SEQ_DIR SEQ_NAME filesep FORMAT filesep 'mv_'];
IN_MBTYPE = [SEQ_DIR SEQ_NAME filesep FORMAT filesep 'mbtype_'];
IN_DCT = [SEQ_DIR SEQ_NAME filesep FORMAT filesep 'dct_'];

% extract parameter information
parname = [SEQ_DIR SEQ_NAME filesep 'par.cfg'];
if ~exist(parname,'file')
    error(['The program cannnot find ' parname])
end
fid = fopen(parname,'rt');
par=fgetl(fid);
while par ~= -1
    switch par
        case 'NAME'
            name=upper(fgetl(fid));
            if name ~= upper(SEQ_NAME)
                error(['the names are different: ' SEQ_NAME 'and ' name]);
            end
        case 'FRAMESCOUNT'
            FRMS_CNT=str2double(fgetl(fid));
        case 'FRAMERATE'
            FRM_RATE=str2double(fgetl(fid));
        case 'IMAGEWIDTH'
            par=fgetl(fid);
            IMG_W = str2double(par);
        case 'IMAGEHIEGHT'
            par=fgetl(fid);
            IMG_H = str2double(par);
    end
    par=fgetl(fid);
end
fclose(fid);

PEL_MC = 4;
if isempty(strfind(FORMAT,'264')) && isempty(strfind(FORMAT,'RDO'))
    BLK_SZ = 8;
else
    BLK_SZ = 4;
end
% BLK_SZ = 8;