%% Function 'Filter_BS_PF'
%
%   Filtering signal 'Sig' by Band-Stop (Notch) Filters at 50 Hz and its 
%   harmonics to eliminate power frequency noise.
%   
%   Format:
%		Sig_BSpf = Filter_BS_PF(Sig)
%
%%

function Sig_BSpf = Filter_BS_PF(Sig)

global Filter_Coef BS_PF

% Implement IIR notch filters by coef 'Filter_Coef.SOS_PF', 'Filter_Coef.G_PF'
N_PF            =   size(BS_PF);
Sig_BSpf        =   Sig;

for i = 1:N_PF(1)
    Sig_BSpf	=   filtfilt(Filter_Coef.SOS_PF{i,1},Filter_Coef.G_PF{i,1},Sig_BSpf);
end

end

