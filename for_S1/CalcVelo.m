%%

%%

function Sig_v = CalcVelo(Sig)

global fs

Sig = Filter_LP_MO(Sig);
Sig_v = diff(Sig)*fs;
len = length(Sig);
Sig_v(len) = Sig_v(len-1);
Sig_v = Filter_LP_MO(Sig_v);

end

