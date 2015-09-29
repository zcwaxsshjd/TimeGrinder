%% Function 'Filter_LP_MO'
%
%   Filtering motion signal 'Mot' by Low-Pass Filter 'LP_MO' for 
%   smoothing.
%
%   Format:
%		Mot_LPmo = Filter_LP_MO(Mot)
%
%%

function Sig_LPmo = Filter_LP_MO(Sig)

global Filter_Coef

% Implement IIR filter by coef 'Filter_Coef.SOS_SM', 'Filter_Coef.G_SM'
Sig_LPmo	=   filtfilt(Filter_Coef.SOS_SM,Filter_Coef.G_SM,Sig);

end

