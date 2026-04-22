import numpy as np
import matplotlib.pyplot as plt
import mplcursors as mpl
import control as ct
from scipy.signal import *

%matplotlib qt
#`[nume, denum] = ellip(5,0.5,35,250e6*2*np.pi,analog=True)
[nume, denum] = ellip(5,0.25,35,1,analog=True)
#[nume, denum] = cheby1(8,0.25,250e6*2*np.pi,analog=True)

filter_tf = ct.tf(nume,denum)
filter_tf * 0.5


ct.bode(filter_tf,Hz=True,dB=True)
mpl.cursor(multiple=True)
ZEROS=ct.zeros(filter_tf)
POLE_CANCEL =ct.tf([ZEROS[0]*ZEROS[1]],[1, 0, ZEROS[0]*ZEROS[1]])
print(POLE_CANCEL)
filter_tf = filter_tf * POLE_CANCEL ;
print(filter_tf)
response = ct.frequency_response(filter_tf)
Mag = response.magnitude
Phase = response.phase
omega = response.omega 
Gain_at_300M= 20*np.log10(np.interp(300e6*2*np.pi, omega , Mag[0][0]))
print(Gain_at_300M)

[wn_array,  zeta_array,  poles_array] = ct.damp(filter_tf)
Q_array = 1/(2*zeta_array)
print(Q_array)
max_Quality = np.max(Q_array)
print(max_Quality)
Gain_array= np.zeros(7)
Max_Quality_array= np.zeros(7)
Passive_pole_array = np.zeros(7)
iteration = 0;
for ATT in np.linspace(25,60,7):
    [nume, denum] = ellip(5,0.25,ATT,250e6*2*np.pi,analog=True)
    filter_tf = ct.tf(nume,denum)
    response = ct.frequency_response(filter_tf)
    Mag = response.magnitude
    Phase = response.phase
    omega = response.omega 
    Gain_at_300M= 20*np.log10(np.interp(300e6*2*np.pi, omega , Mag[0][0]))
    Gain_array[iteration] = Gain_at_300M
    [wn_array,  zeta_array,  poles_array] = ct.damp(filter_tf)
    Q_array = 1/(2*zeta_array)
    max_Quality = np.max(Q_array)
    Passive_pole_array[iteration] = poles_array[-1]
    Max_Quality_array[iteration] = max_Quality
    iteration = iteration + 1;
    ct.pzmap(filter_tf)
## Choose ATT  = 35
[nume, denum] = cheby1(6,0.5,250e6*2*np.pi,analog=True)

filter_tf_no_zeros = ct.tf(nume,denum)
fz = 300e6;
Qz=3;
TX_Zero_tf = ct.tf([1, (2*np.pi*fz)/Qz, (2*np.pi*fz)**2],[(2*np.pi*fz)**2])

print(TX_Zero_tf)
filter_tf = filter_tf_no_zeros*TX_Zero_tf

response = ct.frequency_response(filter_tf)
Mag = response.magnitude
Phase = response.phase
omega = response.omega 
Gain_at_300M= 20*np.log10(np.interp(300e6*2*np.pi, omega , Mag[0][0]))
Gain_at_250M= 20*np.log10(np.interp(250e6*2*np.pi, omega , Mag[0][0]))
Gain_at_25M= 20*np.log10(np.interp(25e6*2*np.pi, omega , Mag[0][0]))
print("Gain at 25M=",Gain_at_25M, ",Gain at 250M=",Gain_at_250M, ",Gain at 300M=",Gain_at_300M)

ct.bode(filter_tf,Hz=True,dB=True)
mpl.cursor(multiple=True)
print(filter_tf)

ct.bode(filter_tf_no_zeros,Hz=True,dB=True)
mpl.cursor(multiple=True)
[wn_array,  zeta_array,  poles_array] = ct.damp(filter_tf)
Q_array = 1/(2*zeta_array)
