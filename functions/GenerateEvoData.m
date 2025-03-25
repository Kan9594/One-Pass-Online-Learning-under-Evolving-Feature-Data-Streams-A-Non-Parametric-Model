function [data,labels,PhaseId]= GenerateEvoData(X,Y,PhaseNum, RepeatNum)

%% load data
[n,d]       = size(X);
Id = randperm(n);
Y = Y(Id);
X = X(Id,:);

%% Generate features

X = [rand(n,floor(0.5*d)),X];
X = NormalizeData(X,2);
X = NormalizeData(X,1);
RandFeaNum = floor(0.5*d);

if RandFeaNum<PhaseNum
    RandFeaNum = PhaseNum;
end
PhaseId = floor(linspace(1,n,PhaseNum + 1));
PhaseFeaRandId = floor(linspace(1,RandFeaNum,PhaseNum));
PhaseFeaOrigId = floor(linspace(1,RandFeaNum,PhaseNum + 1));

for i = 2:PhaseNum
    X(PhaseId(i-1):PhaseId(i),RandFeaNum+PhaseFeaOrigId(i):end) = NaN;
end

for i = 1:PhaseNum-1
    X(PhaseId(i+1)+1:PhaseId(i+2),1:PhaseFeaRandId(i+1)) = NaN;
end

for i = 1:PhaseNum
    if i==1
        X_temp  = X(PhaseId(i):PhaseId(i+1),:);
        Y_temp  = Y(PhaseId(i):PhaseId(i+1));
        Data_temp{i} = repmat(X_temp,RepeatNum,1);
        Label_temp{i}= repmat(Y_temp,RepeatNum,1);
    else
        X_temp  = X(PhaseId(i)+1:PhaseId(i+1),:);
        Y_temp  = Y(PhaseId(i)+1:PhaseId(i+1));
        Data_temp{i} = repmat(X_temp,1,1);
        Label_temp{i}= repmat(Y_temp,1,1);
    end
end

data = [];labels = [];
for i = 1:PhaseNum
    Id = randperm(size(Data_temp{i},1));
    data = [data;Data_temp{i}(Id,:)];
    labels = [labels;Label_temp{i}(Id)];
end

