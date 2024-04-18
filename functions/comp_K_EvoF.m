function [KernelValue] = comp_K_EvoF(X, sigma, id, SVset)
%compute kernels
%X---------the feature values of all instances
%options---the parameter settings, gaussian kernel width
   Fea_id = ~isnan(X(id,:));
   gid = sum(X(id,Fea_id).*X(id,Fea_id),2);
   KernelValue = [];
   for i = 1:length(SVset) 
       if ~isempty(SVset{i})
           X_SV = X(SVset{i},Fea_id);
           X_SV(isnan(X_SV)) = 0;
%            Fea_SV = ~isnan(X(SVset{i}(1),:));
%            Fea_common = logical(Fea_id.*Fea_SV);
           gsv = sum(X_SV.*X_SV,2);
           gidsv = X(id,Fea_id)*X_SV';
           k{i} = exp(-(repmat(gid',length(SVset{i}),1) + repmat(gsv,1,length(id)) - 2*gidsv')/(2*sigma^2));
       end
   end
   for i = 1:length(k)
       KernelValue = [KernelValue;k{i}];
   end
end

