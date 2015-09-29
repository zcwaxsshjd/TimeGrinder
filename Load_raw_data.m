%% Function 'Load_raw_data'
%
%	Load raw data of one trial into workspace from '*.exp' file in 
%   directory 'DIR'.
%
%   Format:
%		Data = Load_raw_data(DIR);
%
%   Example:
%       Data = Load_raw_data('Exp1\T1_t1.exp');
%
%%

function Data = Load_raw_data(DIR)

fs                  =   2410;                       % sampling rate in Hz

%% Import '.exp' file

Data_Temp           =   importdata(DIR);


%% Define Channels

% Time
Data.N              =   Data_Temp.data(:,1);
Data.Time           =   Data.N/fs;

% Orthopedic Angles
Data.Sh_F           =   Data_Temp.data(:,2);        % Shoulder Flexion
Data.El_F           =   Data_Temp.data(:,5);        % Elbow Flexion

% Landmark Trajectories
Data.Acro_X         =   Data_Temp.data(:,6);        % Acromion
Data.Acro_Y         =   Data_Temp.data(:,7);

Data.Elbow_X        =   Data_Temp.data(:,8);       % Elbow
Data.Elbow_Y        =   Data_Temp.data(:,9);

Data.Point_X        =   Data_Temp.data(:,10);        % Hand
Data.Point_Y        =   Data_Temp.data(:,11);

% 6 Channels of EMG 
Data.EMG_Ch1                =   Data_Temp.data(:,13); %anteri
Data.EMG_Ch2                =   Data_Temp.data(:,14); %pos
Data.EMG_Ch3                =   Data_Temp.data(:,15); %bi
Data.EMG_Ch4                =   Data_Temp.data(:,16); %tri
% Data.EMG_Ch5                =   Data_Temp.data(:,16);
% Data.EMG_Ch6                =   Data_Temp.data(:,17);

% Trigger Signal
Data.Trigger        =   Data_Temp.data(:,12);

% Other information
Data.TrialName      =   DIR;
Data.colheaders     =   Data_Temp.colheaders;


end

