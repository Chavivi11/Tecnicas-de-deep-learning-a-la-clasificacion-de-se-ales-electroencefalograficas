clc; close all; clear

muestra = importdata("UAH_BCI_database_description\A01_1.mat");

numClases = [];
trainingData = [];

for i = 1:length(muestra.clase)
    if(not(ismember(muestra.clase(i),numClases)))
        numClases = [numClases muestra.clase(i)];
    end
end

Freq = (real(fft(muestra.canal) / 1e-3));

for j = 1:length(Freq)
    if(Freq(j)>12 & Freq(j)<33)
        trainingData = [trainingData Freq(j)];
    end
end


numDiffClasses = numel(numClases);

net = alexnet;

layers = [
    featureInputLayer(40,"Name","featureinput")
    convolution1dLayer(3,32,"Name","conv1d_5","Padding","same")
    reluLayer("Name","relu1")
    crossChannelNormalizationLayer(5,"Name","norm1","K",1)
    maxPooling1dLayer(5,"Name","maxpool1d_3","Padding","same")
    convolution1dLayer(3,32,"Name","conv1d_1","Padding","same")
    reluLayer("Name","relu2")
    crossChannelNormalizationLayer(5,"Name","norm2","K",1)
    maxPooling1dLayer(5,"Name","maxpool1d_1","Padding","same")
    convolution1dLayer(3,32,"Name","conv1d_2","Padding","same")
    reluLayer("Name","relu3")
    convolution1dLayer(3,32,"Name","conv1d_3","Padding","same")
    reluLayer("Name","relu4")
    convolution1dLayer(3,32,"Name","conv1d_4","Padding","same")
    reluLayer("Name","relu5")
    maxPooling1dLayer(5,"Name","maxpool1d_2","Padding","same")
    fullyConnectedLayer(4096,"Name","fc6","BiasLearnRateFactor",2)
    reluLayer("Name","relu6")
    dropoutLayer(0.5,"Name","drop6")
    fullyConnectedLayer(4096,"Name","fc7","BiasLearnRateFactor",2)
    reluLayer("Name","relu7")
    dropoutLayer(0.5,"Name","drop7")
    fullyConnectedLayer(1000,"Name","fc8","BiasLearnRateFactor",2)
    softmaxLayer("Name","prob")
    classificationLayer("Name","output")];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(trainingData,layers,options);