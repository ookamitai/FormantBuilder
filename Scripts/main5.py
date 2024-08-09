#coding:utf-8

# Tube model:
# draw frequency response, cross-sectional view (area), and waveform, considering glottal voice source and mouth radiation
# save generated waveform as a wav file
#

import os
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import use as matuse
import matplotlib.patches as patches
from scipy.io.wavfile import write as wavwrite
from fourtube1 import *
from glottal import *
from HPF import *

def show_figure1(tube, glo, hpf, saveName, yout=None):
    #
    fig = plt.figure()
    
    # draw frequency response
    ax1 = fig.add_subplot(311)
    amp0, freq=glo.H0(freq_low=100, freq_high=6000, Band_num=1024)
    amp1, freq=tube.H0(freq_low=100, freq_high=6000, Band_num=1024)
    amp2, freq=hpf.H0(freq_low=100, freq_high=6000, Band_num=1024)
    
    ax1.set_title('frequency response: ' )
    plt.xlabel('Frequency [Hz]')
    plt.ylabel('Amplitude [dB]')
    ax1.plot(freq, (amp0+amp1+amp2))
    
    plt.grid()
    
    # draw cross-sectional view
    ax2 = fig.add_subplot(312)
    L1=tube.L1
    L2=tube.L2
    L3=0.
    L4=0.
    L5=0.
    A1=tube.A1
    A2=tube.A2
    A3=0.
    A4=0.
    A5=0.
    if tube.num_of_tube >= 3:
        L3=tube.L3
        A3=tube.A3
    if tube.num_of_tube >= 4:
        L4=tube.L4
        A4=tube.A4
    if tube.num_of_tube >= 5:
        L5=tube.L5
        A5=tube.A5
    
    
    ax2.add_patch( patches.Rectangle((0, -0.5* A1), L1, A1, hatch='/', fill=False))
    ax2.add_patch( patches.Rectangle((L1, -0.5* A2), L2, A2, hatch='/', fill=False))
    ax2.add_patch( patches.Rectangle((L1+L2, -0.5* A3), L3, A3, hatch='/', fill=False))
    ax2.add_patch( patches.Rectangle((L1+L2+L3, -0.5* A4), L4, A4, hatch='/', fill=False))
    ax2.add_patch( patches.Rectangle((L1+L2+L3+L4, -0.5* A5), L5, A5, hatch='/', fill=False))
    ax2.set_xlim([0, L1+L2+L3+L4+L5+5])
    ax2.set_ylim([(max(A1,A2,A3,A4,A5)*0.5+5)*-1, max(A1,A2,A3,A4,A5)*0.5+5 ])
    
    ax2.set_title('cross-section area')
    plt.xlabel('Length [cm]')
    plt.ylabel('Cross-section area [ratio]')
    plt.grid()
    
    
    # draw generated waveform
    ax3 = fig.add_subplot(313)
    if yout is not None:
        ax3.set_title('generated waveform')
        plt.xlabel('msec')
        plt.ylabel('level')
        plt.plot( (np.arange(len(yout)) * 1000.0 / glo.sr) , yout)
        plt.grid()
    
    plt.tight_layout()
    plt.savefig(f"{saveName}.png")


def generate_waveform1(tube, glo, hpf, repeat_num=50):
    yg_repeat=glo.make_N_repeat(repeat_num=repeat_num)
    y2tm=tube.process(yg_repeat)
    yout=hpf.iir1(y2tm)
    return yout
    
def down_sample(xin, sampling_rate, over_sampling_ratio, cutoff=15000):
    if over_sampling_ratio == 1:
        return xin   # return xin itself, it's not over sample.
    
    # simple down sampler by FFT
    y= np.fft.fft(xin)
    freq= np.fft.fftfreq(len(xin),1 / sampling_rate)
    id0=np.where( freq > cutoff)[0][0]
    id1=len(xin) - id0
    y[id0:int(id1+1)]=0.
    z= np.real(np.fft.ifft(y))
    return  z.reshape(int(len(xin)/over_sampling_ratio),over_sampling_ratio,)[:,0].copy()

def save_wav(yout, wav_path, sampling_rate=48000, wav_dir='wav'):
    if not os.path.isdir(wav_dir):
        os.makedirs(wav_dir)
    out_path=os.path.join(wav_dir,wav_path)
    wavwrite( out_path, sampling_rate, ( yout * 2 ** 15).astype(np.int16))
    print ('save ', out_path) 


def main(tubeid, l1, l2, l3, l4, a1, a2, a3, a4, rep=50):    
    
    matuse('Agg')
    over_sampling_ratio= 2

    tube_5p1= Class_FourTube(3.698116068094256, 5.565020169379425, 6.962391846610267, 2.174272784424185, 1.0, 1.7610962103700538, 68.3470685620078, 25.182712939573886, sampling_rate=48000*over_sampling_ratio)
    tube_5p2=Class_FourTube(4.56435574101474, 1.5815494971271784, 6.3148516398884045, 2.8913186253612144, 12.4861116217549, 6.577432646215859, 1.0, 15.866583995276608, sampling_rate=48000*over_sampling_ratio)
    tube_5p3= Class_FourTube(3.7194986326972943, 1.888224862637144, 7.276399617568311, 5.535507523773382, 4.594948652925214, 1.7371607940258063, 7.012233492843109, 1.0, sampling_rate=48000*over_sampling_ratio)
    tube_5p4= Class_FourTube(3.258269263264273, 4.936530924286407, 1.6678711570315916, 6.582655113007322, 1.0, 18.982925503761678, 10.180643942459346, 5.498047801381349, sampling_rate=48000*over_sampling_ratio)
    tube_5p5= Class_FourTube(7.3000028311309855, 1.7642328995769578, 3.7752944411902947, 5.694868790881701, 4.09498075759286, 1.0, 23.411325990169203, 5.533790103661377, sampling_rate=48000*over_sampling_ratio)
        
    # choice one tube model to generate waveform
    if tubeid == 0:
        tube = Class_FourTube(l1, l2, l3, l4, a1, a2, a3, a4, sampling_rate=48000*over_sampling_ratio)
    elif tubeid == 1:
        tube = tube_5p1
    elif tubeid == 2:
        tube = tube_5p2
    elif tubeid == 3:
        tube = tube_5p3
    elif tubeid == 4:
        tube = tube_5p4
    elif tubeid == 5:
        tube = tube_5p5
    else:
        tube = tube_5p1
    
    # specify output wav file name
    outFile=f"tube_5p{tubeid}.wav"
    
    # instance as glottal voice source
    glo=Class_Glottal(sampling_rate=48000*over_sampling_ratio)
    
    # instance for mouth radiation effect
    hpf=Class_HPF(sampling_rate=48000*over_sampling_ratio)
    
    # generate waveform
    yout=generate_waveform1(tube, glo, hpf, repeat_num=rep)
    
    # draw
    yout_early_portion= yout[0: int(len(glo.yg) * 3)]  # draw only 3 plus length early portion
    show_figure1(tube,glo,hpf, tubeid, yout_early_portion)
    
    # save generated waveform as a wav file
    yout2=down_sample(yout, 48000*over_sampling_ratio, over_sampling_ratio)
    save_wav(yout2, outFile, sampling_rate=48000)
