function results = analyze_block(G_dB, OIP3_dB, OIP2_dB, NF_dB, Z0, B, T,MODEL_IP2)
    k = 1.38e-23;

    results.G_lin   = 10^(G_dB/10);
    results.NF_lin  = 10^(NF_dB/10);
    results.IIP3_dB = OIP3_dB - G_dB;

    P_IIP3_W   = 10^(results.IIP3_dB/10) / 1000;
    V_IIP3_rms = sqrt(P_IIP3_W * Z0);
    results.VIIP3 = sqrt(2) * V_IIP3_rms;
    %results.VIIP3 = V_IIP3_rms;

    results.P_OIP2_mW = 10^(OIP2_dB/10);
    results.a1 = sqrt(results.G_lin);
    results.a2 = -sqrt((500*(results.a1^4)) / (Z0 * results.P_OIP2_mW))*MODEL_IP2;
    results.a3 = -4 * results.a1 / (3 * results.VIIP3^2);

    results.A_1dB = sqrt(-0.145 * results.a1 / results.a3);
    results.OP1dB = 10*log10((results.A_1dB^2) / (2 * 1e-3 * Z0)) + G_dB;

    No = k * T;
    results.vnoise_rms = No * B * results.G_lin * (results.NF_lin - 1);
    results.NoisePower_dBm = 10 * log10(results.vnoise_rms);
end
