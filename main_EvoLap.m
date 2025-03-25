clear all
close all
addpath(genpath('.'));

fid = dir('.\data_E\');
options.sigma  = 0.2;
options.rho   = 0.1;
options.lambda   = 0.999;
IterMax = 20;
B = 100;

for F = 1:length(fid)-2
    for iter = 1:IterMax
        load(fid(2+F).name);
        if sum(labels==-1)<sum(labels==1)
            labels(labels==-1) = 2;
            labels(labels==1) = -1;
            labels(labels==2) = 1;
        end
        disp(['---File:' fid(2+F).name '.---Iter:' num2str(iter) '/' num2str(IterMax)])
        [data,labels] = GenerateEvoLapData(data,labels,B);
        
        options.t_tick = floor(linspace(1,size(data,1),51));
        options.t_tick(1) = [];
        ID = 1:length(labels);
        
        
        tic;
        options.eta    = 1;
        [classifier, Err_count, Predict] = rhoJKOGD(labels,data,options,ID);
        Result_Time.KOGD(F,iter) = toc;
        Result_Acc.KOGD(F,iter) = sum(labels==Predict')/length(labels);
    end
end



