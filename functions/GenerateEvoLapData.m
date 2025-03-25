function [data,Y_all]= GenerateEvoLapData(X,Y,overlap)

%% load data
[n,d]       = size(X);
Id = randperm(n);
labels = Y(Id);
X = X(Id,:);

data = NormalizeData(X,1);
data = NormalizeData(X,2);

%% Generate features
EvoFeaNum = floor(1.5*d);

if EvoFeaNum>30
    EvoFeaNum = 30;
end

if EvoFeaNum<10
    EvoFeaNum = 10;
end

EvoX = X*rand(d,EvoFeaNum);
data = [X,EvoX];

data = NormalizeData(data,2);
data = NormalizeData(data,1);

if ~isnan(overlap)
    PhaseId = floor(linspace(1,n,4));
end

PhaseId(3) = PhaseId(2)+overlap;


X1 = data(PhaseId(1):PhaseId(2)+overlap,1:d);
X2 = data(PhaseId(2)+1:PhaseId(4),d+1:end);
Y1 = labels(PhaseId(1):PhaseId(2)+overlap);
Y2 = labels(PhaseId(2)+1:PhaseId(4));
Y_all = labels;



n = size(X1,1);
data_1 = [X1(1:n-overlap,:),nan(n-overlap,size(X2,2))];
data_2 = [X1(n-overlap+1:end,:),X2(1:overlap,:)];
data_3 = [nan(size(X2(overlap+1:end,:),1),size(X1,2)),X2(overlap+1:end,:)];
data = [data_1;data_2;data_3];

