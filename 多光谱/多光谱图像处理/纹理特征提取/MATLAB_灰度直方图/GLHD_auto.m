% 鎸囧畾鍩虹鐩綍
baseDir = 'D:\鑼跺彾骞茬嚗杩囩▼\鑼跺彾澶氬厜璋卞浘鍍廫鐑绗簩鎵�140涓牱+姘村垎\7纰捐尪_processed\';

% 鎸囧畾杈撳嚭鐩綍
outputDir = 'D:\鑼跺彾骞茬嚗杩囩▼\鑼跺彾澶氬厜璋卞浘鍍廫鐑绗簩鎵�140涓牱+姘村垎\绾圭悊4\';

% 濡傛灉杈撳嚭鐩綍涓嶅瓨鍦紝鍒欏垱寤�
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% 寰幆閬嶅巻鏂囦欢澶�1鍒�20
for folderIndex = 1:20
    % 鐢熸垚鏂囦欢澶瑰悕
    folderName = num2str(folderIndex);

    % 鍒濆鍖朩L9鐭╅樀
    WL9 = zeros(25, 6);

    % 寰幆閬嶅巻'interestingspace'鏂囦欢澶逛腑鐨勫浘鍍�
    for imageIndex = 1:25
        % 鐢熸垚鏂囦欢鍚�
        filename = fullfile(baseDir, folderName, '25涓尝娈靛搴旂殑鍥惧儚\interestingspace', [num2str(imageIndex), '.bmp']);

        % 浣跨敤鎻愪緵鐨勪唬鐮佽鍙栧拰澶勭悊鍥惧儚
        A = imread(filename);
        A = im2gray(A);
        p = imhist(A);
        p = p ./ numel(A);
        L = length(p);
        [v, mu] = statmoments(p, 3);
        t(1) = mu(1);
        t(2) = mu(2) ^ 0.5;
        varn = mu(2) / (L - 1) ^ 2;
        t(3) = 1 - 1 / (1 + varn);
        t(4) = mu(3) / (L - 1) ^ 2;
        t(5) = sum(p.^2);
        t(6) = -sum(p .* (log2(p + eps)));
        T = [t(1) t(2) t(3) t(4) t(5) t(6)];
        WL9(imageIndex, :) = T;
    end

    % 灏嗙粨鏋滀繚瀛樺埌Excel鏂囦欢
    outputFilename = fullfile(outputDir, sprintf('%03d.xlsx', folderIndex+120));
    writematrix(WL9, outputFilename);
end
