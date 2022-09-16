clc; close all; clear

muestra = importdata("UAH_BCI_database_description\A01_1.mat");

numClases = [];

for i = 1:length(muestra.clase)
    if(not(ismember(muestra.clase(i),numClases)))
        numClases = [numClases muestra.clase(i)];
    end
end

Freq = (real(fft(muestra.canal) / 1e-3))

trainingData = find(Freq>12 & Freq<33)

numClasses = numel(numClases);
net = alexnet;
layersTransfer = net.Layers(1:end-3);

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(muestra.muestra,layers,options);