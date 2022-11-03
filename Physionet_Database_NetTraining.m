clc; close all; clear
% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

directorio = 'Physionet_Database\Muestras\';
separador = '\';
extension = '.edf';

etiquetaPies = 0;
etiquetaManoIzquierda = 1;
etiquetaManoDerecha = 2;

f = 1;
iter = 1;
i = 1;
datosSujetos = zeros(13,7);
sujetosCandidatos = zeros(1,12);

% Obtenemos 12 pacientes aleatorios y sin repetición de los 109 sujetos 
while i~=13
    pacienteRandom = randi([1,109], 1,1);
    if(~ismember(pacienteRandom, sujetosCandidatos))
        sujetosCandidatos(:,iter) = pacienteRandom;
        iter = iter + 1;
        i = i +1;
    end
end

    

for sujetos=1:length(sujetosCandidatos)

    for sesion=1:14
        
        if(sesion<10)
            record = 'R0';
        else
            record = 'R';
        end

        if(sujetosCandidatos(sujetos) < 10)
            paciente = strcat('00', string(sujetosCandidatos(sujetos)));
        elseif(9 < sujetosCandidatos(sujetos)) && (sujetosCandidatos(sujetos) < 100)
            paciente = strcat('0', string(sujetosCandidatos(sujetos)));
        else
            paciente = string(sujetosCandidatos(sujetos));
        end

        filename = strcat(directorio,'S',paciente,separador,'S',paciente,record,string(sesion),extension);
        
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
    
    layers = [
        sequenceInputLayer(length(datosEntrenamiento)-1,"Name","sequence")
        convolution1dLayer(3,32,"Name","conv1d","Padding","same")
        reluLayer("Name","relu1")
        layerNormalizationLayer("Name","layernorm")
        maxPooling1dLayer(5,"Name","maxpool1d","Padding","same")
        convolution1dLayer(3,32,"Name","conv1d_1","Padding","same")
        reluLayer("Name","relu2")
        layerNormalizationLayer("Name","layernorm_2")
        maxPooling1dLayer(5,"Name","maxpool1d_2","Padding","same")
        convolution1dLayer(3,32,"Name","conv1d_2","Padding","same")
        reluLayer("Name","relu3")
        convolution1dLayer(3,32,"Name","conv1d_3","Padding","same")
        reluLayer("Name","relu4")
        convolution1dLayer(5,32,"Name","conv1d_4","Padding","same")
        reluLayer("Name","relu5")
        maxPooling1dLayer(5,"Name","maxpool1d_3","Padding","same")
        fullyConnectedLayer(4000,"Name","fc6","BiasLearnRateFactor",10)
        reluLayer("Name","relu6")
        dropoutLayer(0.1,"Name","drop6")
        fullyConnectedLayer(4000,"Name","fc7","BiasLearnRateFactor",10)
        reluLayer("Name","relu7")
        dropoutLayer(0.1,"Name","drop7")
        fullyConnectedLayer(3,"Name","fc8","BiasLearnRateFactor",10)
        softmaxLayer("Name","prob")
        classificationLayer("Name","output")];
    
    options = trainingOptions('sgdm', ...
        'MiniBatchSize',10, ...
        'MaxEpochs',12, ...
        'InitialLearnRate',1e-4, ...
        'Shuffle','every-epoch', ...
        'ValidationFrequency',3, ...
        'Verbose',false, ...
        'Plots','none');
    
    netTransfer = trainNetwork(datosEntrenamiento(1:end-1,:),categorical(datosEntrenamiento(end,:)),layers,options);
    
    [tasaAcietoMD, tasaFalloMD] = clasificadorDatos(netTransfer, pacienteManoDerecha, etiquetaManoDerecha);
    [tasaAcietoMI, tasaFalloMI] = clasificadorDatos(netTransfer, pacienteManoIzquierda, etiquetaManoIzquierda);
    [tasaAcietoPies, tasaFalloPies] = clasificadorDatos(netTransfer, pacientePies, etiquetaPies);
  
        
    datosSujetos(f,:) = [sujetos tasaAcietoMD tasaFalloMD tasaAcietoMI tasaFalloMI tasaAcietoPies tasaFalloPies];
    f = f + 1;
end

datosSujetos(end, :) = [max(datosSujetos(:,1)) mean(datosSujetos(:,2)) mean(datosSujetos(:,3)) mean(datosSujetos(:,4)) mean(datosSujetos(:,5)) mean(datosSujetos(:,6)) mean(datosSujetos(:,7))];


    