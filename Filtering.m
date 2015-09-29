function Data = Filtering(Data)
%% parameter setting

global fs LP_MO HP_DC BP_MA BS_PF BS_MT LP_WF BS_MO
global Filter_Coef N_fft

fs          =   2410;       % Sampling frequency (Hz)

LP_MO       =   [15   20   0.1    20];        % Hz
                % Column 1 through 4:
                % Fpass, Fstop (Hz), Apass1, Astop (dB)
                % Low-Pass filter which extracts Motion from noise

HP_DC           =   1;          % Hz
                % Cut-off frequency of High-Pass filter which eliminate DC 
                % component
                
BP_MA           =   [20 390];	% Hz
                % Cut-off frequency of Band-Pass filter which extract EMG
                % and eliminate motion artifact

BS_PF           =   [49   49.5  50.5  51    1  30  1;       %  50 Hz
                     99   99.5  100.5 101   1  30  1;       % 100 Hz
                     149  149.5 150.5 151   1  30  1;       % 150 Hz
                     199  199.5 200.5 201   1  30  1;       % 200 Hz
                     249  249.5 250.5 251   1  30  1;       % 250 Hz
                     299  299.5 300.5 301   1  30  1;       % 300 Hz
                     349  349.5 350.5 351   1  30  1;       % 350 Hz
                     399  399.5 400.5 401   1  30  1;       % 400 Hz
                     449  449.5 450.5 451   1  30  1;       % 450 Hz
                     499  499.5 500.5 501   1  30  1];    	% 500 Hz
                % Column 1 through 7:
                % Fpass1, Fstop1, Fstop2, Fpass2(Hz), Apass1, Astop, Apass2(dB)
                % Cut-off frequency of Band-Stop filters which eliminate
                % Power Frequency and its harmonic noises, as well as
                % electrical stimulation artifacts from EMG

BS_MT           =   [119.5 120   121   121.5 1  30  1;      % 120.5 Hz
                     240.1 240.6 241.6 242.1 1  30  1;      % 241.1 Hz
                     360.6 361.1 362.1 362.6 1  30  1;      % 361.6 Hz
                     481.2 481.7 482.7 483.2 1  30  1;      % 482.2 Hz
                     
                     60.7  61.2  62.2  62.7  1  30  1;      %  61.7 Hz
                     160.7 161.2 162.2 162.7 1  30  1;      % 161.7 Hz
                     260.7 261.2 262.2 262.7 1  30  1;      % 261.7 Hz
                     360.7 361.2 362.2 362.7 1  30  1;      % 361.7 Hz
                     460.7 461.2 462.2 462.7 1  30  1;      % 461.7 Hz
                     
                     210.7 211.2 212.2 212.7 1  30  1;      % 211.7 Hz
                     310.7 311.2 312.2 312.7 1  30  1;      % 311.7 Hz
                     410.7 411.2 412.2 412.7 1  30  1];     % 411.7 Hz
