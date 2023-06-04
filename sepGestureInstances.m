clear all;
close all;
clc;
global X fi nf curAPLoc prvAPLoc nxtAPLoc apInd ofp f fileName quitRequest discardRequest instStart instEnd actionName actionPointInds;
quitRequest = false;
% set input and output paths and create output directory
dataPath = '../data/';
outDir = 'sepinst';
outPath = [dataPath outDir '/'];
if ~exist(outPath, 'dir'),
    mkdir(outPath(1:end-2));
end
% get all sequence file names
seqFileNamesStr = dir([dataPath '*.csv']);
seqFileNames = struct2cell(seqFileNamesStr);
seqFileNames = sort(seqFileNames(1, :))';
nFiles = length(seqFileNames);
% divide work
nParts = 3;
partSize = nFiles / 3;
% Mohamed Hussein
fileInds = 2:floor(partSize);
% Marwan
% fileInds = floor(partSize)+1:floor(2*partSize);
% Mohamed Abdelazeez
% fileInds = floor(2*partSize)+1:nFiles;

for f = fileInds,
    fileName = seqFileNames{f}(1:end-4);
    [X, Y, tagset, T] = load_file(fileName);
    if isempty(X)
        continue;
    end
    actionPointInds = find(sum(Y,2));
    nf = size(X, 1);
    fprintf('%3d: %s\n', f, fileName);
    naps = length(actionPointInds);
    instBounds = zeros(naps, 2);
    instDiscard = false(naps, 1);
    for apInd = 1:naps
        curAPLoc = actionPointInds(apInd);
        if apInd == 1
            prvAPLoc = 0;
        else
            prvAPLoc = actionPointInds(apInd - 1);
        end
        if apInd == naps
            nxtAPLoc = nf + 1;
        else
            nxtAPLoc = actionPointInds(apInd + 1);
        end
        actionName = tagset{boolean(Y(curAPLoc, :))};
        fi = curAPLoc;
        discardRequest = false;
        instStart = Inf;
        instEnd = -Inf;
        fg = figure('WindowStyle', 'docked', 'KeyPressFcn', @keyPressHandler4GestSep);
%         fg = figure('KeyPressFcn', @keyPressHandler4GestSep);
        h = axes;
        skel_vis(X, fi, h);
        title(sprintf('File # %d: %s, Actn: %s, Inst # %d\nFrame # %d', f, strrep(fileName, '_', '-'), actionName, apInd, fi));
        drawnow;
        fprintf('\tInspecting instance # %i/%i: ', apInd, naps);
        waitfor(fg);
        if quitRequest
            break;
        end
        if discardRequest
            instDiscard(apInd) = true;
            continue;
        end
        assert(instEnd > instStart);
        instBounds(apInd, :) = [instStart instEnd];
    end
    if quitRequest
        fprintf('\n');
        break;
    else
        instBounds(instDiscard, :) = [];
        ofp = fopen([outPath fileName '.sep'], 'wt');
        fprintf(ofp, '%5i%5i\n', instBounds');
        fclose(ofp);
    end
end
