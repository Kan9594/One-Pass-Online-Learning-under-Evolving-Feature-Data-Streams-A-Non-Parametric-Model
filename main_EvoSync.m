clear all
close all
addpath(genpath('.'));

options.sigma  = 0.2;
options.rho   = 0.1;
options.lambda   = 0.999;
DataDir = dir('.\data_E\');
ShotNumMax = 5;
IterMax = 20;

%% Run 
for ShotNum =2:ShotNumMax
    for F = 1:length(DataDir)-2
        File = DataDir(2+F).name;
        for iter = 1:IterMax
            disp(['Shot Number:' num2str(ShotNum) '/' num2str(ShotNumMax),...
                '.---File:' File '.---Iter:' num2str(iter) '/' num2str(IterMax)])
            %% load data
            load(File);
            data = NormalizeData(data,2);
            data = NormalizeData(data,1);
            PhaseNum = ShotNum; RepeatNum = 1;
            [data,labels,PhaseId] = GenerateEvoData(data,labels,PhaseNum,RepeatNum);
            [n,~]       = size(data);
            options.t_tick = floor(linspace(1,n,51));
            options.t_tick(1) = [];
            ID = 1:length(labels);
            
            %% Run
            tic;
            options.eta    = 1;
            [classifier, Err_count, Predict, Loss, Mistakes, Margin] = rhoJKOGD(labels,data,options,ID);
            Result_Time.KOGD(F,iter) = toc;
            Result_Acc.KOGD(F,iter) = sum(labels==Predict')/n;
        end
    end
end

