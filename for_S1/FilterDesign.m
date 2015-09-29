%% Function 'FilterDesign.m'
%
%   Design all the filter coefficients for data processing
%   
%   Format:
%		Output = FilterDesign;
%
%%

function Output = FilterDesign

global fs LP_MO HP_DC BP_MA BS_PF BS_MT BS_MO LP_WF
global N_fft

% Normalize cut-off frequencies of IIR filters
Wn_HP_DC                                =   HP_DC/(fs/2);
Wn_BP_MA                                =   BP_MA/(fs/2);
Wn_LP_WF                                =   LP_WF/(fs/2);

% Design IIR filter coefficients
[Output.num_HP_DC,Output.den_HP_DC]     =   butter(4,Wn_HP_DC,'high');
[Output.num_BP_MA,Output.den_BP_MA]     =   butter(4,Wn_BP_MA);
[Output.num_LP_WF,Output.den_LP_WF]     =   butter(4,Wn_LP_WF,'low');


% Design low pass filter for smoothing motion
h                   =	fdesign.lowpass('fp,fst,ap,ast', LP_MO(1), LP_MO(2), LP_MO(3), LP_MO(4), fs);
Output.Hd_SM        =	design(h, 'butter', 'MatchExactly', 'passband', 'SystemObject', true);
Output.SOS_SM       =   Output.Hd_SM.SOSMatrix;
Output.G_SM         =   Output.Hd_SM.ScaleValues;


% Design power frequency notch filters for EMG
N_PF                =   size(BS_PF);
Output.Hd_PF        =   struct();
Output.SOS_PF       =   cell(N_PF(1),1);
Output.G_PF         =   cell(N_PF(1),1);

for i = 1:N_PF(1)
    h               =	fdesign.bandstop(BS_PF(i,1),BS_PF(i,2),BS_PF(i,3),BS_PF(i,4),BS_PF(i,5),BS_PF(i,6),BS_PF(i,7),fs);
    eval(['Output.Hd_PF.N' num2str(i) '= design(h,''butter'',''MatchExactly'',''passband'');']);
    eval(['Output.SOS_PF{i,1} = Output.Hd_PF.N' num2str(i) '.SOSMatrix;']);
    eval(['Output.G_PF{i,1} = Output.Hd_PF.N' num2str(i) '.ScaleValues;']);
end


% Design megnetic transmitter frequency notch filters for EMG
N_MT                =   size(BS_MT);
Output.Hd_MT        =   struct();
Output.SOS_MT       =   cell(N_MT(1),1);
Output.G_MT         =   cell(N_MT(1),1);

for i = 1:N_MT(1)
    h               =	fdesign.bandstop(BS_MT(i,1),BS_MT(i,2),BS_MT(i,3),BS_MT(i,4),BS_MT(i,5),BS_MT(i,6),BS_MT(i,7),fs);
    eval(['Output.Hd_MT.N' num2str(i) '= design(h,''butter'',''MatchExactly'',''passband'');']);
    eval(['Output.SOS_MT{i,1} = Output.Hd_MT.N' num2str(i) '.SOSMatrix;']);
    eval(['Output.G_MT{i,1} = Output.Hd_MT.N' num2str(i) '.ScaleValues;']);
end


% Design notch filters for Motion
N_MO                =   size(BS_MO);
Output.Hd_MO        =   struct();
Output.SOS_MO       =   cell(N_MO(1),1);
Output.G_MO         =   cell(N_MO(1),1);

for i = 1:N_MO(1)
    h               =	fdesign.bandstop(BS_MO(i,1),BS_MO(i,2),BS_MO(i,3),BS_MO(i,4),BS_MO(i,5),BS_MO(i,6),BS_MO(i,7),fs);
    eval(['Output.Hd_MO.N' num2str(i) '= design(h,''butter'',''MatchExactly'',''passband'');']);
    eval(['Output.SOS_MO{i,1} = Output.Hd_MO.N' num2str(i) '.sosMatrix;']);
    eval(['Output.G_MO{i,1} = Output.Hd_MO.N' num2str(i) '.ScaleValues;']);
end


%% Frequency responses of designed filters

if 0
    figure, freqz(Output.Hd_SM,N_fft,fs);
            title('Frequency Response of Low Pass Motion Filter');

    figure, freqz(Output.num_HP_DC,Output.den_HP_DC,N_fft,fs);
            title('Frequency Response of High Pass DC Filter');

    figure, freqz(Output.num_BP_MA,Output.den_BP_MA,N_fft,fs);
            title('Frequency Response of Band Pass Motion Artifact Filter');

    figure, freqz(Output.num_LP_WF,Output.den_LP_WF,N_fft,fs);
            title('Frequency Response of Low Pass Wave Form Filter');

    for i = 1:N_PF(1)
        eval(['freqz(Output.Hd_PF.N' num2str(i) ',N_fft,fs);']);
    end

    for i = 1:N_MT(1)
        eval(['freqz(Output.Hd_MT.N' num2str(i) ',N_fft,fs);']);
    end
end


end

