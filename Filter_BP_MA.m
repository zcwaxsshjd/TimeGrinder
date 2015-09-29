%% Function 'Filter_BP_MA'
%
%   Filtering signal 'Sig' by Band-Pass IIR Filter 'BP_MA' to separate EMG
%   from motion artifact and high-frequency noise.
%
%   Format:
%		Sig_BPma = Filter_BP_MA(Sig)
%
%%

function Sig_BPma = Filter_BP_MA(Sig)

global Filter_Coef

% Implement IIR filter by coef 'Filter_Coef.num_BP_MA', 'Filter_Coef.den_BP_MA'
Sig_BPma	=   filtfilt(Filter_Coef.num_BP_MA,Filter_Coef.den_BP_MA,Sig);

end

