clc; close all; clear

muestra = importdata("UAH_BCI_database_description\A01_2.mat");

data = muestra.canal([1,3],:); % Del fichero anterior únicamente nos quedamos con los valores que proporciona C3 y C4 que están en las filas 1 y 3


contadorMuestra = 1;
datosValidos = 511 + muestra.muestra(contadorMuestra); % Inicializamos esta variable a 512 porque es a partir de este indice donde los datos son válidos, a partir del segundo t = 4
columnas = 60;
filas = 641; % Esto sale de restar 512 al segundo indice de muestra.muestra. Es decir 1153-512 = 641. Esto se cumple con los demás indisces de esa variable
trainingData = zeros(filas,columnas);

% Creamos uma matriz de 641x60, que se rellena con los 641 datos que aporta
% cada experimento.

for i=1:columnas    
    for j=1:filas
        trainingData(j,i) = data(datosValidos);
        datosValidos = datosValidos + 1;
    end
    contadorMuestra = contadorMuestra + 1;
end

% A partir de la matriz anterior realizamos la transformada de Fourier

datosTransformados = real(fft(trainingData));


% Habría que filtrar y quedarnos unicamente con las frecuencias entre 12 y
% 33 Hz y posteriormente crear la matriz con todos los datos y el
% significado de esos datos (mano derecha o mano izquierda)

% [numRows, numCols] = size(datosTransformados);

% datosFiltrados = zeros(numRows,numCols);
% 
% for l=1:numCols
%     for m=1:numRows
%     if(datosTransformados(m,l) > 12 && datosTransformados(m,l) < 33)
%         datosFiltrados(m,l) = datosTransformados(m,l);
%     end
%     end
% end


tablaDatosEntrenamiento = [datosTransformados ; muestra.clase];

[numRows, numCols] = size(tablaDatosEntrenamiento);

manoDerecha = zeros(numRows, numCols/2);
manoIzquierda = zeros(numRows, numCols/2);

n=1;
r = 1;
l = 1;

while n <= numCols
    if(tablaDatosEntrenamiento(end,n) == 1)
        manoDerecha(:,r) = tablaDatosEntrenamiento(:,n);
        r = r + 1;
    else
        manoIzquierda(:,l) = tablaDatosEntrenamiento(:,n);
        l = l + 1;
    end
    n = n + 1;
end


datosEntrenamiento = [manoDerecha(1:end,1:5:20) manoIzquierda(1:end,1:5:20) manoDerecha(1:end,1:2:20) manoIzquierda(1:end,1:2:20) manoDerecha(1:end,1:3:20) manoIzquierda(1:end,1:3:20)];

layers = [
    sequenceInputLayer(641,"Name","sequence")
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

% Hay que entrenar con una parte de los datos, ese es el primer parámetro
% El segundo parámetro serían las clases a las que pertenecen esos datos.
% Hacer el categorical de las clases
% El tercero sería las capas y el cuarto, las opciones

% (De que fila : hasta que fila, de que columna : hasta que columna) luego
% si se añaden los corchetes indicas qué columnas quieres. ej: tablaDatosEntrenamiento(1:end-1,[1,3,4,9,10,22,30])

netTransfer = trainNetwork(datosEntrenamiento(1:end-1,:),categorical(datosEntrenamiento(end,:)),layers,options);

% Para clasificarlo, sería la red neuronal el primer parámetro y el segundo
% serian todos los datos

class = classify(netTransfer, manoIzquierda(1:end-1,20:30));

figure
confusionchart(categorical(manoIzquierda(end,20:30)),class)
