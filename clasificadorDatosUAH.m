function [tasaAcierto,tasaFallo] = clasificadorDatosUAH(netTransfer, datosClasificar, etiqueta)

% Función encargada de contar los aciertos y los fallos a la hora de la
% clasificación en el fichero del banco de datos de la UAH. 

numAciertos = 0;
numFallos = 0;

class = classify(netTransfer, datosClasificar(1:end-1, 20:end));

for j=1:length(class)
    if(class(j) == categorical(etiqueta))
        numAciertos = numAciertos + 1;
    else
        numFallos = numFallos + 1;
    end
end

tasaAcierto = round((numAciertos/(numAciertos + numFallos)) * 100, 2);
tasaFallo = round((numFallos/(numAciertos + numFallos)) * 100, 2);

end

