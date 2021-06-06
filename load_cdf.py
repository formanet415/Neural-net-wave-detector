import cdflib
from pathlib import Path
import os


def load_rpw(filetype, year, month, day, opt):
    filetype = filetype.lower()

    if filetype == 'tswf' or filetype == 'rswf':
        data_folder = Path('Z:/rpw/L2/tds_wf_e')
        for names in os.listdir(data_folder / ('%04d' % year) / ('%02d' % month)):
            if ('solo_L2_rpw-tds-surv-%s-e-cdag_%04d%02d%02d_V' % (filetype, year, month, day)) in names:
                fname = names
        cdf = cdflib.CDF(data_folder / ('%04d' % year) / ('%02d' % month) / fname)

        data = {}

        if opt=='nnet':
            for varname in ['Epoch', 'SAMPLING_RATE', 'CHANNEL_ON', 'SAMPS_PER_CH', 'WAVEFORM_DATA']:
                data[varname] = cdf.varget(varname)

        (why, varnames) = cdf._get_varnames()
        for varname in varnames:
            data[varname] = cdf.varget(varname)
        return data