 ROOT = '..\';

ffmpegPath = [pwd '\Windows\'];
ffmpeg_o_run = [ffmpegPath 'ffmpeg-o.exe '];
ffmpeg_run = [ffmpegPath 'ffmpeg.exe '];

DIEM_FRMS_CNT = 300;
DIEM_IMG_H = 288; % but preserve the ratio

SRC_DIEM = [ROOT 'DIEM' filesep];
DIEM_DIR = [ROOT 'SEQ_DIEM' filesep];
SFU_DIR = [ROOT 'SEQ_SFU' filesep];

flagEncode = true;

QPs = 3:3:51;
QPs=30;

FORMAT = 'H264_QP30';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for Unix users
%%%%%%%%%%%%%%%%
% ffmpeg-o is the original ffmpeg configured by
% ./configure --prefix="$HOME/ffmpeg_build"
% --extra-cflags="-I$HOME/ffmpeg_build/include"
% --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin"
% --extra-libs=-ldl --enable-gpl --enable-libx264
% [change the name of ffmpeg in "bin" dierectory to ffmpeg-o]

% configured the modified source code by
% ./configure --prefix="$HOME/ffmpeg_build"
% --extra-cflags="-I$HOME/ffmpeg_build/include"
% --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin"
% --disable-pthreads --disable-dxva2 --disable-vaapi --disable-vdpau
% --disable-optimizations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
