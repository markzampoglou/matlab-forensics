% Stima dei parametri tramite algoritmo Expectation
% Maximization su Mixtured Gaussian Model

function [mu,sigma,mix_perc]=MoG_parameters_estimation_v2(statistica,MU,SIGMA)

% inizializzazione dei parametri

param.mu=[MU;0];                     % i parametri sono inizializzati 
param.Sigma=zeros(1,1,2);           % in base a verifiche empiriche
param.Sigma(:,:,1)=SIGMA;
param.Sigma(:,:,2)=SIGMA/2;
param.PComponents=[0.5;0.5];


options=statset('MaxIter',10000,'TolX', 1e-3);

data=log(statistica(not(isnan(statistica)|isinf(statistica)))); % gestione di eventuali Nan e Inf
data=data(not(isinf(data)|isnan(data)));                        % gestione di eventuali Nan e Inf

% algoritmo E/M per MG model di MatLab

MG_model=gmdistribution.fit(data,2,'Start',param,'Options',options);  
    
mu=MG_model.mu;

sigma=sqrt(MG_model.Sigma);

mix_perc=MG_model.PComponents;

