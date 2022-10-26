clc; close all; clear
% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

directorio = 'Physionet_Database\Muestras\';
separador = '\';
extension = '.edf';


for sesion=1:14
    if(sesion<10)
        record = 'R0';
    else
        record = 'R';
    end

    filename = strcat(directorio,'S','001',separador,'S','001',record,string(sesion),extension);
    [data, anotaciones] = edfread(filename);
    
    switch sesion
        case 3
            sesion3 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS3, manoIzquierdaS3] = obtenerMDerecha_MIzquierda(sesion3);
        case 4
            sesion4 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS4, manoIzquierdaS4] = obtenerMDerecha_MIzquierda(sesion4);
        case 5
            sesion5 = obtenerDatosPies(data, anotaciones);
            pies5 = datosPies(sesion5);
        case 6
            sesion6 = obtenerDatosPies(data, anotaciones);
            pies6 = datosPies(sesion6);
        case 7
            sesion7 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS7, manoIzquierdaS7] = obtenerMDerecha_MIzquierda(sesion7);
        case 8
            sesion8 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS8, manoIzquierdaS8] = obtenerMDerecha_MIzquierda(sesion8);
        case 9
            sesion9 = obtenerDatosPies(data, anotaciones);
            pies9 = datosPies(sesion9);
        case 10
            sesion10 = obtenerDatosPies(data, anotaciones);
            pies10 = datosPies(sesion10);
        case 11
            sesion11 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS11, manoIzquierdaS11] = obtenerMDerecha_MIzquierda(sesion11);
        case 12
            sesion12 = obtenerDatosEntrenamiento(data, anotaciones);
            [manoDerechaS12, manoIzquierdaS12] = obtenerMDerecha_MIzquierda(sesion12);
        case 13
            sesion13 = obtenerDatosPies(data, anotaciones);
            pies13 = datosPies(sesion13);
        case 14
            sesion14 = obtenerDatosPies(data, anotaciones);
            pies14 = datosPies(sesion14);
    end
end

pacienteManoDerecha = [manoDerechaS3 manoDerechaS4 manoDerechaS7 manoDerechaS8 manoDerechaS11 manoDerechaS12];
pacienteManoIzquierda = [manoIzquierdaS3 manoIzquierdaS4 manoIzquierdaS7 manoIzquierdaS8 manoIzquierdaS11 manoIzquierdaS12];
pacientePies = [pies5 pies6 pies9 pies10 pies13 pies14];


datosEntrenamiento = datosEntrenamienoRed(pacienteManoDerecha, pacienteManoIzquierda, pacientePies);

etiquetaPies = 0;
etiquetaManoIzquierda = 1;
etiquetaManoDerecha = 2;

numAciertos = 0;
numFallos = 0;


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
    fullyConnectedLayer(4096,"Name","fc6","BiasLearnRateFactor",5)
    reluLayer("Name","relu6")
    dropoutLayer(0.2,"Name","drop6")
    fullyConnectedLayer(4096,"Name","fc7","BiasLearnRateFactor",5)
    reluLayer("Name","relu7")
    dropoutLayer(0.2,"Name","drop7")
    fullyConnectedLayer(3,"Name","fc8","BiasLearnRateFactor",5)
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

for i=1:10
    class = classify(netTransfer, pacienteManoIzquierda(1:end-1, 20:end));
    for j=1:length(class)
        if(double(class(j)) == etiquetaManoIzquierda)
            numAciertos = numAciertos + 1;
        else
            numFallos = numFallos + 1;
        end
    end
end

tasaAcierto = (numAciertos/(numAciertos + numFallos)) * 100;
tasaFallo = (numFallos/(numAciertos + numFallos)) * 100;



% figure
% confusionchart(categorical(pacienteManoDerecha(end,20:end)),class)
    