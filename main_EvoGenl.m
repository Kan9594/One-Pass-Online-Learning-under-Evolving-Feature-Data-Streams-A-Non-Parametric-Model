clear all
close all
addpath(genpath('.'));

fid = dir('.\data_E\');
options.eta    = 1;
options.sigma  = 0.2;
options.rho   = 0.1;
options.lambda   = 0.999;
IterMax = 20;
ShotNum = 2;

for F = 1:length(fid)-2
    for iter = 1:IterMax
        load(fid(2+F).name);
        disp(['Shot Number:' num2str(ShotNum),...
            '.---File:' fid(2+F).name '[' num2str(F) '/' num2str(length(fid)-2) ']', ...
            '.---Iter:' num2str(iter) '/' num2str(IterMax)])
        data = NormalizeData(data,2);
        data = NormalizeData(data,1);
        [data,labels,PhaseId] = GenerateGenlEvoData(data,labels,ShotNum);
        [n,~]       = size(data);
        options.t_tick = floor(linspace(1,size(data,1),51));
        options.t_tick(1) = [];
        ID = 1:length(labels);
        
        tic;
        options.eta    = 1;
        [classifier, Err_count, Predict,~, Mistakes] = rhoJKOGD(labels,data,options,ID);
        Result_Time.KOGD(F,iter) = toc;
        Result_Acc.KOGD(F,iter) = sum(labels==Predict')/n;
    end
end
    




