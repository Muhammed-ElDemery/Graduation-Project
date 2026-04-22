% Specs :
OUT_NOISE = 25e-9
INPUT_NOISE = 128e-6
VDD = 1.6
% NMOS
% Device Type nfet
VDS_N = 0.6
VGS_N = 0.631
GM_ID_N = 8
GM_GDS_N = 448
GDS_ID_N = GM_ID_N/GM_GDS_N

CGG_gm_N = 21.5 %pico
CDD_gm_N = 0.78 %pico
W_ID_N =  27.86e-3
LN=400e-9

GM_req = 400e-6;
ID_N = GM_req/GM_ID_N
WN = W_ID_N * ID_N


% Gain Expression = GM_ID_N/(GDS_ID_N + GDS_ID_P) =200
Gain = 200*1 % 20% Excess
GDS_ID_P =  GM_ID_N / Gain - GDS_ID_N  
GM_ID_N/(GDS_ID_N+GDS_ID_P)

% PMOS 
% Device pfet
VDS_P = 0.6
GDS_ID_P = 22.8
VGS_P = 0.715
CDD_gm_P = 2.5 
W_ID_P = 67.23e-3
LP = 700e-9

WP = W_ID_P*ID_N

% TWO stage approach 

%first stage (Diode connected PMOS LOAD) 
Gain = 2;
VGS_N  = 0.520
VGS_P = 0.527
ID = 66.85; %uA
W_N  = 8; %u
W_P = 4; %u
LN = 0.1;
LP = 0.1;
NF_N = 8;
NF_P = 2;
VCOMP_SOURCE1 = 0.2;

VOCM_1 = VDD- VGS_P
VICM_1 = VGS_N + VCOMP_SOURCE1


% Second Bias point
LP2  = 0.7;
LN2 = 0.2;
VGSN2=  0.524;
gm_ID_N2 = 10;
GM_GDS_N2 = 235;
GDS_ID_P = 0.041;
VGS_P2= 0.6;
W_ID_N2= 50.7e-3;
W_ID_P2 = 375e-3;

gm_ID_N_first_stage2 = 17.8; 

AV2=257;
CGD2_ID2 = 2.105e-15/(100e-6)
CGD2_ID2= 36.6e-12;


%wp_miller = gm_ID_N_first_stage2 * ID1_ID2 / CGD2_ID2 / AV2;
wp_miller = 50e9;
ID1_ID2 = wp_miller *CGD2_ID2 *AV2 / gm_ID_N_first_stage2

WN1_ID = 16e-6/135e-6
WP1_ID = 7e-6/135e-6
WN2_ID = 50.7e-3;
WP2_ID = 375e-3;

GM = AV1 * gm_ID_N2*ID2
%GM = 3e-3;
%AV1 = 2.1;
%gm2 = GM/AV1;
ID2 = 100e-6
%ID2 = gm2/gm_ID_N2
ID1 = ID1_ID2*1.2 * ID2
ID1  = 3*ID2
WN1 = ID1 * WN1_ID
WP1 = ID1 * WP1_ID
WN2 = WN2_ID * ID2
WP2 = WP2_ID * ID2


