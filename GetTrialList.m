%%

%%

function [TrialList,N_sub_exp] = GetTrialList(Subject,Dir)

global ExpList

TrialList = cell2struct(Subject,Subject);
N_sub = length(Subject);
N_exp = length(ExpList);
N_sub_exp = zeros(N_sub,1);

for i = 1:N_sub
    eval(['TrialList.' Subject{i} ' = struct();']);
    
    for j = 1:N_exp
        if ~isempty(strfind(ExpList{j},Subject{i}))
            N_sub_exp(i) = N_sub_exp(i) + 1;
            FileList = dir( fullfile([Dir '\' ExpList{j}],'*.exp') );
            ExpList{j,2} = length(FileList);
            eval(['TrialList.' Subject{i} '.' ExpList{j} '= FileList;']);
        end
    end
    
end

end

