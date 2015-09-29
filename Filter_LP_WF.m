%% Function 'Filter_LP_WF'
%
%   Filtering signal 'Sig' by IIR Filter 'LP_WF' to extract low-frequency
%   waveform (signiture pattern of EMG).
%
%   Format:
%		Sig_LPwf = Filter_LP_WF(Sig)
%
%%

function Sig_LPwf = Filter_LP_WF(Sig)

global Filter_Coef

% Implement IIR filter by coef 'Filter_Coef.num_LP_WF', 'Filter_Coef.den_LP_WF'
Sig_LPwf	=   filtfilt(Filter_Coef.num_LP_WF,Filter_Coef.den_LP_WF,Sig);

end

