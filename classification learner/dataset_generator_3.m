

function ft = dataset_generator_3(CDF, dotTXT_DIR)
%DATASET_GENERATOR This function creates 
%training.
%   Inputs:
%
%



cdf = CDF; %cdf_load_tswf(CDF_DIR);
load(dotTXT_DIR) %#ok<LOAD>
n_samples = length(cdf.WAVEFORM_DATA.data(1,1,:));
if exist('final_index') %#ok<EXIST>
    n_samples = final_index;
end
class = string.empty(n_samples,0);
meanValueY = double.empty(n_samples,0);
meanValueZ = double.empty(n_samples,0);
medianValueY = double.empty(n_samples,0);
medianValueZ = double.empty(n_samples,0);
stdY = double.empty(n_samples,0);
stdZ = double.empty(n_samples,0);
madY = double.empty(n_samples,0);
madZ = double.empty(n_samples,0);
quantile25Y = double.empty(n_samples,0);
quantile25Z = double.empty(n_samples,0);
quantile75Y = double.empty(n_samples,0);
quantile75Z = double.empty(n_samples,0);
iqrY = double.empty(n_samples,0);
iqrZ = double.empty(n_samples,0);
sampleSkewnessY = double.empty(n_samples,0);
sampleSkewnessZ = double.empty(n_samples,0);
minvalY = double.empty(n_samples,0);
minvalZ = double.empty(n_samples,0);
maxvalY = double.empty(n_samples,0);
maxvalZ = double.empty(n_samples,0);
separationY = double.empty(n_samples,0);
separationZ = double.empty(n_samples,0);
fpeakValY = double.empty(n_samples,0);
fpeakFrqY = double.empty(n_samples,0);
fpeakValZ = double.empty(n_samples,0);
fpeakFrqZ = double.empty(n_samples,0);

for i=1:n_samples
    if ismember(i, indexes)
        class(i,1)='ESW';
    else
        class(i,1)='EMPTY';
    end
    
    data = convert_to_SRF(cdf, i);
    
    meanValueY(i,1) = mean(data(1,:));
    meanValueZ(i,1) = mean(data(2,:));
    medianValueY(i,1) = median(data(1,:));
    medianValueZ(i,1) = median(data(2,:));
    stdY(i,1) = std(data(1,:));
    stdZ(i,1) = std(data(2,:));
    madY(i,1) = mad(data(1,:));
    madZ(i,1) = mad(data(2,:));
    quantile25Y(i,1) = quantile(data(1,:),0.25);
    quantile25Z(i,1) = quantile(data(2,:),0.25);
    quantile75Y(i,1) = quantile(data(1,:),0.75);
    quantile75Z(i,1) = quantile(data(2,:),0.75);
    iqrY(i,1) = iqr(data(1,:));
    iqrZ(i,1) = iqr(data(2,:));
    
    %fs = cdf.SAMPLING_RATE.data(i,1);
    %[freq, psdsx] = getPSDmate(data(1,:), fs)
    
    [minvalY(i,1), maxvalY(i,1), separationY(i,1)] = getPeakFeatures(data(1,:));
    [minvalZ(i,1), maxvalZ(i,1), separationZ(i,1)] = getPeakFeatures(data(2,:));
    
    samps = cdf.SAMPS_PER_CH.data(i);
    sr = cdf.SAMPLING_RATE.data(i);
    dt = 1./sr;
    [spY, fqY, ~] = make_spectrum(data(1,:),fix(samps),dt,100000,0);
    specY = log10(spY);
    [spZ, fqZ, ~] = make_spectrum(data(2,:),fix(samps),dt,100000,0);
    specZ = log10(spZ);
    
    [fpeakValY(i,1), ind] = max(specY);
    fpeakFrqY(i,1) = fqY(ind);
    [fpeakValZ(i,1), ind] = max(specZ);
    fpeakFrqZ(i,1) = fqZ(ind);
    
    sampleSkewnessY(i,1) = skewness(specY);
    sampleSkewnessZ(i,1) = skewness(specZ);
    
end
ft = table(meanValueY,meanValueZ,medianValueY,medianValueZ,stdY,stdZ,madY,madZ,quantile25Y,quantile25Z,quantile75Y,quantile75Z,iqrY,iqrZ,minvalY,minvalZ,maxvalY, maxvalZ,separationY, separationZ,fpeakValY,fpeakValZ,fpeakFrqY,fpeakFrqZ,sampleSkewnessY,sampleSkewnessZ,class);

end


function [minval, maxval, separation] = getPeakFeatures(data)
    [maxval, mindx] = max(data);
    [minval, maxdx] = min(data);
    separation = abs(mindx-maxdx);
end
