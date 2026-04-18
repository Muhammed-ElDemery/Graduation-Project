v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 -100 -100 -50 {lab=IN}
N -100 -100 -60 -100 {lab=IN}
N 0 -100 110 -100 {lab=#net1}
N 50 -100 50 -50 {lab=#net1}
N -100 10 -100 40 {lab=GND}
N -100 40 50 40 {lab=GND}
N 50 10 50 40 {lab=GND}
N 340 -100 380 -100 {lab=OUT}
N -220 -100 -100 -100 {lab=IN}
N 380 -100 380 -80 {lab=OUT}
N 380 -20 380 40 {lab=GND}
N 220 40 380 40 {lab=GND}
N -220 40 -100 40 {lab=GND}
N -220 30 -220 40 {lab=GND}
N -220 -40 -220 -30 {lab=#net2}
N 260 -100 260 -60 {lab=OUT}
N 180 -100 260 -100 {lab=OUT}
N 170 -100 180 -100 {lab=OUT}
N 260 -100 340 -100 {lab=OUT}
N 260 0 260 40 {lab=GND}
N 40 40 230 40 {lab=GND}
N -100 -180 -60 -180 {lab=IN}
N -100 -180 -100 -110 {lab=IN}
N -100 -110 -100 -100 {lab=IN}
N 0 -180 50 -180 {lab=#net1}
N 50 -180 50 -100 {lab=#net1}
N 50 -180 120 -180 {lab=#net1}
N 180 -180 260 -180 {lab=OUT}
N 260 -180 260 -100 {lab=OUT}
C {ind.sym} -30 -100 1 0 {name=L1
m=1
value=\{L_2\}
footprint=1206
device=inductor}
C {ind.sym} 140 -100 1 0 {name=L2
value=\{L_4\}
footprint=1206
device=inductor}
C {capa.sym} -100 -20 0 0 {name=C1
m=1
value=\{C_1\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 50 -20 0 0 {name=C2
m=1
value=\{C_3\}
footprint=1206
device="ceramic capacitor"}
C {res.sym} 380 -50 0 0 {name=R1
value=\{RL\}
footprint=1206
device=resistor
m=1}
C {res.sym} -220 -70 0 0 {name=R2
value=\{RS\}
footprint=1206
device=resistor
m=1}
C {gnd.sym} 40 40 0 0 {name=l3 lab=GND}
C {vsource.sym} -220 0 0 0 {name=V1 value=\{VIN\} savecurrent=false}
C {lab_pin.sym} 380 -100 1 0 {name=p1 sig_type=std_logic lab=OUT}
C {capa.sym} 260 -30 0 0 {name=C3
m=1
value=\{C_5\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} -30 -180 3 0 {name=C4
m=1
value=\{C_Z1\}
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 150 -180 3 0 {name=C5
m=1
value=\{C_Z2\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -170 -100 1 0 {name=p2 sig_type=std_logic lab=IN}
