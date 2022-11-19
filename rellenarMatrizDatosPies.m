function [pies] = rellenarMatrizDatosPies(data,anotaciones)
segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
tarea = anotaciones.Annotations(2:2:end);


t2 = 0;

for i=1:length(tarea)
    if(tarea(i) == "T2")
        t2 = t2+1;
    end
end

% Creamos las matrices que contendrán los valores de los canales C3, C4 y
% Cz, respectivamente
canalCz = rellenarMatriz(data.Cz__, tarea, t2, "T2", segundosValidos);
canalCzFiltro = bandpass(canalCz,[0.5,30],160);

[~,numCols] = size(canalCzFiltro);

for i=1:numCols
    [cCz, lCz] = wavedec(canalCzFiltro(:,i),1,'db2');
    czBand = appcoef(cCz, lCz,'db2');
    cz(:,i) = czBand;
end

canalCz = abs(fft(cz));
canalCz(end+1,:) = 0;
pies = canalCz;
end

