function [pies] = rellenarMatrizDatosPies(data,anotaciones)

% Función encargada de rellenar las matrices con datos de los pies

segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
tarea = anotaciones.Annotations(2:2:end); % Va de 2 en 2 porque entre tarea y tarea hay un descanso
t2 = 0;

% Contabilizamos que tarea pertenece a los pies

for i=1:length(tarea)
    if(tarea(i) == "T2")
        t2 = t2+1;
    end
end

% Creamos la matriz Cz

canalCz = rellenarMatriz(data.Cz__, tarea, t2, "T2", segundosValidos);

% Aplicamos un filtro de paso banda para quedarnos con las bandas de
% frecuencia de 8 a 30 Hz

canalCzFiltro = bandpass(canalCz,[8,30],160);
[~,numCols] = size(canalCzFiltro);

% Aplicamos la transformada Wavelet en una dimensión.

for i=1:numCols
    [cCz, lCz] = wavedec(canalCzFiltro(:,i),1,'db2');
    czBand = appcoef(cCz, lCz,'db2');
    cz(:,i) = czBand;
end

% Al resultado, le aplicamos la FFT

canalCz = abs(fft(cz));
canalCz(end+1,:) = 0;
pies = canalCz;
end

