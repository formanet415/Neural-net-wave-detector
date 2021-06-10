import load_cdf as cdf
import pickle
import numpy as np
import SRF_convert as SRF
import matplotlib.pyplot as plt
import pandas as pd

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
esw_tswf = cdf.load_rpw('tswf', 2020, 12, 27, 'nnet')
#esw_rsfw = cdf.load_rpw('rswf', 2020, 12, 27, 'nnet')
#dst_tsfw = cdf.load_rpw('tswf', 2021,  1, 10, 'nnet')


##      LOADING THE LABELS          ##
tesw_txt = np.array(pd.read_csv('./data/indexes_tswf_20201227_ESW.txt').columns)-1
resw_txt = np.array(pd.read_csv('./data/indexes_rswf_20201227_ESW.txt', skiprows=[1]).columns)-1
tdst_txt = np.array(pd.read_csv('./data/indexes_tswf_20210110_DST.txt').columns)-1

##      WRITING DATA AND TARGET     ##
#nsamp = tswf['SAMPS_PER_CH']
#WFdata = tswf['WAVEFORM_DATA']
#for i in range(len(nsamp)):
#    snapshot = SRF.convert(tswf, i)
#    plt.plot(snapshot[0, :])
#    plt.plot(snapshot[1, :])
#    plt.show()
#    samps = nsamp[i]
#    plt.clf()
#    data = np.append(data, WFdata[i,])
#print('I did a thing')
