FDIR = 'classification learner/data/DUST';
names = dir(FDIR);
names = struct2cell(names);
names = char(names(1,3:end));

fts = table();
for i = 1:length(string(names))
    load(fullfile(FDIR,names(i,:)));
    fts = [fts; ft(ismember(ft.class,"DUST"),:)];
end
ft = fts;
save('classification learner/data/ft_DUST_tswf_all.mat', 'ft')



FDIR = 'classification learner/data/LFW';
names = dir(FDIR);
names = struct2cell(names);
names = char(names(1,3:end));

fts = table();
for i = 1:length(string(names))
    load(fullfile(FDIR,names(i,:)));
    fts = [fts; ft(ismember(ft.class,"LFW"),:)];
end
ft = fts;
emp = repmat("EMPTY", size(ft.class,1),  1);
ft.class = emp;
save('classification learner/data/ft_EMPTY_tswf_all.mat', 'ft')