function [p] = getPcorrect(colour, grid, vars)
    prob = 0;
    tilesSeen = sum(sum(grid~=0));
    chosenTiles = sum(sum(grid==colour));
    z = vars.gridDimX*vars.gridDimY;
    z = z - tilesSeen;
    k = ceil((vars.gridDimX*vars.gridDimY)/2);
    k = k - chosenTiles;
    if (k < 0)
        k = 0;
    end
    if (k <= z)
        while (k <= z)
            prob = prob + nchoosek(z,k);
            k = k+1;
        end
        prob = prob/(2^z);
    else
        prob = 1;
    end
    p = prob;
end