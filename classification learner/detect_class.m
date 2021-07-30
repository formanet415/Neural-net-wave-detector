function detect_class(year,month,day,cdftype,etype,modelpath,varargin)
%DETECT_CLASS using an exported model this function predicts where the data
%matches the event type and saves an array with indexes and other
%information for the ClassificationHelperApp

begindex = 1;
while ~isempty(varargin)
    switch lower(varargin{1})
        case 'begindex'
            begindex = varargin{2};
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
end
load(modelpath)
cdf = cdf_from_server(year,month,day,cdftype);

n_samples = length(cdf.WAVEFORM_DATA.data(1,1,:));
if begindex>n_samples 
    error('wrong beginning index')
end


ogft = featuretable_generator_func(cdf,n_samples,etype,[],0);
ft = ogft(begindex:end,:);

pred = string(RUSBoosted_Trees.predictFcn(ft));
indexes = [begindex:n_samples];
indexes = indexes(pred == etype);
cdfdata = cdf;
save(sprintf('classification learner/data/predicted_%s_%s_%4i%02i%02i.mat',etype,cdftype,year,month,day),'cdfdata','indexes','ogft');
end
