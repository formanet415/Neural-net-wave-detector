function spectrum_converter(CDF_DIR)
% does the same thing as DATASET_GENERATOR except it just does the spectrum
% conversion and is not meant for creating training data
%   Inputs:
%       path to cdf file
%


if ~exist(CDF_DIR, 'file')
    error('CDF dir does not exist');
    return
end


cdf = cdf_load_tswf(CDF_DIR);

for i=1:length(cdf.WAVEFORM_DATA.data(1,1,:))
    if cdf.SAMPS_PER_CH.data(i,1) == 8192
        
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
        
        disp(sprintf('0_%u.png', i))
        imwrite(sp,fullfile('converted_tswf_spectra_blind_data',sprintf('%u.png',i)))
        
    end
    if cdf.SAMPS_PER_CH.data(i,1) == 8192*2
        
        fs = cdf.SAMPLING_RATE.data(i,1);
        data = convert_to_SRF(cdf, i);
        
        temp = size(data);
        
        data1 = data(:,1:temp(2)/2);
        data2 = data(:,temp(2)/2+1:end);
        
        data = data1;
        
        sp1 = spectrogram(data(1,:), 64, 0, 200, fs, "yaxis");
        sp2 = spectrogram(data(2,:), 64, 0, 200, fs, "yaxis");
        sp = abs(sp1)+abs(sp2);
        rowmin = min(sp, [],2);
        rowmax = max(sp, [],2);
        sp = rescale(sp,0,1);%,'InputMin',rowmin,'InputMax',rowmax);
        [n,m] = size(sp);
        sp = sp(fix(n*0.6):-1:1,:);
        %sp = rescale(abs(sp),0,255);
        
        disp(sprintf('0_%u.png', i))
        imwrite(sp,fullfile('converted_tswf_spectra_blind_data',sprintf('%u_1.png',i)))
        
        data = data2;
        
        sp1 = spectrogram(data(1,:), 64, 0, 200, fs, "yaxis");
        sp2 = spectrogram(data(2,:), 64, 0, 200, fs, "yaxis");
        sp = abs(sp1)+abs(sp2);
        rowmin = min(sp, [],2);
        rowmax = max(sp, [],2);
        sp = rescale(sp,0,1);%,'InputMin',rowmin,'InputMax',rowmax);
        [n,m] = size(sp);
        sp = sp(fix(n*0.6):-1:1,:);
        %sp = rescale(abs(sp),0,255);
        
        disp(sprintf('0_%u.png', i))
        imwrite(sp,fullfile('converted_tswf_spectra_blind_data',sprintf('%u_2.png',i)))
        
    end
end
end

