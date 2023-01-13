function [datosEntrenamiento] = datosEntrenamienoRed(manoDerecha, manoIzquierda, pies)

% Funcion para crear los conjunmtos de datos para el entrenamiento de la
% red neuronal.

deDosEnDos = [manoDerecha(:,1:2:28) manoIzquierda(:,1:2:28) pies(:,1:2:28)];
deTresEnTres = [manoDerecha(:,1:3:27) manoIzquierda(:,1:3:27) pies(:,1:3:27)];
deCuatroEnCuatro = [manoDerecha(:,1:4:28) manoIzquierda(:,1:4:28) pies(:,1:4:28)];
deCincoEnCinco = [manoDerecha(:,1:5:25) manoIzquierda(:,1:5:25) pies(:,1:5:25)];
variosDatos = [manoDerecha(:,1:28) manoIzquierda(:,1:28) pies(:,1:28)];

datosEntrenamiento = [deDosEnDos deTresEnTres deCuatroEnCuatro deCincoEnCinco variosDatos];

end

