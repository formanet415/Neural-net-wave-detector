load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_DUST_tswf_2020_12_27.mat')
fts = ft(ismember(ft.class,"DUST"),:);
load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_ESW_rswf_2020_12_27.mat')
fts = [fts; ft];
load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_ESW_tswf_2020_12_27.mat')
ft = [fts; ft];