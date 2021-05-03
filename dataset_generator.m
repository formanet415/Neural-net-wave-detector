function dataset_generator(CDF_DIR, dotTXT_DIR)
%DATASET_GENERATOR This function creates a structured database for CNN
%training.
%   Inputs:
%
%


if ~exist(CDF_DIR, 'file')
    error('CDF dir does not exist');
    return
end
if ~exist(dotTXT_DIR, 'file')
    error('Text file dir does not exist');
    return
end

cdf = cdf_load_tswf(CDF_DIR);

load(dotTXT_DIR)
ind = 0;
indsus = 0;
for i=1:length(cdf.WAVEFORM_DATA.data(1,1,:))
    if cdf.SAMPS_PER_CH.data(i,1) == 8192 && i < final_index
        if ismember(i, indexes)
            sus = 1;
            tind = indsus+1;
            indsus = indsus+1;
        else
            sus = 0;
            tind = ind+1;
            ind = ind+1;
        end
        
        fs = cdf.SAMPLING_RATE.data(i,1);
        data = convert_to_SRF(cdf, i);
        
        sp1 = spectrogram(data(1,:), 64, 0, 200, fs, "yaxis");
        sp2 = spectrogram(data(2,:), 64, 0, 200, fs, "yaxis");
        sp = abs(sp1)+abs(sp2);
        rowmin = min(sp, [],2);
        rowmax = max(sp, [],2);
        sp = rescale(sp,0,1);%,'InputMin',rowmin,'InputMax',rowmax);
        [n,m] = size(sp);
        sp = sp(fix(n*0.6):-1:1,:);
        %sp = rescale(abs(sp),0,255);
        
        disp(sprintf('0_%u.mat', i))
        imwrite(sp,fullfile('dataset',num2str(sus),sprintf('%u_%u.png',sus,tind)))
        
    end
end
end

