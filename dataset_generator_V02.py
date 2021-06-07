import load_cdf as cdf
import pickle
import numpy as np

##      Vars       ##
data = np.array([])
target = np.array([])


##      LOADING WAVE INDEXES        ##
with open('./data/indexes_tswf_venus_ESW.txt') as f:
    strarr = f.readlines()
indexesT = np.array([int(intarr) for intarr in strarr[0].split(',')]) - 1

with open('./data/indexes_rswf_venus_ESW.txt') as f:
    strarr = f.readlines()
indexesR = np.array([int(intarr) for intarr in strarr[0].split(',')]) - 1


##      LOADING CDFs WITH ESW       ##
tswf = cdf.load_rpw('tswf', 2020, 12, 27, 'nnet')


##      WRITING DATA AND TARGET     ##
nsamp = tswf['SAMPS_PER_CH']
WFdata = tswf['WAVEFORM_DATA']
for i in range(len(nsamp)):
    samps = nsamp[i]
    data = np.append(data, WFdata[i,])
print('I did a thing')
