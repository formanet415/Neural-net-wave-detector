load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_ESW_rswf_2020_12_27.mat')
fts = ft;
load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_ESW_tswf_2020_12_27.mat')
fts = [fts; ft];
load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_DUST_tswf_all.mat')
fts = [fts; ft];
load('D:\Github\Neural-net-wave-detector\classification learner\data\ft_EMPTY_tswf_all.mat')
ft = [fts; ft];