function [manoIzquierda, manoDerecha] = rellenarMatrizDatosManos(data,anotaciones)

% Función encargada de rellenar las matrices con datos de las manos

segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
tarea = anotaciones.Annotations(2:2:end); % Va de 2 en 2 porque entre tarea y tarea hay un descanso
t1 = 0;
t2 = 0;

% Contabilizamos que tarea pertenece a la mano derecha y cual a la mano
% izquierda

for i=1:length(tarea)
    if(tarea(i) == "T1")
        t1 = t1+1;
    elseif(tarea(i) == "T2")
        t2 = t2+1;
    end
end

% Creamos la matriz C4 

canalC4 = rellenarMatriz(data.C4__, tarea, t1, "T1", segundosValidos);

% Aplicamos un filtro de paso banda para quedarnos con las bandas de
% frecuencia de 8 a 30 Hz

canalC4Filtro = bandpass(canalC4,[8,30],160);
[~,numCols] = size(canalC4Filtro);

% Aplicamos la transformada Wavelet en una dimensión.

for i=1:numCols
    [cC4, lC4] = wavedec(canalC4Filtro(:,i),1,'db2');
    c4Band = appcoef(cC4, lC4,'db2');
    c4(:,i) = c4Band;
end

% Al resultado, le aplicamos la FFT

canalC4 = abs(fft(c4));
canalC4(end+1,:) = 1;
manoIzquierda = canalC4;

% Creamos la matriz C3

canalC3 = rellenarMatriz(data.C3__, tarea, t2, "T2", segundosValidos);

% Aplicamos un filtro de paso banda para quedarnos con las bandas de
% frecuencia de 8 a 30 Hz

canalC3Filtro = bandpass(canalC3,[8,30],160);
[~,numCols] = size(canalC3Filtro);

% Aplicamos la transformada Wavelet en una dimensión.

for i=1:numCols
    [cC3, lC3] = wavedec(canalC3Filtro(:,i),1,'db2');
    c3Band = appcoef(cC3, lC3,'db2');
    c3(:,i) = c3Band;
end

% Al resultado, le aplicamos la FFT

canalC3 = abs(fft(c3));
canalC3(end+1,:) = 2;
manoDerecha = canalC3;

end

