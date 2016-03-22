function [ estVDCT, estVHaar, estVRand ] = GetKurtNoiseMaps( im )
    if numel(im)>55*(2^12)
        disp('too big');
        [ estVDCT, estVHaar, estVRand ] = GetKurtNoiseMaps_lowmem( im );
    else
        [ estVDCT, estVHaar, estVRand ] = GetKurtNoiseMaps_highmem( im );
    end
end

