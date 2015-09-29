%% Function 'Filter_BS_MT'
%
%   Filtering signal 'Sig' by Band-Stop (Notch) Filters at 120 Hz and its 
%   harmonics to eliminate Megnetic Transmitter frequency noise.
%   
%   Format:
%		Sig_BSmt = Filter_BS_MT(Sig)
%
%%

function Sig_BSmt = Filter_BS_MT(Sig)

global Filter_Coef BS_MT

% Implement IIR notch filters by coef 'Filter_Coef.SOS_MT', 'Filter_Coef.G_MT'
N_MT            =   size(BS_MT);
Sig_BSmt        =   Sig;

for i = 1:N_MT(1)
    Sig_BSmt	=   filtfilt(Filter_Coef.SOS_MT{i,1},Filter_Coef.G_MT{i,1},Sig_BSmt);
end

end

