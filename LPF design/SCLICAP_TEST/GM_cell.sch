v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 -20 -70 {}
P 4 1 -20 -70 {}
T {gm=@gm} 90 -30 0 0 0.2 0.2 {}
N 0 -70 0 -20 {lab=Ioutn}
N 0 40 -0 80 {lab=Ioutp}
N -0 -70 60 -70 {lab=Ioutn}
N -0 80 60 80 {lab=Ioutp}
N -80 -10 -40 -10 {lab=Vinp}
N -80 30 -40 30 {lab=Vinn}
N 60 -40 60 -30 {lab=Ioutn}
N 30 -40 60 -40 {lab=Ioutn}
N 30 -70 30 -40 {lab=Ioutn}
N 60 30 60 80 {lab=Ioutp}
N 60 -30 80 -30 {lab=Ioutn}
N 60 30 80 30 {lab=Ioutp}
C {vccs.sym} 0 10 0 0 {name=G1 value=\{gm\}}
C {ipin.sym} -80 -10 0 0 {name=p1 lab=Vinp}
C {ipin.sym} -80 30 0 0 {name=p2 lab=Vinn}
C {iopin.sym} 60 -70 0 0 {name=p3 lab=Ioutn
}
C {iopin.sym} 60 80 0 0 {name=p4 lab=Ioutp
}
C {res.sym} 80 0 0 0 {name=R1
value=\{AV/gm\}
footprint=1206
device=resistor}
