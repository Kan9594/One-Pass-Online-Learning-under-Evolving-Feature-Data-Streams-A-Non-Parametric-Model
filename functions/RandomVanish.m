function X = RandomVanish(X)



[num_instances, num_features] = size(X);
start_instance = floor(num_instances * 0.25);
end_instance = floor(num_instances * 0.75);

MissID = linspace(start_instance,end_instance,num_features);
MissID = floor(MissID);

for i = 1:num_features
    X(MissID(i):end,i) = NaN;
end
