v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -220 -130 10 -130 {lab=#net1}
N 10 -130 10 -50 {lab=#net1}
N -30 -50 10 -50 {lab=#net1}
N -230 -0 -200 -0 {lab=#net1}
N -230 -70 -230 -0 {lab=#net1}
N -230 -70 -140 -70 {lab=#net1}
N -140 -130 -140 -70 {lab=#net1}
N 10 -130 90 -130 {lab=#net1}
N 260 -110 310 -110 {lab=#net2}
N 310 -300 310 -110 {lab=#net2}
N 240 -300 310 -300 {lab=#net2}
N 10 -250 70 -250 {lab=#net1}
N 10 -250 10 -130 {lab=#net1}
N 590 -100 640 -100 {lab=#net3}
N 640 -290 640 -100 {lab=#net3}
N 570 -290 640 -290 {lab=#net3}
N 310 -240 400 -240 {lab=#net2}
N 310 -110 420 -110 {lab=#net2}
N 420 -120 420 -110 {lab=#net2}
N 860 -100 910 -100 {lab=#net4}
N 910 -290 910 -100 {lab=#net4}
N 840 -290 910 -290 {lab=#net4}
N 690 -120 690 -110 {lab=#net3}
N 690 -110 690 -100 {lab=#net3}
N 640 -100 690 -100 {lab=#net3}
N 640 -240 670 -240 {lab=#net3}
N 1130 -100 1180 -100 {lab=#net5}
N 1180 -290 1180 -100 {lab=#net5}
N 1110 -290 1180 -290 {lab=#net5}
N 960 -120 960 -110 {lab=#net4}
N 960 -110 960 -100 {lab=#net4}
N 910 -100 960 -100 {lab=#net4}
N 910 -240 940 -240 {lab=#net4}
N 1400 -100 1450 -100 {lab=OUT}
N 1450 -290 1450 -100 {lab=OUT}
N 1380 -290 1450 -290 {lab=OUT}
N 1230 -120 1230 -110 {lab=#net5}
N 1230 -110 1230 -100 {lab=#net5}
N 1180 -100 1230 -100 {lab=#net5}
N 1180 -240 1210 -240 {lab=#net5}
N 1430 60 1470 60 {lab=OUT}
N 1430 -100 1430 60 {lab=OUT}
N 1640 -100 1640 10 {lab=OUT}
N 1450 -100 1640 -100 {lab=OUT}
N -440 -150 -390 -150 {lab=#net6}
N 380 -110 380 -20 {lab=#net2}
N 380 -20 380 60 {lab=#net2}
N 380 60 610 60 {lab=#net2}
N 670 60 880 60 {lab=#net4}
N 880 -100 880 60 {lab=#net4}
N 880 60 1140 60 {lab=#net4}
N 1200 60 1430 60 {lab=OUT}
C {GM_cell.sym} -300 -120 0 0 {name=x1 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} -120 -10 2 0 {name=x2
gm=\{gm_1*k_s\}
AV=\{AV_1\}}
C {GM_cell.sym} 180 -100 0 0 {name=x3 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} 150 -260 2 0 {name=x4 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} 510 -90 0 0 {name=x5 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} 480 -250 2 0 {name=x6 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {capa.sym} 310 -80 0 0 {name=C1
m=1
value=\{C_1\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 640 -70 0 0 {name=C2
m=1
value=\{L_1\}
footprint=1206
device="ceramic capacitor"}
C {GM_cell.sym} 780 -90 0 0 {name=x7 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} 750 -250 2 0 {name=x8 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {capa.sym} 910 -70 0 0 {name=C3
m=1
value=\{C_2\}
footprint=1206
device="ceramic capacitor"}
C {GM_cell.sym} 1050 -90 0 0 {name=x9 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} 1020 -250 2 0 {name=x10 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {capa.sym} 1180 -70 0 0 {name=C4
m=1
value=\{L_2\}
footprint=1206
device="ceramic capacitor"}
C {GM_cell.sym} 1320 -90 0 0 {name=x11 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {GM_cell.sym} 1290 -250 2 0 {name=x12 gm=\{k_1*gm_1\}
AV=\{AV_1\}}
C {capa.sym} 1450 -70 0 0 {name=C5
m=1
value=\{C_5\}
footprint=1206
device="ceramic capacitor"}
C {GM_cell.sym} 1550 50 2 0 {name=x13 gm=\{k_l*gm_1\}
AV=\{AV_1\}}
C {gnd.sym} 310 -50 0 0 {name=l1 lab=GND}
C {gnd.sym} 640 -40 0 0 {name=l2 lab=GND}
C {gnd.sym} 90 -60 0 0 {name=l3 lab=GND}
C {gnd.sym} -200 -20 0 0 {name=l4 lab=GND}
C {gnd.sym} -30 20 0 0 {name=l5 lab=GND}
C {gnd.sym} -220 -110 0 0 {name=l6 lab=GND}
C {gnd.sym} -390 -80 0 0 {name=l7 lab=GND}
C {gnd.sym} 420 -50 0 0 {name=l8 lab=GND}
C {gnd.sym} 240 -230 0 0 {name=l9 lab=GND}
C {gnd.sym} 570 -220 0 0 {name=l10 lab=GND}
C {gnd.sym} 590 -80 0 0 {name=l11 lab=GND}
C {gnd.sym} 840 -220 0 0 {name=l12 lab=GND}
C {gnd.sym} 860 -80 0 0 {name=l13 lab=GND}
C {gnd.sym} 910 -40 0 0 {name=l14 lab=GND}
C {gnd.sym} 960 -50 0 0 {name=l15 lab=GND}
C {gnd.sym} 1130 -80 0 0 {name=l16 lab=GND}
C {gnd.sym} 1180 -40 0 0 {name=l17 lab=GND}
C {gnd.sym} 1230 -50 0 0 {name=l18 lab=GND}
C {gnd.sym} 1400 -80 0 0 {name=l19 lab=GND}
C {gnd.sym} 1450 -40 0 0 {name=l20 lab=GND}
C {gnd.sym} 1470 40 2 0 {name=l21 lab=GND}
C {gnd.sym} 1640 80 0 0 {name=l22 lab=GND}
C {gnd.sym} 1380 -220 0 0 {name=l23 lab=GND}
C {gnd.sym} 1210 -260 2 0 {name=l24 lab=GND}
C {gnd.sym} 1110 -220 0 0 {name=l25 lab=GND}
C {gnd.sym} 940 -260 2 0 {name=l26 lab=GND}
C {gnd.sym} 670 -260 2 0 {name=l27 lab=GND}
C {gnd.sym} 400 -260 2 0 {name=l28 lab=GND}
C {gnd.sym} 70 -270 2 0 {name=l29 lab=GND}
C {lab_pin.sym} 1600 -100 1 0 {name=p1 sig_type=std_logic lab=OUT}
C {vsource.sym} -440 -120 0 0 {name=V1 value=\{VIN\} savecurrent=false}
C {gnd.sym} -440 -90 0 0 {name=l30 lab=GND}
C {capa.sym} 640 60 1 0 {name=C6
m=1
value=\{C_3\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 1170 60 1 0 {name=C7
m=1
value=\{C_4\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 260 -90 0 0 {name=l31 lab=GND}
C {gnd.sym} 690 -50 0 0 {name=l32 lab=GND}
