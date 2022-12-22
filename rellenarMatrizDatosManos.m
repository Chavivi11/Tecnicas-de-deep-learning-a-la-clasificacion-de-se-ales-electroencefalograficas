function [manoIzquierda, manoDerecha] = rellenarMatrizDatosManos(data,anotaciones)

segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
tarea = anotaciones.Annotations(2:2:end);
t1 = 0;
t2 = 0;

for i=1:length(tarea)
    if(tarea(i) == "T1")
        t1 = t1+1;
    elseif(tarea(i) == "T2")
        t2 = t2+1;
    end
end

% Creamos las matrices que contendrán los valores de los canales C3, C4 y
% Cz, respectivamente

canalC4 = rellenarMatriz(data.C4__, tarea, t1, "T1", segundosValidos);
canalC4Filtro = bandpass(canalC4,[8,30],160);
[~,numCols] = size(canalC4Filtro);

for i=1:numCols
    [cC4, lC4] = wavedec(canalC4Filtro(:,i),1,'db2');
    c4Band = appcoef(cC4, lC4,'db2');
    c4(:,i) = c4Band;
end
canalC4 = abs(fft(c4));
canalC4(end+1,:) = 1;
manoIzquierda = canalC4;

canalC3 = rellenarMatriz(data.C3__, tarea, t2, "T2", segundosValidos);
canalC3Filtro = bandpass(canalC3,[8,30],160);
[~,numCols] = size(canalC3Filtro);

for i=1:numCols
    [cC3, lC3] = wavedec(canalC3Filtro(:,i),1,'db2');
    c3Band = appcoef(cC3, lC3,'db2');
    c3(:,i) = c3Band;
end
canalC3 = abs(fft(c3));
canalC3(end+1,:) = 2;
manoDerecha = canalC3;

end

