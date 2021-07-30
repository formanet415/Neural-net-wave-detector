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



ft = featuretable_generator(cdf,n_samples,etype,indexes,1);
% ________________________________ %

save(sprintf('classification learner/data/ft_%s_%s_%4i_%2i_%2i.mat', etype, cdftype, year, month, day), 'ft');
end
