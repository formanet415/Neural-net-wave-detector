fileID = fopen('classification learner/data/solo_lfw.txt','r');
txt = split(string(fscanf(fileID,'%s')),'`');

for i = txt'
    disp(i)
    temp = split(i,'_');
    date = char(temp(1));
    y = str2num(date(1:4)); %#ok<*ST2NM>
    m = str2num(date(6:7));
    d = str2num(date(9:10));
    indexes = str2num(temp(2)); 
    make_ft(y,m,d,'cdftype','tswf','eventtype','LFW','indexes', indexes)
end


fileID = fopen('classification learner/data/solo_dust.txt','r');
txt = split(string(fscanf(fileID,'%s')),'`');

for i = txt'
    disp(i)
    temp = split(i,'_');
    date = char(temp(1));
    y = str2num(date(1:4)); %#ok<*ST2NM>
    m = str2num(date(6:7));
    d = str2num(date(9:10));
    indexes = str2num(temp(2)); 
    make_ft(y,m,d,'cdftype','tswf','eventtype','DUST','indexes', indexes)
end



make_ft(2020,12,27,'cdftype','rswf','eventtype','ESW','txt_dir','classification learner/data/indexes_rswf_20201227_ESW.txt','finalindex', 2451)
make_ft(2020,12,27,'cdftype','tswf','eventtype','ESW','txt_dir','classification learner/data/indexes_tswf_20201227_ESW.txt')
make_ft(2020,12,27,'cdftype','tswf','eventtype','DUST','txt_dir','classification learner/data/indexes_tswf_20210110_DST.txt')
