function keyPressHandler4GestSep(src, evnt)

global X fi nf curAPLoc prvAPLoc nxtAPLoc apInd f fileName quitRequest discardRequest instStart instEnd actionName seekStart step;

    if isempty(seekStart)
        seekStart = true;
    end
    if isempty(step)
        step = 8;
    end
    
    switch evnt.Key
        case 'space' % move toward start or end of instance (away from peak)
            if seekStart
                fi = max(fi - step, max(1, prvAPLoc+1));
            else
                fi = min(fi + step, min(nf, nxtAPLoc-1));
            end
        case 'b' % move back towards peak
            if step == 8
                step = 4;
            end
            if seekStart
                fi = min(fi + step, curAPLoc);
            else
                fi = max(fi - step, curAPLoc);
            end
        case 'd' % discard this instance
            fprintf('\tBAD INSTANCE - DISCARD!!\n');
            seekStart = true;
            step = 8;
            discardRequest = true;
            close(src);
            return;
        case 's' % save current position
            seekStart = ~seekStart;
            step = 8;
            if seekStart
                fprintf('\tend at # %d\n', fi);
                instEnd = fi;
                %fprintf(ofp, '%5d\n', fi);
                close(src);
            else
                fprintf('\tstart at # %d, ', fi);
                instStart = fi;
                %fprintf(ofp, '%5d\t', fi);
                fi = curAPLoc;
            end
        case 'q' % quit annotating current sequence
            quitRequest = true;
            close(src);
            return;
        case 'uparrow' % increase jump step
            step = step + 1;
        case 'downarrow' % decrease jump step
            step = max(step - 1, 1);
        otherwise
            return;
    end
    
    if ~strcmp(evnt.Key, 's') || ~seekStart
        clf;
        h = axes;
        skel_vis(X, fi, h);
        ttl = sprintf('File # %d: %s, Actn: %s, Inst # %d\nStep = %d, Frame # %d', f, strrep(fileName, '_', '-'), actionName, apInd, step, fi);
        if fi == curAPLoc
            ttl = sprintf('%s (ACTION POINT)', ttl);
        elseif fi == 1
            ttl = sprintf('%s (FIRST FRAME IN SEQUENCE)', ttl);
        elseif fi == nf
            ttl = sprintf('%s (LAST FRAME IN SEQUENCE)', ttl);
        elseif fi == prvAPLoc+1
            ttl = sprintf('%s (RIGHT AFTER PREV ACTION POINT)', ttl);
        elseif fi == nxtAPLoc-1
            ttl = sprintf('%s (RIGHT BEFORE NEXT ACTION POINT)', ttl);
        end
        title(ttl);
        drawnow;
    end
end