function [data,labels,PhaseId]= GenerateGenlEvoData(X,Y,PhaseNum)

%% load data
[n,d]       = size(X);
Id = randperm(n);
Y = Y(Id);
X = X(Id,:);

%% Generate features
RandFeaNum = floor(0.5*d);

X_temp = [rand(n,RandFeaNum),X];
X_temp = NormalizeData(X_temp,2);
X_temp = NormalizeData(X_temp,1);

X_rand = X_temp(:,1:floor(0.5*d));
X =  X_temp(:,floor(0.5*d)+1:end);
X_rand = RandomVanish(X_rand);


if RandFeaNum<PhaseNum
    RandFeaNum = PhaseNum;
end
PhaseId = floor(linspace(1,n,PhaseNum + 1));
PhaseFeaOrigId = floor(linspace(1,d,PhaseNum + 1));

for i = 2:PhaseNum
    X(PhaseId(i-1):PhaseId(i),PhaseFeaOrigId(i):end) = NaN;
end


for i = 1:PhaseNum
    if i==1
        X_temp  = X(PhaseId(i):PhaseId(i+1),:);
        Y_temp  = Y(PhaseId(i):PhaseId(i+1));
        Data_temp{i} = X_temp;
        Label_temp{i}= Y_temp;
    else
        X_temp  = X(PhaseId(i)+1:PhaseId(i+1),:);
        Y_temp  = Y(PhaseId(i)+1:PhaseId(i+1));
        Data_temp{i} = X_temp;
        Label_temp{i}= Y_temp;
    end
end

data = [];labels = [];

for i = 1:PhaseNum
    Id = randperm(size(Data_temp{i},1));
    data = [data;Data_temp{i}(Id,:)];
    labels = [labels;Label_temp{i}(Id)];
end

data = [X_rand,data];
