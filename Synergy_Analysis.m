%%

%%

function [Synergy, VAF] = Synergy_Analysis(EMG, N)

%% NMF

opt1        =	statset('MaxIter',100000,'Display','final', 'TolX', 1e-5,'TolFun', 1e-5);
[W1,H1]     =	nnmf(EMG,N,'replicates',25, 'options',opt1, 'algorithm','mult');

opt2        =	statset('MaxIter',100000,'Display','iter', 'TolX', 1e-5,'TolFun', 1e-5);
[W2,H2]     =	nnmf(EMG,N,'w0',W1,'h0',H1, 'options',opt2, 'algorithm','als');

Synergy.W   =   W2;
Synergy.H   =   H2;
Synergy.D   =   W2 * H2;
Synergy.EMG =   EMG;


%% Calculate variance account for of NMF algorithm
%	Based on the criterion of Variance Accounted For (VAF):
%	VAF = 100 * ( 1 - ( ||M - D|| / ||M-M_mean|| ) );
%	From: Investigating reduction of dimensionality during single-joint elbow movements:a case study on muscle synergies
%	D:	approximated matrix D= W * H
%	M:	original matrix

M               =   EMG;
D               =   Synergy.D;
[row, column]	=	size(M);

Method          =   3;

switch Method
    case 1              % 'PDsynergy_VaF_mean_1.mat'
        M_mean          =	repmat(mean(M,1),[row 1]);
        VAF             =	100 * ( 1 - ( norm(M - D) / norm(M - M_mean) ) );
        
    case 2              % 'PDsynergy_VaF_mean_2.mat'
        M_mean          =	repmat(mean(M,2),[1 column]);
        VAF             =	100 * ( 1 - ( norm(M - D) / norm(M - M_mean) ) );
        
    case 3              % 'PDsynergy_VaF_square.mat'
        M_mean          =	repmat(mean(M,2),[1 column]);
        VAF             =	100 * ( 1 - ( norm(M - D)^2 / norm(M - M_mean)^2 ) );
        
    case 4              % 'PDsynergy_VaF_M.mat'
        VAF             =	100 * ( 1 - ( norm(M - D)^2 / norm(M)^2 ) );
        
end


end

