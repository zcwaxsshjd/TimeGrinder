function Onset = findOnset(data)
LSF = data.LeftShoulderFlex;
temp = LSF(1:800);
mean_temp = mean(temp);
std_temp = std(temp);
mov = find(LSF <= mean_temp-5*std_temp);
Onset = mov(1);
end