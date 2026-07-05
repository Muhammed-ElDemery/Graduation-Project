% ==========================================================
%   External LNA Behavioral Model with Noise & Nonlinearity
% ==========================================================
clear; clc;

%%-------------------- constants ------------------------------
Z0      = 50;         % System Impedance (Ohm)
fs      = 15e9;       % Sampling rate (Hz)
N  = 2^17;
t  = (0:N-1)'/fs;
B       = 200e6;      % Bandwidth (Hz) - Base Band
T       = 300;        % Temperature (K)
k       = 1.38e-23;   % Boltzmann constant
%% -------------------- LNA1 Specifications --------------------

%G_dB_LNA1    = 25;         % Power Gain (dB)
%OIP3_dB_LNA1 = 35;         % Output IP3 (dBm)
OIP2_dB_LNA1 = 50; % Ouput IP2  (dBm)
NF_dB_LNA1   = 1;          % Noise Figure (dB)
% Internal LNA 
 G_dB_LNA1 =22;
 OIP3_dB_LNA1 = 25 ;

% External LNA
% G_dB_LNA1 =25;
% OIP3_dB_LNA1 = 35 ;
%% -------------------- LNA2 Specifications --------------------
G_dB_LNA2    = 0;         % Power Gain (dB)
OIP3_dB_LNA2 = 1000;         % Output IP3 (dBm)
OIP2_dB_LNA2 = OIP3_dB_LNA2+60; % Ouput IP2  (dBm)
NF_dB_LNA2   = 0;          % Noise Figure (dB)
%% -------------------- DSA1 Specifications --------------------
G_dB_DSA1_MAX = -3;         % Power Gain (dB)
G_dB_DSA1    = G_dB_DSA1_MAX;         % Power Gain (dB)
OIP3_dB_DSA1 = 25;         % Output IP3 (dBm)
OIP2_dB_DSA1 = 60; % Ouput IP2  (dBm)
NF_dB_DSA1   = -G_dB_DSA1;          % Noise Figure (dB)
DSA1_Range = 15;
%%----- RF AMP Specifications ------------------
G_dB_RFAMP = 8;
OIP3_dB_RFAMP = 25;
OIP2_dB_RFAMP = 50;
NF_dB_RFAMP = 3;
%%------ DSA2----------------
G_dB_DSA2_MAX = -2;
G_dB_DSA2    = G_dB_DSA2_MAX;         % Power Gain (dB)
OIP3_dB_DSA2 = 25;         % Output IP3 (dBm)
OIP2_dB_DSA2 = 60; % Ouput IP2  (dBm)
NF_dB_DSA2   = -G_dB_DSA2;          % Noise Figure (dB)
DSA2_Range = 3;
%% -------------------- Mixer Specifications --------------------
G_dB_mix    = -7;         % Power Gain (dB)
OIP3_dB_mix = 16;         % Output IP3 (dBm)
OIP2_dB_mix = 50; % Ouput IP2  (dBm)
NF_dB_mix   = 7;          % Noise Figure (dB)
%% -------------------- LPF Specifications --------------------
G_dB_LPF    = 0;         % Power Gain (dB)
OIP3_dB_LPF = 16;         % Output IP3 (dBm)
OIP2_dB_LPF = 55; % Ouput IP2  (dBm)
% SDR2 = IIP2 - Pblocker_before_LPF(+6dB)
NF_dB_LPF   = 12;          % Noise Figure (dB)

%% -------------------- Amplifier Specs ---------------------------
G_dB_AMP_MAX = 15;
G_dB_Amp = G_dB_AMP_MAX;
OIP3_dB_Amp  = 20;
OIP2_dB_Amp = 50;
NF_dB_Amp = 3;
AMP_Range = 10+5;

%% -------------------- Derived Parameters --------------------
MODEL_IP2 = 1; % MODEL IP2 or Not
LNA1 = analyze_block(G_dB_LNA1, OIP3_dB_LNA1, OIP2_dB_LNA1, NF_dB_LNA1, Z0, B, T,MODEL_IP2);
LNA2 = analyze_block(G_dB_LNA2, OIP3_dB_LNA2, OIP2_dB_LNA2, NF_dB_LNA2, Z0, B, T,MODEL_IP2);
DSA1 = analyze_block(G_dB_DSA1, OIP3_dB_DSA1, OIP2_dB_DSA1, NF_dB_DSA1, Z0, B, T,MODEL_IP2);
RFAMP = analyze_block(G_dB_RFAMP, OIP3_dB_RFAMP, OIP2_dB_RFAMP, NF_dB_RFAMP, Z0, B, T,MODEL_IP2);
DSA2 = analyze_block(G_dB_DSA2, OIP3_dB_DSA2, OIP2_dB_DSA2, NF_dB_DSA2, Z0, B, T,MODEL_IP2);
Mixer = analyze_block(G_dB_mix, OIP3_dB_mix, OIP2_dB_mix, NF_dB_mix, Z0, B, T,MODEL_IP2);
LPF = analyze_block(G_dB_LPF, OIP3_dB_LPF, OIP2_dB_LPF, NF_dB_LPF, Z0, B, T,MODEL_IP2);
AMP = analyze_block(G_dB_Amp, OIP3_dB_Amp, OIP2_dB_Amp, NF_dB_Amp, Z0, B, T,MODEL_IP2);

