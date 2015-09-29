%% initialize
clear all;
clc;
close all;

fs = 2410;
Dir = [pwd '\ProcessedData\S2'];
ExpList = GetExpList(Dir);
N = length(ExpList);

%% Analysis the data of lateral reaching movement
for i = 1:N
    EMG_forSynergy = [];
    
    %% find onset time
    filename = [Dir '\' ExpList{i}];
    Data = importdata(filename);
%     onset = findOnset(Data);
    
    %% filte and rectify the EMG
    Data = Filtering(Data);
    
    %% synergy analysis
    ini = 1;
    st = 10000;
    EMG_temp = [Data.PC_p(ini:st) Data.DP_p(ini:st) Data.Biceps_p(ini:st) ...
                            Data.Tlt_p(ini:st) Data.Tlh_p(ini:st)];
%     Data.PC_r           =   abs(Data.PC);
%     Data.DP_r           =   abs(Data.Posteriordeltoid);
%     Data.Biceps_r       =   abs(Data.Biceps);
%     Data.Tlt_r          =   abs(Data.Triceps_lateral);
%     Data.Tlh_r          =   abs(Data.Triceps_long);
%     EMG_temp = [Data.PC_r(onset:onset+12050) Data.DP_r(onset:onset+12050) Data.Biceps_r(onset:onset+12050) ...
%         Data.Tlt_r(onset:onset+12050) Data.Tlh_r(onset:onset+12050)];
    EMG_forSynergy = [EMG_forSynergy; EMG_temp'];
    Synergy = cell(5,1);
    VAF = zeros(5,1);
    EMG_forSynergy(EMG_forSynergy < 0) = 0;
    N_ch = 5;   % channel #
    for j = 1:N_ch
        [Synergy{j}, VAF(j)] = Synergy_Analysis(EMG_forSynergy, j);       
    end
    
    %% plot synergy
%     Plot_Synergy(Synergy_LLR, VAF_LLR, 'LLR', N_ch);
    taskname = filename((length(Dir)+2):end-4);
    Plot_Synergy(Synergy, VAF, taskname, N_ch);

    
end