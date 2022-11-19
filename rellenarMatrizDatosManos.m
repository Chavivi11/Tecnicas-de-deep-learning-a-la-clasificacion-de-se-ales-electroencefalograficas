function [manoIzquierda, manoDerecha] = rellenarMatrizDatosManos(data,anotaciones)

segundosValidos = 1 + floor(seconds(anotaciones.Onset(2:2:end))); % Esto nos da las posiciones efectivas de data con datos
tarea = anotaciones.Annotations(2:2:end);

% contadorSegundosValidos = 1;
% cont = 1;
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
canalC4Filtro = bandpass(canalC4,[0.5,30],130);
canalC4 = real(fft(canalC4Filtro));
canalC4(end+1,:) = 1;
manoIzquierda = canalC4;

canalC3 = rellenarMatriz(data.C3__, tarea, t2, "T2", segundosValidos);
canalC3Filtro = bandpass(canalC3,[0.5,30],130);
canalC3 = real(fft(canalC3Filtro));
canalC3(end+1,:) = 2;
manoDerecha = canalC3;

% 
% % canalCz = zeros(length(data.Cz__{1,1})*4,length(segundosValidos));
% 
% n = 1;
% 
% while n <= t1
%     k = 1;
%     if(tarea(cont) == "T1")
%         for i=0:3
%             for j=1:length(data.C3__{1,1})
%                 canalC4(k,n) = data.C3__{segundosValidos(contadorSegundosValidos)+i,1}(j);
%                 k = k + 1;
%             end
%         end
%         n = n + 1;
%         contadorSegundosValidos = contadorSegundosValidos+1;
%         cont = cont + 1;
%     end
% end



































% [~, numCols] = size(canalC3);
% n = 1;
% 
% % Rellenamos las matrices con los datos que con datos sobre la imaginación
% % del movimiento de las manos derecha e izquierda
% while n <= numCols
%     k = 1;
%     for i=0:3
%         for j=1:length(data.C3__{1,1})
%             canalC3(k,n) = data.C3__{segundosValidos(contadorSegundosValidos)+i,1}(j);
%             canalC4(k,n) = data.C4__{segundosValidos(contadorSegundosValidos)+i,1}(j);
%             canalCz(k,n) = data.Cz__{segundosValidos(contadorSegundosValidos)+i,1}(j);
%             k = k + 1;
%         end
%     end
%     contadorSegundosValidos = contadorSegundosValidos+1;
%     n = n + 1;
% end
%     
% canalesPaciente = [canalC3;canalC4;canalCz];
% transformadaFourier = abs(fft(canalesPaciente));
% valor = transpose(anotaciones.Annotations(2:2:end));
% 
% [rows, cols] = size(valor);
% 
% significado = zeros(rows, cols);
% 
% for i=1:cols
%     if(valor(i) == "T1")
%         significado(i) = 1;
%     else
%         significado(i) = 2;
%     end
% end
% 
% % Componemos los datos del entrenamiento de la red neuronal con los valores
% % obtenidos, filtrados y aplicando la fft de los datos del canal y el
% % significado de estos
% datosEntrenamiento = [transformadaFourier ; significado];
end