%% -------------------- Display Model Info --------------------
fprintf('--- LNA1 Behavioral Model ---\n');
fprintf('a1 = %.3f\n', LNA1.a1);
fprintf('a2 = %.3e\n', LNA1.a2);
fprintf('a3 = %.3e\n', LNA1.a3);
fprintf('IIP3 = %.2f dBm\n', LNA1.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_LNA1);
fprintf('OP1dB = %.2f dBm\n', LNA1.OP1dB);
fprintf('A_1dB = %.2f V\n', LNA1.A_1dB);
fprintf('Output noise RMS = %.3e V\n', LNA1.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', LNA1.NoisePower_dBm);
%% -----------------------------------------------------------------
fprintf('--- LNA2 Behavioral Model ---\n');
fprintf('a1 = %.3f\n', LNA2.a1);
fprintf('a2 = %.3e\n', LNA2.a2);
fprintf('a3 = %.3e\n', LNA2.a3);
fprintf('IIP3 = %.2f dBm\n', LNA2.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_LNA2);
fprintf('OP1dB = %.2f dBm\n', LNA2.OP1dB);
fprintf('A_1dB = %.2f V\n', LNA2.A_1dB);
fprintf('Output noise RMS = %.3e V\n', LNA2.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', LNA2.NoisePower_dBm);
%% -----------------------------------------------------------------
fprintf('--- DSA1 Behavioral Model ---\n');
fprintf('a1 = %.3f\n', DSA1.a1);
fprintf('a2 = %.3e\n', DSA1.a2);
fprintf('a3 = %.3e\n', DSA1.a3);
fprintf('IIP3 = %.2f dBm\n', DSA1.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_DSA1);
fprintf('OP1dB = %.2f dBm\n', DSA1.OP1dB);
fprintf('A_1dB = %.2f V\n', DSA1.A_1dB);
fprintf('Output noise RMS = %.3e V\n', DSA1.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', DSA1.NoisePower_dBm);
%% -----------------------------------------------------------------
fprintf('--- RFAMP Behavioral Model ---\n');
fprintf('a1 = %.3f\n', RFAMP.a1);
fprintf('a2 = %.3e\n', RFAMP.a2);
fprintf('a3 = %.3e\n', RFAMP.a3);
fprintf('IIP3 = %.2f dBm\n', RFAMP.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_RFAMP);
fprintf('OP1dB = %.2f dBm\n', RFAMP.OP1dB);
fprintf('A_1dB = %.2f V\n', RFAMP.A_1dB);
fprintf('Output noise RMS = %.3e V\n', RFAMP.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', RFAMP.NoisePower_dBm);
%% -----------------------------------------------------------------
fprintf('--- DSA2 Behavioral Model ---\n');
fprintf('a1 = %.3f\n', DSA2.a1);
fprintf('a2 = %.3e\n', DSA2.a2);
fprintf('a3 = %.3e\n', DSA2.a3);
fprintf('IIP3 = %.2f dBm\n', DSA2.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_DSA2);
fprintf('OP1dB = %.2f dBm\n', DSA2.OP1dB);
fprintf('A_1dB = %.2f V\n', DSA2.A_1dB);
fprintf('Output noise RMS = %.3e V\n', DSA2.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', DSA2.NoisePower_dBm);
%% -----------------------------------------------------------------
fprintf('--- Mixer Behavioral Model ---\n');
fprintf('a1 = %.3f\n', Mixer.a1);
fprintf('a2 = %.3e\n', Mixer.a2);
fprintf('a3 = %.3e\n', Mixer.a3);
fprintf('IIP3 = %.2f dBm\n', Mixer.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_mix);
fprintf('OP1dB = %.2f dBm\n', Mixer.OP1dB);
fprintf('A_1dB = %.2f V\n', Mixer.A_1dB);
fprintf('Output noise RMS = %.3e V\n', Mixer.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', Mixer.NoisePower_dBm);
%% -----------------------------------------------------------------
fprintf('--- LPF Behavioral Model ---\n');
fprintf('a1 = %.3f\n', LPF.a1);
fprintf('a2 = %.3e\n', LPF.a2);
fprintf('a3 = %.3e\n', LPF.a3);
fprintf('IIP3 = %.2f dBm\n', LPF.IIP3_dB);
fprintf('OIP3 = %.2f dBm\n', OIP3_dB_LPF);
fprintf('OP1dB = %.2f dBm\n', LPF.OP1dB);
fprintf('A_1dB = %.2f V\n', LPF.A_1dB);
fprintf('Output noise RMS = %.3e V\n', LPF.vnoise_rms);
fprintf('Output noise RMS (dBm) = %.3e dBm\n', LPF.NoisePower_dBm);

%% -------------------- Input Test Type --------------------
test_type = input('Choose test type:\n 1. One tone\n 2. Two tones\n 3. Sweep Pin\n 4. Blocker test \n 5.SNDR \nChoice:');
%test_type = 5 ; %FAST_OP

if test_type == 1 || test_type == 2
    Pin_dBm = input('Enter total power of tones used in test (dBm): ');
    Pin_W   = 10^(Pin_dBm/10) / 1000;
    Vin_rms = sqrt(Pin_W * Z0);
    V_amp   = sqrt(2) * Vin_rms;
end

%% ==========================================================
%                       ONE-TONE TEST
% ==========================================================
if test_type == 1
    f1 = input('Enter frequency of tone (Hz): ');
    % Input signal
    Vin = V_amp * cos(2*pi*f1*t);
    V_LO = 2*cos(2*pi*(f1+100e6)*t);
   % Nonlinear output + noise
    Vout_LNA1 = LNA1.a1*Vin + LNA1.a2*Vin.^2 + LNA1.a3*Vin.^3 + LNA1.vnoise_rms*randn(size(Vin));
    Vout_LNA2 = LNA2.a1*Vout_LNA1 + LNA2.a2*Vout_LNA1.^2 + LNA2.a3*Vout_LNA1.^3 + LNA2.vnoise_rms*randn(size(Vout_LNA1));
    Vout_DSA = DSA.a1*Vout_LNA2 + DSA.a2*Vout_LNA2.^2 + DSA.a3*Vout_LNA2.^3 + DSA.vnoise_rms*randn(size(Vout_LNA2));
    Vout_mix = Mixer.a1*Vout_DSA + Mixer.a2*Vout_DSA.^2 + Mixer.a3*Vout_DSA.^3 + Mixer.vnoise_rms*randn(size(Vout_DSA));
    Vout_mix_Base_Band = Vout_mix .* V_LO;
    Vout_LPF = LPF.a1*Vout_mix_Base_Band + LPF.a2*Vout_mix_Base_Band.^2 + LPF.a3*Vout_mix_Base_Band.^3 + LPF.vnoise_rms*randn(size(Vout_mix_Base_Band));
    Vout_ADC = Vout_LPF + (7.5535e-10)*randn(size(Vout_LPF));
    % Spectrum computation
    NFFT = N;
    f = (-NFFT/2:NFFT/2-1)*(fs/NFFT);
    w = blackmanharris(N); WinGain = sum(w)/N;

    % Input FFT
    Vin_fft = fftshift(fft(Vin .* w, NFFT)) / N / WinGain;
    Pin_W   = (abs(Vin_fft)/sqrt(2)).^2 / Z0;
    Pin_dBm_FFT = 10*log10(Pin_W/1e-3) + 6;

    % Output FFT
    Vout_fft = fftshift(fft(Vout_mix_Base_Band .* w, NFFT)) / N / WinGain;
    Pout_W   = (abs(Vout_fft)/sqrt(2)).^2 / Z0;
    Pout_dBm = 10*log10(Pout_W/1e-3) + 6;

    % Plot spectra
    figure;
    subplot(2,1,1);
    plot(f/1e6, Pin_dBm_FFT); grid on;
    xlabel('Frequency (MHz)'); ylabel('Input Power (dBm)');
    title('Single-Tone Input Spectrum'); xlim([0 9000]);

    subplot(2,1,2);
    plot(f/1e6, Pout_dBm); grid on;
    xlabel('Frequency (MHz)'); ylabel('Output Power (dBm)');
    title('Single-Tone Output Spectrum'); xlim([0 9000]);
end

%% ==========================================================
%                       TWO-TONE TEST
% ==========================================================
if test_type == 2
    f1 = input('Enter frequency of tone 1 (Hz): ');
    f2 = input('Enter frequency of tone 2 (Hz): ');
    f_LO = (f1+f2)/2;
    % Two-tone input signal
    Vin = (V_amp/sqrt(2)) * (cos(2*pi*f1*t) + cos(2*pi*f2*t));
    V_LO = 2*cos(2*pi*f_LO*t);
    % Nonlinear output + noise
    Vout_LNA1 = LNA1.a1*Vin + LNA1.a2*Vin.^2 + LNA1.a3*Vin.^3 + LNA1.vnoise_rms*randn(size(Vin));
    Vout_LNA2 = LNA2.a1*Vout_LNA1 + LNA2.a2*Vout_LNA1.^2 + LNA2.a3*Vout_LNA1.^3 + LNA2.vnoise_rms*randn(size(Vout_LNA1));
    Vout_DSA = DSA.a1*Vout_LNA2 + DSA.a2*Vout_LNA2.^2 + DSA.a3*Vout_LNA2.^3 + DSA.vnoise_rms*randn(size(Vout_LNA2));
    Vout_mix = Mixer.a1*Vout_DSA + Mixer.a2*Vout_DSA.^2 + Mixer.a3*Vout_DSA.^3 + Mixer.vnoise_rms*randn(size(Vout_DSA));
    Vout_mix_Base_Band = Vout_mix .* V_LO;
    Vout_LPF = LPF.a1*Vout_mix_Base_Band + LPF.a2*Vout_mix_Base_Band.^2 + LPF.a3*Vout_mix_Base_Band.^3 + LPF.vnoise_rms*randn(size(Vout_mix_Base_Band));
    Vout_ADC = Vout_LPF + (7.5535e-10)*randn(size(Vout_LPF));
    % FFT setup
    NFFT = N;
    f = (-NFFT/2:NFFT/2-1)*(fs/NFFT);
    w = blackmanharris(N); WinGain = sum(w)/N;

    % Input FFT
    Vin_fft = fftshift(fft(Vin .* w, NFFT)) / N / WinGain;
    Pin_W = (abs(Vin_fft)/sqrt(2)).^2 / Z0;
    Pin_dBm_FFT = 10*log10(Pin_W/1e-3) + 6;

    % Output FFT
    Vout_fft = fftshift(fft(Vout_ADC .* w, NFFT)) / N / WinGain;
    Pout_W = (abs(Vout_fft)/sqrt(2)).^2 / Z0;
    Pout_dBm = 10*log10(Pout_W/1e-3) + 6;

    % Identify fundamental & IM3 tones
    [~, i1]     = min(abs(f - (f1-f_LO)));
    [~, iIM3L]  = min(abs(f - ((2*f1 - f2)-f_LO)));

    % Extract powers
    Pfund_dBm = Pout_dBm(i1) + 3;
    Pim3_dBm  = Pout_dBm(iIM3L) + 3;
    Gain_calculated = Pfund_dBm - Pin_dBm;
    IIP3_dBm_calc = Pin_dBm + (Pfund_dBm - Pim3_dBm)/2;
    OIP3_dBm_calc = Pfund_dBm + (Pfund_dBm - Pim3_dBm)/2;

    % Display results
    fprintf('\nFundamental = %.2f dBm\n', Pfund_dBm);
    fprintf('IM3 = %.2f dBm\n', Pim3_dBm);
    fprintf('Gain = %.2f dB\n', Gain_calculated);
    fprintf('IIP3 = %.2f dBm, OIP3 = %.2f dBm\n', IIP3_dBm_calc, OIP3_dBm_calc);

    % Plot spectra
    figure;
    subplot(2,1,1);
    plot(f/1e6, Pin_dBm_FFT); grid on;
    xlabel('Frequency (MHz)'); ylabel('Input Power (dBm)');
    title('Two-Tone Input Spectrum'); xlim([0 8000]);

    subplot(2,1,2);
    plot(f/1e6, Pout_dBm); grid on;
    xlabel('Frequency (MHz)'); ylabel('Output Power (dBm)');
    title('Two-Tone Output Spectrum (with IM3)'); xlim([0 8000]);
end

%% ==========================================================
%                       PIN SWEEP TEST
% ==========================================================
if test_type == 3
    f1 = input('Enter frequency of tone 1 (Hz): ');
    f2 = input('Enter frequency of tone 2 (Hz): ');
    f_LO = (f1+f2)/2;
    Pin_dBm_vec_total_SS = -60:0.5:-15;  % Sweep range

    % Preallocate results
    Pfund = zeros(size(Pin_dBm_vec_total_SS));
    Pim3  = zeros(size(Pin_dBm_vec_total_SS));
    Gain  = zeros(size(Pin_dBm_vec_total_SS));
    OIP3  = zeros(size(Pin_dBm_vec_total_SS));

    % Sweep loop
    for k = 1:length(Pin_dBm_vec_total_SS)
        Pin_dBm_total_SS = Pin_dBm_vec_total_SS(k);
        Pin_dBm_per_tone_SS = Pin_dBm_total_SS - 3;
        Pin_W_per_tone = 10^(Pin_dBm_per_tone_SS/10)/1000;
        Vin_rms = sqrt(Pin_W_per_tone * Z0);
        Vin_amp = sqrt(2) * Vin_rms;

        % Generate two-tone input
        Vin = Vin_amp * (sin(2*pi*f1*t) + sin(2*pi*f2*t));
        V_LO = 2*cos(2*pi*f_LO*t);
        % Nonlinear output + noise
        Vout_LNA1 = LNA1.a1*Vin + LNA1.a2*Vin.^2 + LNA1.a3*Vin.^3 + LNA1.vnoise_rms*randn(size(Vin));
        Vout_LNA2 = LNA2.a1*Vout_LNA1 + LNA2.a2*Vout_LNA1.^2 + LNA2.a3*Vout_LNA1.^3 + LNA2.vnoise_rms*randn(size(Vout_LNA1));
        Vout_DSA = DSA.a1*Vout_LNA2 + DSA.a2*Vout_LNA2.^2 + DSA.a3*Vout_LNA2.^3 + DSA.vnoise_rms*randn(size(Vout_LNA2));
        Vout_mix = Mixer.a1*Vout_DSA + Mixer.a2*Vout_DSA.^2 + Mixer.a3*Vout_DSA.^3 + Mixer.vnoise_rms*randn(size(Vout_DSA));
        Vout_mix_Base_Band = Vout_mix .* V_LO;
        Vout_LPF = LPF.a1*Vout_mix_Base_Band + LPF.a2*Vout_mix_Base_Band.^2 + LPF.a3*Vout_mix_Base_Band.^3 + LPF.vnoise_rms*randn(size(Vout_mix_Base_Band));
        Vout_ADC = Vout_LPF + (7.5535e-10)*randn(size(Vout_LPF));


        % Spectrum
        w = blackmanharris(N); WinGain = sum(w)/N;
        Vout_fft = fftshift(fft(Vout_ADC .* w))/N/WinGain;
        f = (-N/2:N/2-1)*(fs/N);
        Pout_W = (abs(Vout_fft)/sqrt(2)).^2 / Z0;
        Pout_dBm = 10*log10(Pout_W/1e-3);

        % Extract tones
        [~, i1]     = min(abs(f - (f1-f_LO)));
        [~, iIM3L]  = min(abs(f - ((2*f1 - f2)-f_LO)));

        Pfund(k) = Pout_dBm(i1) + 6;
        Pim3(k)  = Pout_dBm(iIM3L) + 6;
        Gain(k)  = Pfund(k) - Pin_dBm_per_tone_SS;
        OIP3(k)  = Pfund(k) + (Pfund(k) - Pim3(k))/2;
    end

    % Plot results
    figure;
    subplot(2,2,1);
    plot(Pin_dBm_vec_total_SS, Gain, 'o-'); grid on;
    xlabel('Pin (dBm)'); ylabel('Gain (dB)');
    title('Gain vs Input Power');

    subplot(2,2,2);
    plot(Pin_dBm_vec_total_SS, Pfund + 3, 'o-'); grid on;
    xlabel('Pin (dBm)'); ylabel('Fundamental Pout (dBm)');
    title('Fundamental Output Power');

    subplot(2,2,3);
    plot(Pin_dBm_vec_total_SS, Pim3 + 3, 'o-'); grid on;
    xlabel('Pin (dBm)'); ylabel('IM3 (dBm)');
    title('IM3 vs Input Power');

    subplot(2,2,4);
    plot(Pfund + 3, OIP3, 'o-'); grid on;
    xlabel('Pout (dBm)'); ylabel('OIP3 (dBm)');
    title('OIP3 vs Output Power');
end

%% ==========================================================
%                       BLOCKER TEST
% ==========================================================
if test_type == 4 
    
    fprintf('\n--- Desired signal ---\n');
    f1 = input('Enter desired tone 1 (Hz): ');
    f2 = input('Enter desired tone 2 (Hz): ');
    Pin_sig_dBm = input('Enter total power of two deired tone (dBm): ');
    %f_LO = (f1+f2)/2;
	f_LO = 1e9;
    % Convert signal tone power (dBm) ? amplitude (V)
    Pin_sig_W = 10^((Pin_sig_dBm)/10) / 1000;
    Vsig_rms  = sqrt(Pin_sig_W * Z0);
    A_sig     = sqrt(2) * Vsig_rms;  % peak voltage
    fprintf('\n--- Blockers ---\n');
    num_blockers = input('Number of blocker tones (1 to 3): ');

    % Initialize blocker signal
    blocker = zeros(size(t));

    % Blocker 1
    if num_blockers >= 1
        fb1 = input('Enter blocker f1 (Hz): ');
        Pblocker_dBm1 = input('Enter power of blocker tone 1 (dBm): ');
        Pblocker_W1 = 10^(Pblocker_dBm1/10)/1000;
        Vb_rms1 = sqrt(Pblocker_W1 * Z0);
        Ab1 = sqrt(2) * Vb_rms1;
        blocker = blocker + Ab1 * cos(2*pi*fb1*t);
    end

    % Blocker 2
    if num_blockers >= 2
        fb2 = input('Enter blocker f2 (Hz): ');
        Pblocker_dBm2 = input('Enter power of blocker tone 2 (dBm): ');
        Pblocker_W2 = 10^(Pblocker_dBm2/10)/1000;
        Vb_rms2 = sqrt(Pblocker_W2 * Z0);
        Ab2 = sqrt(2) * Vb_rms2;
        blocker = blocker + Ab2 * cos(2*pi*fb2*t);
    end

    % Blocker 3
    if num_blockers == 3
        fb3 = input('Enter blocker f3 (Hz): ');
        Pblocker_dBm3 = input('Enter power of blocker tone 3 (dBm): ');
        Pblocker_W3 = 10^(Pblocker_dBm3/10)/1000;
        Vb_rms3 = sqrt(Pblocker_W3 * Z0);
        Ab3 = sqrt(2) * Vb_rms3;
        blocker = blocker + Ab3 * cos(2*pi*fb3*t);
    end
    % Composite input (signal + blockers)
    NFFT=N;
    f = (-NFFT/2:NFFT/2-1)*(fs/NFFT);
    w = blackmanharris(N); WinGain = sqrt(sum(w.^2)/N);
    Vin = A_sig*(cos(2*pi*f1*t) + cos(2*pi*f2*t)) + blocker;

        V_LO = 2*cos(2*pi*f_LO*t);
        % Nonlinear output + noise
        Vout_LNA1 = LNA1.a1*Vin + LNA1.a2*Vin.^2 + LNA1.a3*Vin.^3 + LNA1.vnoise_rms*randn(size(Vin))*0;
        Vout_LNA2 = LNA2.a1*Vout_LNA1 + LNA2.a2*Vout_LNA1.^2 + LNA2.a3*Vout_LNA1.^3 + LNA2.vnoise_rms*randn(size(Vout_LNA1))*0;
        Vout_DSA = DSA.a1*Vout_LNA2 + DSA.a2*Vout_LNA2.^2 + DSA.a3*Vout_LNA2.^3 + DSA.vnoise_rms*randn(size(Vout_LNA2))*0;
        Vout_mixer = Mixer.a1*Vout_DSA + Mixer.a2*Vout_DSA.^2 + Mixer.a3*Vout_DSA.^3 + Mixer.vnoise_rms*randn(size(Vout_DSA))*0;
        Vout_mix_Base_Band = Vout_mixer .* V_LO;
        Vout_LPF = LPF.a1*Vout_mix_Base_Band + LPF.a2*Vout_mix_Base_Band.^2 + LPF.a3*Vout_mix_Base_Band.^3 + LPF.vnoise_rms*randn(size(Vout_mix_Base_Band))*0;
		Vout_LPF_fft = fftshift(fft(Vout_LPF .* w,NFFT))/N/WinGain;
		filter_ATF = 10^(-33/20) * 200e6./f(f<-200e6 | f >200e6);
		Vout_LPF_fft(f<-200e6 | f>200e6) = Vout_LPF_fft(f<-200e6 | f>200e6).*abs(filter_ATF)';
		Vout_LPF_ifft =ifft(ifftshift(Vout_LPF_fft)*N*WinGain)./w;
		%Vout_Amp = AMP.a1*Vout_LPF + AMP.a2 * Vout_LPF.^2 + AMP.a3 * Vout_LPF.^3;
		Vout_Amp = AMP.a1*Vout_LPF_ifft + AMP.a2 * Vout_LPF_ifft.^2 + AMP.a3 * Vout_LPF_ifft.^3;
        Vout_ADC = Vout_Amp + (7.5535e-10)*randn(size(Vout_Amp))*0;

    % FFT and Power Spectrum
%    NFFT=N;
%    f = (-NFFT/2:NFFT/2-1)*(fs/NFFT);
%    w = blackmanharris(N); WinGain = sum(w)/N;

    Vin_fft = fftshift(fft(Vin.*w, NFFT))/N/WinGain;
    %Vin_fft = fftshift(fft(Vin, NFFT))/N;
    Vout_fft = fftshift(fft(Vout_ADC.*w, NFFT))/N/WinGain;
    %Vout_fft = fftshift(fft(Vout_LNA1, NFFT))/N;

    V_base_band_fft = fftshift(fft(Vout_mix_Base_Band.*w, NFFT))/N/WinGain;
	Power_befor_LPF=10*log10(sum(abs(V_base_band_fft).^2/(Z0)))+30
	Output_Power=10*log10(sum(abs(Vout_fft).^2/(Z0)))+30
	Input_power =10*log10(sum(abs(Vin_fft).^2/(Z0)))+30
    Pin_dBm_FFT  = 10*log10((abs(Vin_fft).^2)/(Z0))+30;
    Pout_dBm = 10*log10((abs(Vout_fft).^2)/(Z0))+30;

	Pout_W = abs(Vout_fft).^2/Z0;
	[~, morad] = min(abs(f - (f1-f_LO)));
	[~, badawy] = min(abs(f - (f2-f_LO)));
	[~, morad2] = min(abs(f + (f1-f_LO)));
	[~, badawy2] = min(abs(f + (f2-f_LO)));
	P_sig = sum(Pout_W(morad-3:morad+3)) + sum(Pout_W(badawy-3:badawy+3)) +sum(Pout_W(morad2-3:morad2+3)) + sum(Pout_W(badawy2-3:badawy2+3));
	SDR = 10*log10(P_sig/(sum(Pout_W)-P_sig))
    % Plot results
    figure;
    subplot(2,1,1);
    h_plot1= plot(f/1e6, Pin_dBm_FFT, 'LineWidth', 1.1); grid on;
    xlabel('Frequency (MHz)'); ylabel('Input Power (dBm)');
    title('Input Spectrum (Signal + Blocker(s))');
    xlim([0 fs/2/1e6]);

    subplot(2,1,2);
    h_plot2=plot(f/1e6, Pout_dBm, 'LineWidth', 1.1); grid on;
    xlabel('Frequency (MHz)'); ylabel('Output Power (dBm)');
    title('Output Spectrum (with LNA Nonlinearity + Noise)');
    xlim([0 200e6/1e6]);
end

%% ==========================================================
%            SNR / SDR / SNDR SWEEP vs Input Power
%        (distortion calculated only inside the channel)
% ==========================================================
if test_type == 5

    % ---------- Simulation Setup ----------
    N  = 2^16;
    t  = (0:N-1)'/fs;
    NFFT = N;
    f = (-NFFT/2:NFFT/2-1)*(fs/NFFT);
    w = blackmanharris(N); 
    %WinGain = sum(w)/N;
	WinGain = sqrt(sum(w.^2)/N);
    
    % ---------- Tone definitions ----------
   % f1 = input('Enter desired tone 1 (Hz): ');
   % f2 = input('Enter desired tone 2 (Hz): ');
	f1 = 1.17e9;  %FAST_OP
	f2 = 1.18e9; %FAST_OP
    f_LO=1e9;
    BW_chan = 200e6; % channel bandwidth

    % ---------- Blocker definitions ----------
    num_blockers = input('Enter number of blockers (0-3): ');
	%num_blockers = 0 ; %FAST_OP
	%num_blockers = 1; %FAST_OP
    blocker_freqs = zeros(1,num_blockers);
    blocker_powers_dBm = zeros(1,num_blockers);
    for i = 1:num_blockers
   %     blocker_freqs(i) = input(sprintf('Enter blocker %d frequency (Hz): ', i));
   %     blocker_powers_dBm(i) = input(sprintf('Enter blocker %d power (dBm): ', i));
	   blocker_freqs(1)  = 1.3e9;   %FAST_OP
	   blocker_powers_dBm(1) = -15; %FAST_OP
%	   blocker_freqs(2)  = 1.3e9;   %FAST_OP
%	   blocker_freqs(3) = 1.35e9;   %FAST_OP
%	   blocker_powers_dBm(2) = -61; %FAST_OP
%	   blocker_powers_dBm(3) = -61; %FAST_OP
    end

    % ---------- Sweep input power ----------
    Pin_dBm_vec = -100:1:-10; % dBm range
	%Pin_dBm_vec = -20;
    SNR_vec  = zeros(size(Pin_dBm_vec));
    SDR_vec  = zeros(size(Pin_dBm_vec));
    SNDR_vec = zeros(size(Pin_dBm_vec));
	Blocker_exist =0;
    for k = 1:length(Pin_dBm_vec)
        Pin_dBm = Pin_dBm_vec(k);

        % ---------- Input voltage ----------
        Pin_W   = 10^(Pin_dBm/10)/1000;   % per-tone power
        Vin_rms = sqrt(Pin_W * Z0);
        V_amp   = sqrt(2) * Vin_rms;

        % ---------- Two-tone input ----------
        Vin = V_amp * (cos(2*pi*f1*t) + cos(2*pi*f2*t));
        
        % ---------- Add blockers ----------
		if (Pin_dBm > -89+3+3 )

			for i = 1:num_blockers
				G_dB_DSA1 = G_dB_DSA1_vec(k-1);
				if( G_dB_DSA1 >= G_dB_DSA1_MAX - 3)
					G_dB_DSA1 = G_dB_DSA1_MAX -  3 ;
				end

				Pblock_W = 10^(blocker_powers_dBm(i)/10)/1000;
				Vb_rms   = sqrt(Pblock_W * Z0);
				Vb_amp   = sqrt(2) * Vb_rms;
				Vin      = Vin + Vb_amp * cos(2*pi*blocker_freqs(i)*t);
			end
		end

		%% Gain Policy
		%% DSA control
%		if(Pin_dBm >= -43)
%			G_dB_DSA = -3 - (Pin_dBm +43);
%			if(G_dB_DSA <=-23)
%				G_dB_DSA = -23;
%			end
%		else
%			G_dB_DSA = -3;
%		end
% Optimum Gain Policy
%		if(k>=2 & (SDR_vec(k-1) <= SNR_vec(k-1) +3 | Pout_ADC_vec(k-1)+1 > -10) )
%			G_dB_DSA = G_dB_DSA_vec(k-1) - 1;
%			if( G_dB_DSA <= -23)
%				G_dB_DSA = -23;
%			end
%		end
		% Policy Two
		if(k >1)
			Margin = -4;
%			if (Power_befor_LPF_vec(k-1) >= -15 +G_dB_LNA1 + G_dB_LNA2 + -3 + G_dB_mix -Margin)
%				Blocker_exist = 1;
%			end
%(Power_befor_LPF_vec(k-1) >= LPF.OP1dB - G_dB_LPF - 6 )
			[IIP3_till_LPF OIP3_till_LPF] = IP3_calc([LNA1 LNA2 DSA1 RFAMP DSA2 Mixer LPF]);

			NEGATIVE_STEPS = 0;
			if(Pout_ADC_vec2(k-1)  + Power_befor_LPF_vec(k-1) + G_dB_LPF >= -45 + 2*OIP3_till_LPF + G_dB_Amp_vec(k-1)-6 - Margin)
				NEGATIVE_STEPS = 1;
				G_dB_DSA1 = G_dB_DSA1 - 1;
				if(G_dB_DSA1 < G_dB_DSA1_MAX - DSA1_Range)
					G_dB_DSA1 = G_dB_DSA1_MAX- DSA1_Range;
					G_dB_DSA2 = G_dB_DSA2_vec(k-1) - 1;
					if( G_dB_DSA2 <= G_dB_DSA2_MAX-DSA2_Range)
						G_dB_DSA2 = G_dB_DSA2_MAX-DSA2_Range;
						NEGATIVE_STEPS = 0;
					end
				end
			end
			if(round(Pout_ADC_vec2(k-1)) >= -20)
				NUMBER_OF_STEPS = ceil(Pout_ADC_vec2(k-1)  + 20 )+1-NEGATIVE_STEPS;
				%if(Blocker_exist & G_dB_DSA1_vec(k-1) > -3-DSA1_Range)
				%	G_dB_DSA1 = G_dB_DSA1_vec(k-1) - 1;
				%	if( G_dB_DSA1 <= -3-DSA1_Range)
				%		G_dB_DSA1 = -3-DSA1_Range;
				%	end
				%else
				while (NUMBER_OF_STEPS > 0)
					G_dB_Amp = G_dB_Amp_vec(k-1) - 1;
					if ( G_dB_Amp < G_dB_AMP_MAX-AMP_Range)
						G_dB_Amp = G_dB_AMP_MAX-AMP_Range;
						G_dB_DSA1 = G_dB_DSA1_vec(k-1) - 1;
						if( G_dB_DSA1 < G_dB_DSA1_MAX-DSA1_Range)
							G_dB_DSA1 = G_dB_DSA1_MAX-DSA1_Range;
							G_dB_DSA2 = G_dB_DSA2_vec(k-1) - 1;
							if(G_dB_DSA2 < G_dB_DSA2_MAX-DSA2_Range)
								G_dB_DSA2 = G_dB_DSA2_MAX - DSA2_Range;
							end
						end
					end
					NUMBER_OF_STEPS = NUMBER_OF_STEPS-1;
				end
				%end
			end
		end 

		G_dB_DSA1_vec(k) = G_dB_DSA1;
		G_dB_DSA2_vec(k) = G_dB_DSA2;
		G_dB_Amp_vec(k) = G_dB_Amp;
		
		DSA1 = analyze_block(G_dB_DSA1, OIP3_dB_DSA1, OIP2_dB_DSA1, -G_dB_DSA1, Z0, B, T,MODEL_IP2);
		DSA2 = analyze_block(G_dB_DSA2, OIP3_dB_DSA2, OIP2_dB_DSA2, -G_dB_DSA2, Z0, B, T,MODEL_IP2);
		AMP = analyze_block(G_dB_Amp, OIP3_dB_Amp, OIP2_dB_Amp, NF_dB_Amp+(G_dB_AMP_MAX - G_dB_Amp), Z0, B, T,MODEL_IP2);
        % ---------- LNA output ----------
        % Pass through nonlinear LNA model
        V_LO = 2*cos(2*pi*f_LO*t);
        % Nonlinear output + noise
        Vout_LNA1 = LNA1.a1*Vin + LNA1.a2*Vin.^2 + LNA1.a3*Vin.^3 + LNA1.vnoise_rms*randn(size(Vin))*0;
        Vout_LNA2 = LNA2.a1*Vout_LNA1 + LNA2.a2*Vout_LNA1.^2 + LNA2.a3*Vout_LNA1.^3 + LNA2.vnoise_rms*randn(size(Vout_LNA1))*0;
        Vout_DSA1 = DSA1.a1*Vout_LNA2 + DSA1.a2*Vout_LNA2.^2 + DSA1.a3*Vout_LNA2.^3 + DSA1.vnoise_rms*randn(size(Vout_LNA2))*0;
        Vout_RFAMP = RFAMP.a1*Vout_DSA1 + RFAMP.a2*Vout_DSA1.^2 + RFAMP.a3*Vout_DSA1.^3 + RFAMP.vnoise_rms*randn(size(Vout_DSA1))*0;
        Vout_DSA2 = DSA2.a1*Vout_RFAMP + DSA2.a2*Vout_RFAMP.^2 + DSA2.a3*Vout_RFAMP.^3 + DSA2.vnoise_rms*randn(size(Vout_RFAMP))*0;
        Vout_mixer = Mixer.a1*Vout_DSA2 + Mixer.a2*Vout_DSA2.^2 + Mixer.a3*Vout_DSA2.^3 + Mixer.vnoise_rms*randn(size(Vout_DSA2))*0;
        Vout_mix_Base_Band = Vout_mixer .* V_LO;
        Vout_LPF = LPF.a1*Vout_mix_Base_Band + LPF.a2*Vout_mix_Base_Band.^2 + LPF.a3*Vout_mix_Base_Band.^3 + LPF.vnoise_rms*randn(size(Vout_mix_Base_Band))*0;
		Vout_LPF_fft = fftshift(fft(Vout_LPF .* w,NFFT))/N/WinGain;

		filter_FULL = ones(size(f));
		FILTER_REJECTION = -25;
		%Assume Order = 1
		filter_ATF = 10^(FILTER_REJECTION/20) * 250e6./f(f<-250e6 | f >250e6);
		filter_FULL(f<-250e6 | f >250e6)= filter_ATF;
		Vout_LPF_fft(f<-250e6 | f>250e6) = Vout_LPF_fft(f<-250e6 | f>250e6).*abs(filter_ATF)';
		Vout_LPF_ifft =ifft(ifftshift(Vout_LPF_fft)*N*WinGain)./w;
		%Vout_Amp = AMP.a1*Vout_LPF + AMP.a2 * Vout_LPF.^2 + AMP.a3 * Vout_LPF.^3;
		Vout_Amp = AMP.a1*Vout_LPF_ifft + AMP.a2 * Vout_LPF_ifft.^2 + AMP.a3 * Vout_LPF_ifft.^3;
        Vout_ADC = Vout_Amp + (7.5535e-10)*randn(size(Vout_Amp))*0;


        % ---------- FFT ----------
        Vout_fft = fftshift(fft(Vout_ADC .* w, NFFT)) / N / WinGain;
        %Vout_fft = 2*fftshift(fft(Vout_ADC))/N ;
        Pout_W   = (abs(Vout_fft)).^2 / Z0;
		V_base_band_fft = fftshift(fft(Vout_mix_Base_Band.*w, NFFT))/N/WinGain;
		Power_befor_LPF=10*log10(sum(abs(V_base_band_fft).^2/(Z0)))+30;
		Power_befor_LPF_vec(k) = Power_befor_LPF;
		
%        Vin_fft = fftshift(fft(Vin .* w, NFFT)) / N / WinGain;
%        Vin_fft = fftshift(fft(Vin)) /length(Vin);
%        Pin_W   = (abs(Vin_fft)).^2 / Z0;
        % ---------- Desired tones ----------
        [~, idx1] = min(abs(f + 200e6));
        [~, idx2] = min(abs(f - 200e6));

		[~, morad] = min(abs(f - (f1-f_LO)));
		[~, badawy] = min(abs(f - (f2-f_LO)));
		[~, morad2] = min(abs(f + (f1-f_LO)));
		[~, badawy2] = min(abs(f + (f2-f_LO)));
		P_sig = sum(Pout_W(morad-3:morad+3)) + sum(Pout_W(badawy-3:badawy+3)) +sum(Pout_W(morad2-3:morad2+3)) + sum(Pout_W(badawy2-3:badawy2+3));

		% ---------- Noise ----------
		No       = 10^((-174-30)/10);
		G_lin    = (LNA1.a1*LNA2.a1*DSA1.a1*RFAMP.a1*DSA2.a1*Mixer.a1*LPF.a1*AMP.a1)^2; 
		% Calculate Noise figure
		%F_DSA = 10^(IL_DSA_dBm/10);
		F_total = LNA1.NF_lin  + (LNA2.NF_lin - 1)/(LNA1.G_lin)+(DSA1.NF_lin - 1)/(LNA1.G_lin * LNA2.G_lin) + ...
		(RFAMP.NF_lin - 1)/(LNA1.G_lin * LNA2.G_lin * DSA1.G_lin) + ...
		(DSA2.NF_lin - 1)/(LNA1.G_lin * LNA2.G_lin * DSA1.G_lin * RFAMP.G_lin) + ...
		(Mixer.NF_lin-1)/(LNA1.G_lin * LNA2.G_lin *DSA1.G_lin * RFAMP.G_lin*DSA2.G_lin)+...
		(LPF.NF_lin - 1)/(LNA1.G_lin * LNA2.G_lin *DSA1.G_lin * RFAMP.G_lin*DSA2.G_lin*Mixer.G_lin)+...
		(AMP.NF_lin - 1)/(LNA1.G_lin * LNA2.G_lin *DSA1.G_lin * RFAMP.G_lin*DSA2.G_lin*Mixer.G_lin*LPF.G_lin);

		NF_total = 10 * log10(F_total);
		NF_total_vec(k) = NF_total;

		vnoise_rms = sqrt(No * (BW_chan*2) * G_lin * (10^(NF_total/10)));
		P_noise_inband_W = vnoise_rms^2;

		%?Add noise of ADC 
		%ADC_noise_dBm =-42;
		ADC_noise_dBm =-66;
		P_noise_ADC_W=10^(ADC_noise_dBm/10)/1000;


        % ---------- IM3 ----------
        %f_IM3_1 = abs((2*f1 - f2)-f_LO);
        %f_IM3_2 = abs((2*f2 - f1)-f_LO);
        %[~, idx_IM3_1] = min(abs(f - f_IM3_1));
        %[~, idx_IM3_2] = min(abs(f - f_IM3_2));
        %P_IM3 = Pout_W(idx_IM3_1) + Pout_W(idx_IM3_2);
        

		% DC cancellation
		[~ , idx_DC] = min(abs(f));
		Pout_W(idx_DC-3:idx_DC+3)=0;

		% Blocker bins
		[~ , idx_blocker_N300M] = min(abs(f+300e6));
		[~ , idx_blocker_P300M] = min(abs(f-300e6));
		
        Pout_W_blocker_out = sum(Pout_W(idx_blocker_N300M-3:idx_blocker_N300M+3)) + sum(Pout_W(idx_blocker_P300M-3:idx_blocker_P300M+3));
        % ---------- In-band distortion ----------
        idx_low  = min(idx1, idx2);
        idx_high = max(idx1, idx2);
        inband_bins = (idx_low):(idx_high);
        %P_inband_total = sum(Pout_W(inband_bins)) - P_sig;
        P_inband_total = sum(Pout_W(inband_bins)) - P_sig;
        P_dist_inband  = max(P_inband_total,eps);

        % ---------- Total distortion ----------
        P_dist_total = P_dist_inband;

        % ---------- Metrics ----------
        SNR_vec(k)  = 10*log10(P_sig / (P_noise_inband_W+P_noise_ADC_W));
        SDR_vec(k)  = 10*log10(P_sig / P_dist_total);
        SNDR_vec(k) = 10*log10(P_sig / (P_dist_total +P_noise_ADC_W+ P_noise_inband_W));
		Pout_ADC_vec(k) = 10*log10((sum(Pout_W)-Pout_W_blocker_out)*10+Pout_W_blocker_out+P_noise_inband_W)+30;
		Pout_ADC_vec2(k) = 10*log10(sum(Pout_W)-Pout_W_blocker_out*0.9+P_noise_inband_W)+30; % Blocker is 10 dB lower with respect to Gain Policy
    end

    % ---------- Plot ----------
	Pin_Min = zerocrossing(Pin_dBm_vec+3,SNDR_vec);
    figure;
    plot(Pin_dBm_vec+3, SNR_vec, '-o','LineWidth',1.2); hold on;
    plot(Pin_dBm_vec+3, SDR_vec, '-s','LineWidth',1.2);
    plot(Pin_dBm_vec+3, SNDR_vec,'-^','LineWidth',1.2);
    grid on;
    xlabel('total Input Power two tones(dBm)');
    ylabel('dB');
    title(['SNR, SDR, SNDR vs Input Power (including blockers), Pin min = ', num2str(Pin_Min(1))]);
    legend('SNR','SDR','SNDR','Location','best');
    plot(Pin_dBm_vec+3, zeros(size(Pin_dBm_vec)),'k--','LineWidth',0.9);
    plot(Pin_dBm_vec+3, ones(size(Pin_dBm_vec))*45,'k--','LineWidth',0.9);
	hold off;

	figure;
	Pin_Max = zerocrossing(Pin_dBm_vec+3,Pout_ADC_vec+10);
	Pin_Max = Pin_Max(end);
    plot(Pin_dBm_vec+3, Pout_ADC_vec, '-o','LineWidth',1.2); hold on;
	plot(Pin_dBm_vec+3 , ones(size(Pin_dBm_vec))*-10,'k--');
	title(['Pout to ADC, Pin_max = ',num2str(Pin_Max)]);
	xlabel('Pin (dBm)')
	ylabel('Pout (dBm)')
	hold off;
	
	figure;
    plot(Pin_dBm_vec+3, G_dB_DSA1_vec, '-o','LineWidth',1.2); hold on;
	%plot(Pin_dBm_vec+3 , ones(size(Pin_dBm_vec))*-20,'k--');
	title('DSA Gain Policy')
	xlabel('Pin (dBm)')
	ylabel('Gain ')
	hold off;

	figure;
    plot(Pin_dBm_vec+3, G_dB_DSA2_vec, '-o','LineWidth',1.2); hold on;
	%plot(Pin_dBm_vec+3 , ones(size(Pin_dBm_vec))*-20,'k--');
	title('DSA Gain Policy')
	xlabel('Pin (dBm)')
	ylabel('Gain ')
	hold off;

	figure;
    plot(Pin_dBm_vec+3, G_dB_Amp_vec, '-o','LineWidth',1.2); hold on;
	%plot(Pin_dBm_vec+3 , ones(size(Pin_dBm_vec))*-20,'k--');
	title('VGA Gain Policy')
	xlabel('Pin (dBm)')
	ylabel('Gain ')
	hold off;

	figure;
    plot(Pin_dBm_vec+3, Pin_dBm_vec-NF_total_vec+91 +3, '-o','LineWidth',1.2); hold on;
	%plot(Pin_dBm_vec+3 , ones(size(Pin_dBm_vec))*-20,'k--');
	title('SNR without ADC')
	xlabel('Pin (dBm)')
	ylabel('Gain ')
	hold off;



    G_total_vec = G_dB_LNA1 + G_dB_LNA2 +G_dB_DSA1_vec + G_dB_RFAMP +G_dB_DSA2_vec +G_dB_mix +G_dB_LPF +G_dB_Amp_vec ;
	figure;
    plot(Pin_dBm_vec+3, G_total_vec, '-o','LineWidth',1.2); hold on;
	%plot(Pin_dBm_vec+3 , ones(size(Pin_dBm_vec))*-20,'k--');
	title('Total Gain Policy')
	xlabel('Pin (dBm)')
	ylabel('Gain ')
	hold off;
end





%set(h_plot1, 'ButtonDownFcn', @make_plot_clickable);
%set(h_plot2, 'ButtonDownFcn', @make_plot_clickable);
%make_plot_clickable(h_plot1)
%make_plot_clickable(h_plot2)

%h_all_lines = findobj(0, 'Type', 'line');
%for h_line = h_all_lines
%        make_plot_clickable(h_line);
%end

%set(gca, "fontsize", 16, "linewidth", 2);
