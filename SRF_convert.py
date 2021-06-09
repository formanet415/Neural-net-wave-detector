#IMPORTS
import math
import numpy as np

# Convert to spacecraft reference frame function
# Inspired by tds_tswf_plot_formet.m

def convert(data, index):
    time = data['Epoch'][index]
    tds_mode = data['TDS_CONFIG_LABEL'][index]
    # Pachenko's antenna angle
    pacang = math.radians(132.2)
    # RPW ANT in SRF
    V1 = np.array([0, 1])
    # Geometric    antenna
    # V2 = [0.81915204586197221, -0.57357643410459713]
    # V3 = [-0.81915204586197221, -0.57357643410459713]
    # Pachenko antenna
    V2 = np.array([math.sin(pacang), math.cos(pacang)])
    V3 = np.array([-math.sin(pacang), math.cos(pacang)])
    V2 = V2/np.linalg.norm(V2)
    V3 = V3/np.linalg.norm(V3)

    V1V3 = V1-V3
    V1V3 = V1V3/np.linalg.norm(V1V3)

    V2V1 = V2-V1
    V2V1 = V2V1/np.linalg.norm(V2V1)

    M = np.zeros([2,2])
    if 'SE1' in tds_mode:
        # SE1 TDS Mode
        M[0,:] = V1
        M[1,:] = V2
    else:
        # Construct transformation matrix ANT->SRF
        M[0,:] = V1V3
        M[1,:] = V2V1
        #DIFF1 TDS mode is same

    # load TDS TSWF data
    nsamp = data['SAMPS_PER_CH'][index]
    ww = data['WAVEFORM_DATA'][index,:,0:nsamp-1]
    M = np.linalg.inv(M)
    E = M.dot(ww[0:2,:]) * 1e3 # transformation into SRF (Y-Z)
    return E