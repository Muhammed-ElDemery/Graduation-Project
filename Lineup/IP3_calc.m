function [IIP3,OIP3] = IP3_calc(Blocks)
	inv_IIP3_total = 0;
	GP_lin  = 1;
	for block = Blocks
		IIP3_W = 10^((block.IIP3_dB -30)/10);
		inv_IIP3_total = inv_IIP3_total + GP_lin/IIP3_W;
		GP_lin  = GP_lin*block.G_lin;
	end
	
	IIP3 = -10*log10(inv_IIP3_total)+30;
	OIP3 =  IIP3 + 10*log10(GP_lin);
end