%                      
%                      19.5  20    21    21.5  1  30  1;      %  20.5 Hz
%                      40    40.5  41.5  42    1  30  1;      %  41   Hz
%                      78.5  79    80    80.5  1  30  1;      %  79.5 Hz
%                      137.5 138   139   139.5 1  30  1;      % 138.5 Hz
%                      
%                      58    58.5  59.5  30    1  30  1;      %  59   Hz
%                      158.2 158.7 159.7 160.2 1  30  1;      % 159.2 Hz
%                      117   117.5 118.5 119   1  30  1;      % 118   Hz
%                      
%                      87.1  87.6  88.6  89.1  1  30  1;      %  88.1 Hz
%                      90.3  90.8  91.9  92.4  1  30  1;      %  91.4 Hz
%                      95.3  95.8  96.8  97.3  1  30  1;      %  96.3 Hz
%                      103   103.5 104.5 105   1  30  1;      % 104   Hz
%                      107.7 108.2 109.3 109.8 1  30  1;      % 108.7 Hz
%                      190.5 191   192   192.5 1  30  1;      % 191.5 Hz
%                      195   195.5 196.5 197   1  30  1;      % 196   Hz
%                      203   203.5 204.5 205   1  30  1;      % 204   Hz
%                      207.7 208.2 209.2 209.7 1  30  1;      % 208.7 Hz
%                      217   217.5 218.5 219   1  30  1;      % 218   Hz
%                      242.7 243.2 244.2 244.7 1  30  1;      % 243.7 Hz
%                      363.2 363.7 364.7 365.2 1  30  1;      % 364.2 Hz
%                      378.6 379.1 380.1 380.6 1  30  1;      % 379.6 Hz
%                      419.7 420.2 421.2 421.7 1  30  1;      % 420.7 Hz
%                      458.3 458.8 459.8 460.3 1  30  1;      % 459.3 Hz
%                      
%                      178.6 179.1 180.1 180.6 1  30  1;      % 179.6 Hz
%                      308.2 308.7 309.7 310.2 1  30  1;      % 309.2 Hz
%                      337.6 338.1 339.1 339.6 1  30  1;      % 338.6 Hz
%                      
%                      137.5 138   139   139.5 1  30  1;      % 138.5 Hz
%                      237.5 238   239   239.5 1  30  1;      % 238.5 Hz
%                      
%                      219.6 220.1 221.1 221.6 1  30  1;      % 220.6 Hz
%                      319.6 320.1 321.1 321.6 1  30  1;      % 320.6 Hz
%                      
%                      258.1 258.6 259.6 260.1 1  30  1;      % 259.1 Hz
%                      358.1 358.6 359.6 360.1 1  30  1;      % 359.1 Hz
%                      
%                      301.7 302.2 303.2 303.7 1  30  1;      % 302.7 Hz
%                      401.7 402.2 403.2 403.7 1  30  1;      % 402.7 Hz
%                      
%                      181.1 181.6 182.6 183.1 1  30  1;      % 182.1 Hz
%                      281.2 281.7 282.7 283.2 1  30  1;      % 282.2 Hz
%                      381.2 381.7 382.7 383.7 1  30  1;      % 382.2 Hz
%                      
%                      140.1 140.6 141.6 142.1 1  30  1;      % 141.1 Hz
%                      340.1 340.6 341.6 342.1 1  30  1;      % 341.1 Hz
%                      440.2 440.7 441.7 442.2 1  30  1];     % 441.2 Hz
                % Column 1 through 7:
                % Fpass1, Fstop1, Fstop2, Fpass2(Hz), Apass1, Astop, Apass2(dB)
                % Cut-off frequency of Band-Stop filters which eliminate
                % Megnetic transmitter and its harmonic noises from EMG

BS_MO           =   [8.23  8.53  9.13  9.43  1  30  1;      %  8.83 Hz
                     11.05 11.35 11.95 12.25 1  30  1;      % 11.65 Hz
                     19.85 20.15 20.75 21.05 1  30  1];     % 20.45 Hz
                % Column 1 through 7:
                % Fpass1, Fstop1, Fstop2, Fpass2(Hz), Apass1, Astop, Apass2(dB)
                % Cut-off frequency of Band-Stop filters which eliminate
                % noises from Motion

LP_WF           =   20;         % Hz
                % Cut-off frequency of Low-Pass filter which extract 
                % Low-Frequency Waveform (Signiture pattern of EMG)

N_fft           =   2^20;
                % Points of frequency spectra

Filter_Coef     =   FilterDesign;
                % Store all filter coefficients in 'Filter_Coef'



% denoise EMG
Data.PC_dn          =   Filter_BP_MA(Filter_BS_MT(Filter_BS_PF(Data.PC)));
Data.DP_dn          =   Filter_BP_MA(Filter_BS_MT(Filter_BS_PF(Data.Posteriordeltoid)));
Data.Biceps_dn      =   Filter_BP_MA(Filter_BS_MT(Filter_BS_PF(Data.Biceps)));
Data.Tlt_dn         =   Filter_BP_MA(Filter_BS_MT(Filter_BS_PF(Data.Triceps_lateral)));
Data.Tlh_dn         =   Filter_BP_MA(Filter_BS_MT(Filter_BS_PF(Data.Triceps_long)));

% rectify EMG
Data.PC_r           =   abs(Data.PC_dn);
Data.DP_r           =   abs(Data.DP_dn);
Data.Biceps_r       =   abs(Data.Biceps_dn);
Data.Tlt_r          =   abs(Data.Tlt_dn);
Data.Tlh_r          =   abs(Data.Tlh_dn);

% low_pass EMG
Data.PC_p           =   Filter_LP_WF(Data.PC_r);
Data.DP_p           =   Filter_LP_WF(Data.DP_r);
Data.Biceps_p       =   Filter_LP_WF(Data.Biceps_r);
Data.Tlt_p          =   Filter_LP_WF(Data.Tlt_r);
Data.Tlh_p          =   Filter_LP_WF(Data.Tlh_r);
end