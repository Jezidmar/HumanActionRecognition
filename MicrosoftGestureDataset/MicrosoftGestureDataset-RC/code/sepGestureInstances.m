clear;
close all;
clc;

% Declare global variables
global X fi nf curAPLoc prvAPLoc nxtAPLoc apInd ofp f fileName quitRequest discardRequest instStart instEnd actionName actionPointInds;

quitRequest = false;

% Set input and output paths and create output directory if it doesn't exist
dataPath = '../data/';
outDir = 'sepinst';
outPath = fullfile(dataPath, outDir);
if ~exist(outPath, 'dir')
    mkdir(outPath);
end

% Get all sequence file names
seqFileNamesStr = dir(fullfile(dataPath, '*.csv'));
seqFileNames = {seqFileNamesStr.name}';
seqFileNames = sort(seqFileNames);
nFiles = length(seqFileNames);

% Divide work
nParts = 3;
partSize = nFiles / nParts;

% Set file indices for processing
fileInds = 2:floor(partSize); % Change this depending on which part you want to process

% Loop through files
for f = fileInds
    fileName = seqFileNames{f}(1:end-4);
    [X, Y, tagset,T] = load_file(fileName);
    if isempty(X)
        continue;
    end
    
    actionPointInds = find(sum(Y, 2));
    nf = size(X, 1);
    fprintf('%3d: %s\n', f, fileName);
    
    naps = length(actionPointInds);
    instBounds = zeros(naps, 2);
    instDiscard = false(naps, 1);
    
    for apInd = 1:naps
        curAPLoc = actionPointInds(apInd);
    
        % Handle previous action point location
        if apInd == 1
            prvAPLoc = 0;
        else
            prvAPLoc = actionPointInds(apInd - 1);
        end
    
        % Handle next action point location
        if apInd == naps
            nxtAPLoc = nf + 1;
        else
            nxtAPLoc = actionPointInds(apInd + 1);
        end
        
        actionName = tagset{logical(Y(curAPLoc, :))};
        fi = curAPLoc;
        discardRequest = false;
        instStart = Inf;
        instEnd = -Inf;
    
        % Create a docked figure and set the key press function

    
        
    
        instBounds(apInd, :) = [instStart instEnd];
    end
    if quitRequest
        fprintf('\n');
        break;
    else
        instBounds(instDiscard, :) = [];
        disp(instBounds)
        ofp = fopen(fullfile(outPath, [fileName '.sep']), 'wt');
        fprintf(ofp, '%5i%5i\n', instBounds');
        fclose(ofp);
    end
end


