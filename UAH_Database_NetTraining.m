clc; close all; clear


etiquetaManoDerecha = 1;
etiquetaManoIzquierda = 2;
datosPaciente = zeros(13, 5);
f = 1;

for sujetos = 1:12
    if(sujetos<10)
        paciente = strcat('0', string(sujetos));
    else
        paciente = string(sujetos);
    end

    fileName = strcat('UAH_BCI_database_description\A',paciente, '_1.mat');
    muestra = importdata(fileName);

    datosCanal = muestra.canal([1,3],:); % Del fichero anterior únicamente nos quedamos con los valores que proporciona C3 y C4 que están en las filas 1 y 3

    contadorMuestra = 1;
    datosValidos = 511 + muestra.muestra(contadorMuestra); % Inicializamos esta variable a 512 porque es a partir de este indice donde los datos son válidos, a partir del segundo t = 4
    columnas = 60;
    filas = 641; % Esto sale de restar 512 al segundo indice de muestra.muestra. Es decir 1153-512 = 641. Esto se cumple con los demás indisces de esa variable
    datos = zeros(filas,columnas);


    % Creamos uma matriz de 641x60, que se rellena con los 641 datos que aporta
    % cada experimento.

    for i=1:columnas
        for j=1:filas
            datos(j,i) = datosCanal(datosValidos);
            datosValidos = datosValidos + 1;
        end
        contadorMuestra = contadorMuestra + 1;
    end

    % A partir de la matriz anterior realizamos la transformada de Fourier

    datosTransformadaFourier = real(fft(datos));

    % Creamos una matriz con la transformada de Fourier y el significado de
    % cada muestra

    tablaDatos = [datosTransformadaFourier ; muestra.clase];

    [numRows, numCols] = size(tablaDatos);

    manoDerecha = zeros(numRows, numCols/2);
    manoIzquierda = zeros(numRows, numCols/2);

    n=1;
    r = 1;
    l = 1;

    % Separamos los datos de la mano derecha de los de la mano izquierda

    while n <= numCols
        if(tablaDatos(end,n) == 1)
            manoDerecha(:,r) = tablaDatos(:,n);
            r = r + 1;
        else
            manoIzquierda(:,l) = tablaDatos(:,n);
            l = l + 1;
        end
        n = n + 1;
    end

    % Componemos una nueva matriz con una serie de datos para entrenar la red

    datosEntrenamientoRed = [manoDerecha(:,1:5:20) manoIzquierda(:,1:5:20) manoDerecha(:,1:2:20) manoIzquierda(:,1:2:20) manoDerecha(:,1:3:20) manoIzquierda(:,1:3:20)];

    % Indicamos las capas de la red nueronal AlexNet

    layers = [
        sequenceInputLayer(length(datosEntrenamientoRed)-1,"Name","sequence")
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
        fullyConnectedLayer(4000,"Name","fc6","BiasLearnRateFactor",10)
        reluLayer("Name","relu6")
        dropoutLayer(0.2,"Name","drop6")
        fullyConnectedLayer(4000,"Name","fc7","BiasLearnRateFactor",10)
        reluLayer("Name","relu7")
        dropoutLayer(0.2,"Name","drop7")
        fullyConnectedLayer(2,"Name","fc8","BiasLearnRateFactor",10)
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

    % Entrenamos la red con los datos mencionados anteriormente

    netTransfer = trainNetwork(datosEntrenamientoRed(1:end-1,:),categorical(datosEntrenamientoRed(end,:)),layers,options);

    % Utilizamos los datos que no se han utilizado en el entrenamiento para ver si se clasifican
    % correctamente

    [tasaAciertoMD, tasaFalloMD] = clasificadorDatos(netTransfer, manoDerecha, etiquetaManoDerecha);
    [tasaAciertoMI, tasaFalloMI] = clasificadorDatos(netTransfer, manoIzquierda, etiquetaManoIzquierda);

    datosPaciente(f,:) = [sujetos tasaAciertoMD tasaFalloMD tasaAciertoMI tasaFalloMI];
    f = f + 1;
end

datosPaciente(end, :) = [max(sujetos) mean(datosPaciente(:,2)) mean(datosPaciente(:,3)) mean(datosPaciente(:,4)) mean(datosPaciente(:,5))];
