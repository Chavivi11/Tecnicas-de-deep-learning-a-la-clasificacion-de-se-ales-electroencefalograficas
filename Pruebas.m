clc; close all; clear

muestra = importdata("UAH_BCI_database_description\A01_1.mat");

data = muestra.canal([1,3],:); % Del fichero anterior únicamente nos quedamos con los valores que proporciona C3 y C4 que están en las filas 1 y 3


columnas = 60;
filas = 641;
trainingData = zeros(filas,columnas);
contadorMuestra = 1;
datosValidos = 511 + muestra.muestra(contadorMuestra); % Inicializamos esta variable a 512 porque es a partir de este indice donde los datos son válidos

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

% Creamos un vector que transforme los datos de la clase por Strings para
% que sea más comprensible que significa cada dato

classNames = [];

for k=1:length(muestra.clase)
    if(muestra.clase(k) == 1)
        classNames = [classNames "Mano_Derecha"];
    else
        classNames = [classNames "Mano_Izquierda"];
    end
end

% Habría que filtrar y quedarnos unicamente con las frecuencias entre 12 y
% 33 Hz y posteriormente crear la matriz con todos los datos y el
% significado de esos datos (mano derecha o mano izquierda)

tablaDatosEntrenamiento = [datosTransformados ; classNames];
        

% for j = 1:length(Freq)
%     if(Freq(j)>12 & Freq(j)<33)
%         trainingData = [trainingData Freq(j)];
%     end
% end


layers = [
    sequenceInputLayer(1,"Name","sequence")
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

% netTransfer = trainNetwork(muestra.muestra,categorical(muestra.clase),layers,options);

% Para clasificarlo, sería la red neuronal el primer parámetro y el segundo
% serian todos los datos

% class = classify(netTransfer, muestra.clase);
% 
% figure
% % muestra.clase primer parámetro
% % segundo parámetro es la clase
% confusionchart(classNames,class)
