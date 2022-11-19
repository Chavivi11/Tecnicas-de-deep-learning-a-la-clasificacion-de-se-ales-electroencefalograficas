function [pies] = rellenarMatrizDatosPies(data,anotaciones)
segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
tarea = anotaciones.Annotations(2:2:end);

% contadorSegundosValidos = 1;
% cont = 1;
t2 = 0;

for i=1:length(tarea)
    if(tarea(i) == "T2")
        t2 = t2+1;
    end
end

% Creamos las matrices que contendrán los valores de los canales C3, C4 y
% Cz, respectivamente
canalCz = rellenarMatriz(data.Cz__, tarea, t2, "T2", segundosValidos);
canalCzFiltro = bandpass(canalCz,[0.5,30],130);
canalCz = real(fft(canalCzFiltro));
canalCz(end+1,:) = 0;
pies = canalCz;
end

