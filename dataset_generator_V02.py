import load_cdf as cdf
import pickle
import numpy as np
import SRF_convert as SRF
import matplotlib.pyplot as plt
import pandas as pd

##      Vars       ##
data = np.array([])
target = np.array([])

##      LOADING CDFs WITH ESW       ##
#esw_tswf = cdf.load_rpw('tswf', 2020, 12, 27, 'nnet')
#esw_rswf = cdf.load_rpw('rswf', 2020, 12, 27, 'nnet')
dst_tswf = cdf.load_rpw('tswf', 2021,  1, 10, 'nnet')
#cdfs = [esw_tswf]  # ,esw_rswf,dst_tswf]

##      LOADING THE LABELS          ##
tesw_txt = np.array(pd.read_csv('./data/indexes_tswf_20201227_ESW.txt').columns).astype(int) - 1
resw_txt = np.array(pd.read_csv('./data/indexes_rswf_20201227_ESW.txt', skiprows=[1]).columns).astype(int) - 1
tdst_txt = np.array(pd.read_csv('./data/indexes_tswf_20210110_DST.txt').columns).astype(int) - 1
indxs = [tesw_txt]


##      Function for editing labels     ##
def relabel(cdf, indexes):
    lngth = 4096  # desired length after relabeling
    nsamp = cdf['SAMPS_PER_CH']
    for i in indexes:
        ns = nsamp[i]
        parts = int(ns / 4096)
        print('snapshot %d has %d parts' % (i, parts))
        fig, ax = plt.subplots(parts)
        w = np.append(SRF.convert(cdf, i), np.array([[0], [0]]), axis=1)
        snap_data = np.zeros([2, parts, lngth])

        for j in range(parts):
            ax[j].plot(w[0, j * lngth:(j + 1) * lngth])
            snap_data[:, j, :] = w[:, j * lngth:(j + 1) * lngth]
        if 'out_data' not in locals():
            out_data = snap_data
        else:
            out_data = np.append(out_data, snap_data, axis=1)

        plt.show()
        print('done plotting    0,0,0,0   0,0   1')

        print('Please enter matrix describing where the event happened; 0 = empty, 1 = ESW, 2 = DUST')
        while 'snap_label' not in locals():
            try:
                temp = input('Enter matrix: ').split(',')
                snap_label = np.array(temp).astype(int)
                if snap_label.shape == (parts,):
                    print('Success!')
                else:
                    del snap_label
                    print('try again, wrong shape')
            except:
                print('try again, numpy did not like your answer')

        if 'out_label' not in locals():
            out_label = snap_label
        else:
            out_label = np.append(out_label, snap_label)
        del snap_label

    print('got here')


#relabel(dst_tswf, tdst_txt)
#nsamp = esw_tswf['SAMPS_PER_CH']
#for i in range(len(nsamp)):
#    pass

##      WRITING DATA AND TARGET     ##
# nsamp = tswf['SAMPS_PER_CH']
# WFdata = tswf['WAVEFORM_DATA']
# for i in range(len(nsamp)):
#    snapshot = SRF.convert(tswf, i)
#    plt.plot(snapshot[0, :])
#    plt.plot(snapshot[1, :])
#    plt.show()
#    samps = nsamp[i]
#    plt.clf()
#    data = np.append(data, WFdata[i,])
# print('I did a thing')
