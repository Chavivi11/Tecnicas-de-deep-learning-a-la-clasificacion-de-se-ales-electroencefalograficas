clc; close all; clear
% Muestras sacadas de la base de datos de Physionet.
% Cargamos todos los sujetos y sus sesiones en un fichero

etiquetaPies = 0;
etiquetaManoIzquierda = 1;
etiquetaManoDerecha = 2;

tiradas = zeros(20, 8);
l = 1;
for k=1:20

    f = 1;
    iter = 1;
    c = 1;
    i = 1;
    j = 1;
    datosSujetos = zeros(13,7);
    sujetosCandidatos = zeros(1,12);
    sujetosCandidatosClasificacion = zeros(1,12);

    % Obtenemos 12 pacientes aleatorios y sin repetición de los 109 sujetos
    while i~=13
        pacienteRandom = randi([1,109], 1,1);
        if(~ismember(pacienteRandom, sujetosCandidatos))
            sujetosCandidatos(:,iter) = pacienteRandom;
            iter = iter + 1;
            i = i +1;
        end
    end

%     while j~=13
%         pacienteClasificacionRandom = randi([1,109], 1,1);
%         if((~ismember(pacienteClasificacionRandom, sujetosCandidatos)) && (~ismember(pacienteClasificacionRandom, sujetosCandidatosClasificacion)))
%             sujetosCandidatosClasificacion(:,c) = pacienteClasificacionRandom;
%             c = c + 1;
%             j = j +1;
%         end
%     end



    for sujetos=1:length(sujetosCandidatos)



        [mDS3,mIS3,mDS4,mIS4,pS5,pS6,mDS7,mIS7,mDS8,mIS8,pS9,pS10,mDS11,mIS11,mDS12,mIS12,pS13,pS14] = obtenerDatosSesiones(sujetosCandidatos(sujetos));
%         [mDS3C,mIS3C,mDS4C,mIS4C,pS5C,pS6C,mDS7C,mIS7C,mDS8C,mIS8C,pS9C,pS10C,mDS11C,mIS11C,mDS12C,mIS12C,pS13C,pS14C] = obtenerDatosSesiones(sujetosCandidatosClasificacion(sujetos));

        pacienteManoDerecha = [mDS3 mDS4 mDS7 mDS8 mDS11 mDS12];
        pacienteManoIzquierda = [mIS3 mIS4 mIS7 mIS8 mIS11 mIS12];
        pacientePies = [pS5 pS6 pS9 pS10 pS13 pS14];

%         pacienteManoDerechaC = [mDS3C mDS4C mDS7C mDS8C mDS11C mDS12C];
%         pacienteManoIzquierdaC = [mIS3C mIS4C mIS7C mIS8C mIS11C mIS12C];
%         pacientePiesC = [pS5C pS6C pS9C pS10C pS13C pS14C];


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
            fullyConnectedLayer(4000,"Name","fc6","BiasLearnRateFactor",15)
            reluLayer("Name","relu6")
            dropoutLayer(0.2,"Name","drop6")
            fullyConnectedLayer(4000,"Name","fc7","BiasLearnRateFactor",15)
            reluLayer("Name","relu7")
            dropoutLayer(0.2,"Name","drop7")
            fullyConnectedLayer(3,"Name","fc8","BiasLearnRateFactor",15)
            softmaxLayer("Name","prob")
            classificationLayer("Name","output")];

        options = trainingOptions('sgdm', ...
            'MiniBatchSize',10, ...
            'MaxEpochs',15, ...
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

    tiradas(l,:) = [l datosSujetos(end,:)];
    l = l+1;
end
    