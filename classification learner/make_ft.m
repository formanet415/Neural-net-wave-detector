function make_ft(year, month, day, varargin)

% Defaults
cdftype = 'rswf';
etype = 'ESW';


while ~isempty(varargin)
    switch lower(varargin{1})
        case 'cdftype'
            cdftype = varargin{2};
        case 'eventtype'
            etype = varargin{2};
        case 'finalindex'
            finalindex = varargin{2};
        case 'txt_dir'
            TXT_DIR = varargin{2};
        case 'indexes'
            indexes = varargin{2};
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
end

if exist('TXT_DIR')
    fileID = fopen(TXT_DIR,'r');
    txt = split(string(fscanf(fileID,'%s')),'%');
    indexes = str2num(char(split(txt(1),','))); %#ok<ST2NM>
end
if ~exist('indexes') %#ok<*EXIST>
    error('ERROR: No indexes')
end

cdf = cdf_from_server(year, month, day, cdftype);
n_samples = length(cdf.WAVEFORM_DATA.data(1,1,:));
if exist('finalindex') 
    n_samples = finalindex;
end




% ________________________________ %

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
        class(i,1)= etype;
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
save(sprintf('classification learner/data/ft_%s_%s_%4i_%2i_%2i.mat', etype, cdftype, year, month, day), 'ft');
end


function [minval, maxval, separation] = getPeakFeatures(data)
    [maxval, mindx] = max(data);
    [minval, maxdx] = min(data);
    separation = abs(mindx-maxdx);
end
