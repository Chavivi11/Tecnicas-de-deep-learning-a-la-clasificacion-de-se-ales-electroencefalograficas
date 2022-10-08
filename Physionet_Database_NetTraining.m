clc; close all; clear
% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

directorio = 'Physionet_Database\Muestras\';
separador = '\';
extension = '.edf';


for sesion=1:12
    if(sesion<10)
        record = 'R0';
    else
        record = 'R';
    end

    filename = strcat(directorio,'S00','1',separador,'S00','1',record,string(sesion),extension);
    [data, anotaciones] = edfread(filename);
    
    switch sesion
        case 3
            sesion3 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS3, manoIzquierdaS3] = obtenerMDerecha_MIzquierda(sesion3);
        case 4
            sesion4 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS4, manoIzquierdaS4] = obtenerMDerecha_MIzquierda(sesion4);
        case 7
            sesion7 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS7, manoIzquierdaS7] = obtenerMDerecha_MIzquierda(sesion7);
        case 8
            sesion8 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS8, manoIzquierdaS8] = obtenerMDerecha_MIzquierda(sesion8);
        case 11
            sesion11 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS11, manoIzquierdaS11] = obtenerMDerecha_MIzquierda(sesion11);
        case 12
            sesion12 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS12, manoIzquierdaS12] = obtenerMDerecha_MIzquierda(sesion12);
    end
end

pacienteManoDerecha = [manoDerechaS3 manoDerechaS4 manoDerechaS7 manoDerechaS8 manoDerechaS11 manoDerechaS12];
pacienteManoIzquierda = [manoIzquierdaS3 manoIzquierdaS4 manoIzquierdaS7 manoIzquierdaS8 manoIzquierdaS11 manoIzquierdaS12];


datosEntrenamiento = [pacienteManoDerecha(:,1:2:20) pacienteManoIzquierda(:,1:2:20) pacienteManoDerecha(:,1:5:20) pacienteManoIzquierda(:,1:5:20)];


layers = [
    sequenceInputLayer(length(datosEntrenamiento)-1,"Name","sequence")
    convolution1dLayer(3,32,"Name","conv1d","Padding","same")
    reluLayer("Name","relu1")
    layerNormalizationLayer("Name","layernorm")
    maxPooling1dLayer(1,"Name","maxpool1d","Padding","same")
    convolution1dLayer(3,32,"Name","conv1d_1","Padding","same")
    reluLayer("Name","relu2")
    layerNormalizationLayer("Name","layernorm_2")
    maxPooling1dLayer(5,"Name","maxpool1d_2","Padding","same")
    convolution1dLayer(3,32,"Name","conv1d_2","Padding","same")
    reluLayer("Name","relu3")
    convolution1dLayer(3,32,"Name","conv1d_3","Padding","same")
    reluLayer("Name","relu4")
    convolution1dLayer(3,32,"Name","conv1d_4","Padding","same")
    reluLayer("Name","relu5")
    maxPooling1dLayer(5,"Name","maxpool1d_3","Padding","same")
    fullyConnectedLayer(4096,"Name","fc6","BiasLearnRateFactor",2)
    reluLayer("Name","relu6")
    dropoutLayer(0.5,"Name","drop6")
    fullyConnectedLayer(4096,"Name","fc7","BiasLearnRateFactor",2)
    reluLayer("Name","relu7")
    dropoutLayer(0.5,"Name","drop7")
    fullyConnectedLayer(2,"Name","fc8","BiasLearnRateFactor",2)
    softmaxLayer("Name","prob")
    classificationLayer("Name","output")];

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',10, ...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

netTransfer = trainNetwork(datosEntrenamiento(1:end-1,:),categorical(datosEntrenamiento(end,:)),layers,options);

class = classify(netTransfer, pacienteManoDerecha(1:end-1, 20:end));

figure
confusionchart(categorical(pacienteManoDerecha(end,20:end)),class)
    