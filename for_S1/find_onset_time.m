%%
clear all;
clc;
close all;

fs = 2410;
Dir = [pwd '\S1E2_for_onset_time'];
ExpList = GetExpList(Dir);
N = length(ExpList);
%% plot separately
% for i = 1:N
%     filename = [Dir '\' ExpList{i}];
%     data = importdata(filename);
%     figure(i);
%     plot(data.Frame/fs,data.LeftShoulderFlex);
%     title('Left Shoulder Flexion')
%     xlabel('Time/s')
%     ylabel('Angle/deg')
%     saveas(gcf,[ExpList{i}(1:end-4) '.jpg']);
% end
%% find onset time
for i = 1:1
    filename = [Dir '\' ExpList{i}];
    data = importdata(filename);
    onset = findOnset(data);
%      figure(i);
%     plot(data.LeftShoulderFlex);
%     title('Left Shoulder Flexion')
%     xlabel('Time/s')
%     ylabel('Angle/deg')
%     saveas(gcf,[ExpList{i}(1:end-4) '.jpg']);
end
%%
% close all;
% clear all;
% clc;