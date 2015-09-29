%%

%%

function Plot_Synergy(Synergy, VAF, Task, N_ch)

EMGColor        =   [   0.08	0.17	0.55;   % dark blue
                        0       0.4     0;      % dark green
                        0.6     0.2     0;      % dark red
                        0.04	0.52	0.78;   % dark cyan
                        0.75	0       0.75;	% dark magenta
                        0.68	0.47	0];     % dark yellow

SynColor        =   [   0.08	0.07	0.95;   % blue
                        0       0.8     0;      % green
                        0.9     0.1     0;      % red
                        0.04	0.82	0.88;   % cyan
                        0.95	0       0.95;	% magenta
                        0.78	0.77	0];     % yellow

c_grey = [0.7 0.7 0.7];
Ch_name = { 'PC' 'DP' 'Biceps' 'Tlt' 'Tlh'};
Fig_Name = [pwd '\Results\S2\' Task];


%% plot different numbers of synergy patterns

hfig1 = figure;
set(gcf,'Position', get(0,'ScreenSize')),

for j = 1:N_ch
    for k = 1:j
        subplot(N_ch,N_ch,j+(k-1)*N_ch)
        hold on, area(Synergy{j}.H(k,:),'FaceColor',SynColor(k,:),'EdgeColor','w'),
    end
end

% plot VAF
subplot(2,3,4),
plot(VAF, 'b', 'Marker','s', 'LineWidth',3)
axis([1 N_ch+0.5 0 105])
box off

% save figure
set(gcf,'PaperPositionMode','auto');
print(hfig1, '-dpng', [Fig_Name '_Synergy_No']);
close(hfig1)


%% plot decomposition of 2 synergy patterns vs. averaged EMG pattern
% 
% [R, C] = size(Synergy{2}.EMG);
% N_trial = R/N_ch;
% Weight = zeros(N_ch,2);
% Primitive = Synergy{2}.H;
% EMG = zeros(N_ch, C);
% EMG_D = zeros(N_ch, C);
% 
% for j = 1:N_ch
%     Weight(j,:) = mean( Synergy{2}.W(N_ch*((1:N_trial)-1)+j,:) );
%     EMG(j,:) = mean( Synergy{2}.EMG(N_ch*((1:N_trial)-1)+j,:) );
%     EMG_D(j,:) = mean( Synergy{2}.D(N_ch*((1:N_trial)-1)+j,:) );
% end
% 
% hfig2           =   figure;
% set(gcf,'Position', get(0,'ScreenSize')),
% 
% % plot weight
% subplot(4,4,5)
% barh(flipud(Weight(:,1)),'FaceColor',SynColor(1,:),'EdgeColor','w'),
% axis([0 1.2*max(Weight(:,1)) 0.5 N_ch+0.5]),
% set(gca,'YTick',1:N_ch,'YTickLabel',fliplr(Ch_name)),
% box off,
% 
% subplot(4,4,9)
% barh(flipud(Weight(:,2)),'FaceColor',SynColor(2,:),'EdgeColor','w'),
% axis([0 1.2*max(Weight(:,1)) 0.5 N_ch+0.5]),
% set(gca,'YTick',1:N_ch,'YTickLabel',fliplr(Ch_name)),
% box off,
% 
% % plot synergy pattern
% subplot(4,3,5)
% area(Primitive(1,:),'FaceColor',SynColor(1,:),'EdgeColor','w'),
% box off,
% 
% subplot(4,3,8)
% area(Primitive(2,:),'FaceColor',SynColor(2,:),'EdgeColor','w'),
% box off,
% 
% % plot averaged EMG
% for j = 1:N_ch
%     subplot(N_ch,3,3*j)
%     hold on, plot([0 0],[0 0], 'Color',EMGColor(j,:),'LineWidth',2)
%     hold on, plot([0 0],[0 0], 'Color',c_grey,'LineWidth',1)
%     hold on, area(Weight(j,2)*Primitive(2,:),'FaceColor',SynColor(2,:),'EdgeColor','w')
%     hold on, area(Weight(j,1)*Primitive(1,:),'FaceColor',SynColor(1,:),'EdgeColor','w')
%     hold on, plot(EMG_D(j,:), 'Color',EMGColor(j,:),'LineWidth',2)
%     hold on, plot(EMG(j,:), 'Color', c_grey,'LineWidth',1)
%     legend1 = [Ch_name(j) ' Reconstruct'];
%     legend2 = [Ch_name(j) ' Original'];
%     legend( legend1, legend2 )
%     set(legend,'Box','off'),
% end
% 
% set(gcf,'PaperPositionMode','auto');
% print(hfig2,'-dpng',[Fig_Name '_Synergy_Pattern']);
% close(hfig2);
%% plot decomposition of 3 synergy patterns vs. averaged EMG pattern

[R, C] = size(Synergy{3}.EMG);
N_trial = R/N_ch;
Weight = zeros(N_ch,3);
Primitive = Synergy{3}.H;
EMG = zeros(N_ch, C);
EMG_D = zeros(N_ch, C);

if N_trial == 1
    Weight = Synergy{3}.W;
    EMG = Synergy{3}.EMG;
    EMG_D = Synergy{3}.D;
else
    for j = 1:N_ch
        Weight(j,:) = mean( Synergy{3}.W(N_ch*((1:N_trial)-1)+j,:) );
        EMG(j,:) = mean( Synergy{3}.EMG(N_ch*((1:N_trial)-1)+j,:) );
        EMG_D(j,:) = mean( Synergy{3}.D(N_ch*((1:N_trial)-1)+j,:) );
    end
end

hfig2           =   figure;
set(gcf,'Position', get(0,'ScreenSize')),

% plot weight
subplot(5,4,5)
barh(flipud(Weight(:,1)),'FaceColor',SynColor(1,:),'EdgeColor','w'),
axis([0 1.2*max(Weight(:,1)) 0.5 N_ch+0.5]),
set(gca,'YTick',1:N_ch,'YTickLabel',fliplr(Ch_name)),
box off,

subplot(5,4,9)
barh(flipud(Weight(:,2)),'FaceColor',SynColor(2,:),'EdgeColor','w'),
axis([0 1.2*max(Weight(:,1)) 0.5 N_ch+0.5]),
set(gca,'YTick',1:N_ch,'YTickLabel',fliplr(Ch_name)),
box off,

subplot(5,4,13)
barh(flipud(Weight(:,3)),'FaceColor',SynColor(3,:),'EdgeColor','w'),
axis([0 1.2*max(Weight(:,1)) 0.5 N_ch+0.5]),
set(gca,'YTick',1:N_ch,'YTickLabel',fliplr(Ch_name)),
box off,

% plot synergy pattern
subplot(5,3,5)
area(Primitive(1,:),'FaceColor',SynColor(1,:),'EdgeColor','w'),
box off,

subplot(5,3,8)
area(Primitive(2,:),'FaceColor',SynColor(2,:),'EdgeColor','w'),
box off,

subplot(5,3,11)
area(Primitive(3,:),'FaceColor',SynColor(3,:),'EdgeColor','w'),
box off,

% plot averaged EMG
for j = 1:N_ch
    subplot(N_ch,3,3*j)
    hold on, plot([0 0],[0 0], 'Color',EMGColor(j,:),'LineWidth',2)
    hold on, plot([0 0],[0 0], 'Color',c_grey,'LineWidth',1)
    hold on, area(Weight(j,3)*Primitive(3,:),'FaceColor',SynColor(3,:),'EdgeColor','w')
    hold on, area(Weight(j,2)*Primitive(2,:),'FaceColor',SynColor(2,:),'EdgeColor','w')
    hold on, area(Weight(j,1)*Primitive(1,:),'FaceColor',SynColor(1,:),'EdgeColor','w')
    hold on, plot(EMG_D(j,:), 'Color',EMGColor(j,:),'LineWidth',2)
    hold on, plot(EMG(j,:), 'Color', c_grey,'LineWidth',1)
    legend1 = [Ch_name(j) ' Reconstruct'];
    legend2 = [Ch_name(j) ' Original'];
    legend( legend1, legend2 )
    set(legend,'Box','off'),
end

set(gcf,'PaperPositionMode','auto');
print(hfig2,'-dpng',[Fig_Name '_Synergy_Pattern']);
close(hfig2);


end

