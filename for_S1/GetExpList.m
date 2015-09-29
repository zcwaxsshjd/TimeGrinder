%%

%%

function ExpList = GetExpList(Dir)

FileList = dir(Dir);

N = length(FileList);
ExpList = cell(N-2,1);
j = 0;

for i = 1:N
    if length(FileList(i).name) > 10
        j = j+1;
        ExpList{j} = FileList(i).name;
    end
end

end

