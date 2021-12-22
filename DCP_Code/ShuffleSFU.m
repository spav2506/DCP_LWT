function sigmaShuffle = ShuffleSFU

SetEnvConst

SHUFFLE_SZ = [288 352];
totalShufMap = zeros(SHUFFLE_SZ);
shufMap = zeros(SHUFFLE_SZ);

SEQs = MyDir(SFU_DIR);
for seqIndex = 1:numel(SEQs)
    SEQ_NAME = char(SEQs(seqIndex));
    
    [~,~,~,~,~,~,FRMS_CNT,~,IMG_W,IMG_H,~,~] = ...
        ParseInput(SFU_DIR,'',SEQ_NAME); FRMS_CNT = FRMS_CNT - 1;
    
    [fixMap1,~] = GetFixationsSFU(SFU_DIR,SEQ_NAME,FRMS_CNT,IMG_H,IMG_W);
    if ~isequal(size(fixMap1(:,:,1)),SHUFFLE_SZ)
        fixMap1 = imresize(fixMap1,SHUFFLE_SZ,'bilinear');
    end
    shufMap = shufMap + sum(fixMap1,3);
end

totalShufMap = totalShufMap + shufMap;
shufMap = round(totalShufMap);

% fit a 2-d gaussian distribution to the shuffle map
n = max(shufMap(:));
rs = []; cs = [];
for i=1:n
    [r,c] = find(shufMap>=i);
    rs = [rs;r];
    cs = [cs;c];
end
mu = (SHUFFLE_SZ+1)/2;
varx = sum(((rs-mu(1)).^2))/length(rs);
vary = sum(((cs-mu(2)).^2))/length(cs);
sigmaShuffle = [varx 0;0 vary];
