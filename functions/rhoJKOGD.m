function [classifier, err_count, hat_y, loss,mistakes,margin] = rhoJKOGD(Y, X, options, id_list)
% multiple kernelized online gradient descent algorithm with feature
% evolving with the uncertain SV selection strategy.
%--------------------------------------------------------------------------

%% initialize parameters
t_tick = options.t_tick;
t_tick_t = 1;
eta = options.eta;
ID = id_list;
err_count = 0;
rho = options.rho;
lambda = options.lambda;

alpha = [];
SV = [];
mistakes = [];
mistakes_idx = [];
SVs = [];
TMs=[];
Fea.Current = ~isnan(X(1,:));
Fea.Last = ~isnan(X(1,:));
SetNum = 1;
SVset{1} = [];
Jac = [];
Flag = 0;

%X(isnan(X)) = 0;

%% loop
tic
for t = 1:length(ID)
    id = ID(t);
    
    %% Feature Evolution Detection
    Fea.Current = ~isnan(X(id,:));
    if ~isequal(Fea.Current,Fea.Last)
        SetNum = SetNum + 1;
        SVset{SetNum} = [];
        Fea.Last = Fea.Current;
        Flag = 1;
    end

    %% compute f_t(x_t)
    if (isempty(alpha))
        f_t=0;
    else
        k_t = comp_K_EvoF(X, options.sigma, id, SVset);
        f_t=alpha_for_t*k_t;
    end
    %% count the number of errors
    hat_y(t) = sign(f_t);
    if (hat_y(t)==0)
        hat_y(t)=1;
    end

    y_t=Y(id);
    if (hat_y(t)~=y_t)
        err_count = err_count + 1;
    end
    loss(t) = max(0,1-Y(id)*f_t);
    margin(t) = Y(id)*f_t;
    
    
    
    
    %% Updating
    if loss(t)>0%margin(t)<rho && margin(t)>-rho%margin(t)< 1%
        if Flag == 1
            Jac = mean(~isnan(X(SV,:)).*repmat(Fea.Current,length(SV),1),2);
            Jac = [Jac;1];
            Flag = 0;
        else
            Jac = [Jac;1];
        end
        alpha = [lambda*alpha eta*y_t];
        alpha_for_t = alpha.*Jac';
        SV = [SV id];
        SVset{SetNum} = [SVset{SetNum},id];
    end




    %% record performance
    if t==t_tick(t_tick_t)
        mistakes = [mistakes err_count/t];
        t_tick_t = t_tick_t + 1;
    end
    
    Delete_Id = find(abs(alpha_for_t)<0.01);
    alpha(Delete_Id) = [];
    alpha_for_t(Delete_Id) = [];
    Jac(Delete_Id) = [];
    for i = 1:SetNum
        for j = 1:length(Delete_Id)
            Index_temp = find(SVset{i} == SV(Delete_Id(j)));
            if ~isempty(Index_temp)
                SVset{i}(Index_temp) = [];
                %break;
            end
        end
    end
    SV(Delete_Id)    = [];
    
end

classifier.SV = SV;
classifier.alpha = alpha;
run_time = toc;