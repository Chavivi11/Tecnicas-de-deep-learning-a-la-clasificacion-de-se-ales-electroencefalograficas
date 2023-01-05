function [tasaAcierto,tasaFallo] = clasificadorDatos(datosEntrenamiento, datosClasificar, etiqueta)

numAciertos = 0;
numFallos = 0;

layers = [
    sequenceInputLayer(length(datosEntrenamiento)-1,"Name","sequence")
    convolution1dLayer(7,32,"Name","conv1d","Padding","same")
    reluLayer("Name","relu1")
    layerNormalizationLayer("Name","layernorm")
    maxPooling1dLayer(5,"Name","maxpool1d","Padding","same")
    convolution1dLayer(7,32,"Name","conv1d_1","Padding","same")
    reluLayer("Name","relu2")
    layerNormalizationLayer("Name","layernorm_2")
    maxPooling1dLayer(5,"Name","maxpool1d_2","Padding","same")
    convolution1dLayer(7,32,"Name","conv1d_2","Padding","same")
    reluLayer("Name","relu3")
    convolution1dLayer(7,32,"Name","conv1d_3","Padding","same")
    reluLayer("Name","relu4")
    convolution1dLayer(5,32,"Name","conv1d_4","Padding","same")
    reluLayer("Name","relu5")
    maxPooling1dLayer(7,"Name","maxpool1d_3","Padding","same")
    fullyConnectedLayer(4000,"Name","fc6","BiasLearnRateFactor",60)
    reluLayer("Name","relu6")
    dropoutLayer(0.7,"Name","drop6")
    fullyConnectedLayer(4000,"Name","fc7","BiasLearnRateFactor",65)
    reluLayer("Name","relu7")
    dropoutLayer(0.15,"Name","drop7")
    fullyConnectedLayer(3,"Name","fc8","BiasLearnRateFactor",65)
    softmaxLayer("Name","prob")
    classificationLayer("Name","output")];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',30, ...
    'MaxEpochs',25, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','never', ...
    'Verbose',false, ...
    'Plots','none');

netTransfer = trainNetwork(datosEntrenamiento(1:end-1,:),categorical(datosEntrenamiento(end,:)),layers,options);

class = classify(netTransfer, datosClasificar(1:end-1, 20:end));

for j=1:length(class)
    if(class(j) == categorical(etiqueta))
        numAciertos = numAciertos + 1;
    else
        numFallos = numFallos + 1;
    end
end

tasaAcierto = round((numAciertos/(numAciertos + numFallos)) * 100, 2);
tasaFallo = round((numFallos/(numAciertos + numFallos)) * 100, 2);

end

