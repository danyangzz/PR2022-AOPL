close all;
clear all;
addpath('funs')
load('german_uni.mat');
X = double(X);
nor = 2; %1: zsocres 2: mapstd ÖÐÐÄ»¯ 
nearest = 5;
itermax = 5;

%% initial
[num, dim] = size(X);
num1 = length(Y);
if num1 ~=num
    X = X';
    num = num1;
    dim = num;
end    
c = length(unique(Y));

%% -----------------------------¡¾Campared Models¡¿---------------------------
    knn = nearest;
    All_result = [];
    All_result_ln=[];
    our_val = cell(1,5);
    our_val_ln = cell(1,5);
    weight = cell(1,5);
    weight_ln = cell(1,5);
    for order = 5
        S_result = zeros(5,3);
        S_result_ln=zeros(5,3);
        W = constructW_PKN(X', knn, 1); % issymmetric: set W = (W+W')/2 if issymmetric=1
        A = cell(order);
        for itero=1:order
            A{itero}=W^itero;
        end
        for alpha_k = 3
            [Y_pre,S,w,alpha,vals] = Horder_CLR(A,c,order,knn,alpha_k);
            result = ClusteringMeasure(Y,Y_pre);
            S_result(alpha_k,:) = result; % 1*3 Acc Nmi Purity
            our_val{alpha_k} = vals;
            weight{alpha_k} = w;
            [Y_pre,S,w,alpha,vals] = Horder_CLR(A,c,order,knn,alpha_k,1);
            result_ln = ClusteringMeasure(Y,Y_pre);
            S_result_ln(alpha_k,:)=result_ln;
            our_val_ln{alpha_k} = vals;
            weight_ln{alpha_k} = w;
        end
        All_result = [All_result,S_result];
        All_result_ln=[All_result_ln,S_result_ln];
    end
Result_CLR_our = All_result; 
Result_CLR_our_ln = All_result_ln;

% 
% save 'result/me_german_uni.mat' Result_CLR_our Result_CLR_our_ln