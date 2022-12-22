function [datosEntrenamiento] = obtenerDatosEntrenamiento(data,anotaciones)

segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
contadorSegundosValidos = 1;

% Creamos las matrices que contendrán los valores de los canales C3, C4 y
% Cz, respectivamente
canalC3 = zeros(length(data.C3__{1,1})*4,length(segundosValidos));
canalC4 = zeros(length(data.C4__{1,1})*4,length(segundosValidos));
canalCz = zeros(length(data.Cz__{1,1})*4,length(segundosValidos));

[~, numCols] = size(canalC3);
n = 1;

% Rellenamos las matrices con los datos que con datos sobre la imaginación
% del movimiento de las manos derecha e izquierda
while n <= numCols
    k = 1;
    for i=0:3
        for j=1:length(data.C3__{1,1})
            canalC3(k,n) = data.C3__{segundosValidos(contadorSegundosValidos)+i,1}(j);
            canalC4(k,n) = data.C4__{segundosValidos(contadorSegundosValidos)+i,1}(j);
            canalCz(k,n) = data.Cz__{segundosValidos(contadorSegundosValidos)+i,1}(j);
            k = k + 1;
        end
    end
    contadorSegundosValidos = contadorSegundosValidos+1;
    n = n + 1;
end
    
canalesPaciente = [canalC3;canalC4;canalCz];
canalesPacienteFiltro = bandpass(canalesPaciente,[0.5,30],160);
[~,numCols] = size(canalesPacienteFiltro);

for i=1:numCols
    [cC, lC] = wavedec(canalesPacienteFiltro(:,i),1,'db2');
    cPacientesBand = appcoef(cC, lC,'db2');
    cPacientes(:,i) = cPacientesBand;
end
transformadaFourier = abs(fft(cPacientes));
valor = transpose(anotaciones.Annotations(2:2:end));

[rows, cols] = size(valor);

significado = zeros(rows, cols);

for i=1:cols
    if(valor(i) == "T1")
        significado(i) = 1;
    else
        significado(i) = 2;
    end
end

% Componemos los datos del entrenamiento de la red neuronal con los valores
% obtenidos, filtrados y aplicando la fft de los datos del canal y el
% significado de estos
datosEntrenamiento = [transformadaFourier ; significado];

end

