v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 -70 -100 -0 {lab=#net1}
N -110 -0 -100 -0 {lab=#net1}
N 290 -280 290 -240 {lab=#net2}
N 140 -280 140 10 {lab=#net2}
N 450 -280 450 -0 {lab=#net3}
N 450 -280 580 -280 {lab=#net3}
N 360 -280 360 -240 {lab=#net3}
N 360 -280 450 -280 {lab=#net3}
N 590 -280 590 -240 {lab=#net3}
N 570 -280 590 -280 {lab=#net3}
N -50 -290 -50 -240 {lab=#net2}
N -50 -290 140 -290 {lab=#net2}
N 140 -290 140 -280 {lab=#net2}
N -60 170 -60 200 {lab=#net1}
N -160 200 -60 200 {lab=#net1}
N -160 -20 -160 200 {lab=#net1}
N -160 -20 -100 -20 {lab=#net1}
N -60 200 120 200 {lab=#net1}
N 120 180 120 200 {lab=#net1}
N 180 200 190 200 {lab=#net4}
N 190 180 190 200 {lab=#net4}
N 190 200 260 200 {lab=#net4}
N 260 200 450 200 {lab=#net4}
N 430 170 430 200 {lab=#net4}
N 500 170 500 180 {lab=OUT}
N 500 180 530 180 {lab=OUT}
N 530 180 530 200 {lab=OUT}
N 510 200 530 200 {lab=OUT}
N 140 -290 290 -290 {lab=#net2}
N 290 -290 290 -280 {lab=#net2}
N 310 -70 310 200 {lab=#net4}
N 610 -70 610 200 {lab=OUT}
N 530 200 610 200 {lab=OUT}
N 660 -280 660 -240 {lab=OUT}
N 660 -280 740 -280 {lab=OUT}
N 740 -280 740 200 {lab=OUT}
N 610 200 740 200 {lab=OUT}
N -120 -270 -120 -240 {lab=#net5}
N -280 -270 -120 -270 {lab=#net5}
N -280 -270 -280 -230 {lab=#net5}
C {GM_cell.sym} -90 -150 3 1 {name=x1}
C {GM_cell.sym} -70 90 1 0 {name=x2}
C {GM_cell.sym} 320 -150 3 1 {name=x3}
C {gnd.sym} -80 -70 0 0 {name=l1 lab=GND}
C {GM_cell.sym} 620 -150 3 1 {name=x4}
C {GM_cell.sym} 150 90 3 0 {name=x5}
C {GM_cell.sym} 460 80 3 0 {name=x6}
C {gnd.sym} -40 0 2 0 {name=l2 lab=GND}
C {gnd.sym} -80 170 0 0 {name=l3 lab=GND}
C {capa.sym} 10 230 0 0 {name=C1
m=1
value=\{L_1\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 10 260 0 0 {name=l4 lab=GND}
C {capa.sym} 150 200 1 0 {name=C2
m=1
value=\{L_2\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 480 200 1 0 {name=C3
m=1
value=\{L_4\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 300 230 0 0 {name=C4
m=1
value=\{L_3\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 300 260 0 0 {name=l5 lab=GND}
C {capa.sym} 530 230 0 0 {name=C5
m=1
value=\{L_5\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 530 260 0 0 {name=l6 lab=GND}
C {capa.sym} 110 -320 2 0 {name=C6
m=1
value=\{C_2\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 110 -350 2 0 {name=l7 lab=GND}
C {capa.sym} 400 -310 2 0 {name=C7
m=1
value=\{C_4\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 400 -340 2 0 {name=l9 lab=GND}
C {gnd.sym} 330 -70 0 0 {name=l8 lab=GND}
C {gnd.sym} 160 10 2 0 {name=l10 lab=GND}
C {gnd.sym} 470 0 2 0 {name=l11 lab=GND}
C {lab_pin.sym} 740 -250 2 0 {name=p1 sig_type=std_logic lab=OUT}
C {gnd.sym} 630 -70 0 0 {name=l12 lab=GND}
C {vsource.sym} -280 -200 0 0 {name=V1 value=\{VIN\} savecurrent=false}
C {gnd.sym} -280 -170 0 0 {name=l13 lab=GND}
